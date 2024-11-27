const std = @import("std");
const expect = @import("std").testing.expect;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}

test "comments" {
    // Comments in Zig start with "//" and end at the next LF byte (end of line).
    // The below line is a comment, and won't be executed.

    //expect(false);

    const x = true; // another comment
    try expect(x);
}
