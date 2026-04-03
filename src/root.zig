const std = @import("std");

pub fn printHelloWorld() void {
    std.log.info("Hello world!", .{});
}
