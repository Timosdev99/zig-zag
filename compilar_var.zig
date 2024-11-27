const std = @import("std");
const expect = std.testing.expect;

test "compiler var" {
    var x: i32 = 1;
    comptime var y: i32 = 1;

    x += 1;
    y += 1;

    try expect(x == 2);
    try expect(y == 2);

    if (y != 2) {
        @compileError("wrong y value");
    }
}
