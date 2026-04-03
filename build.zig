const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dozy_dep = b.dependency("dozy", .{
        .target = target,
        .optimize = optimize,
    });
    const dozy_mod = dozy_dep.module("dozy");

    const game_mod = b.addModule("game", .{ .root_source_file = b.path("src/root.zig"), .target = target, .imports = &.{
        .{ .name = "dozy", .module = dozy_mod },
    } });

    const game_exe = b.addExecutable(.{
        .name = "dozy_tech_demo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "dozy", .module = dozy_mod },
                .{ .name = "game", .module = game_mod },
            },
        }),
    });

    b.installArtifact(game_exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(game_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    run_step.dependOn(&run_cmd.step);

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
