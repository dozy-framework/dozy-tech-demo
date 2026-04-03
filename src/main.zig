const dozy = @import("dozy");
const game = @import("game");

pub fn main() void {
    game.printHelloWorld();
    dozy.start();
}
