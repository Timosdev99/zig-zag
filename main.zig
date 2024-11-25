const std = @import("std");

pub fn main() !void {
    // Simple print using debug
    std.debug.print("Hello, World!\n", .{});

    // Buffered writer setup
    var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
    const stdout = bw.writer();

    try stdout.print("running code base\n", .{});
    try bw.flush();
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.append(42);
}
