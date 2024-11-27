const std = @import("std");
const expect = @import("std").testing.expect;
const mem = @import("std").mem;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}

test "comments" {
    const x = true;
    try expect(x);
}

test "string literal" {
    const byte = "hello";
    try expect(@TypeOf(byte) == *const [5:0]u8);
    try expect(byte.len == 5);
    try expect(byte[1] == 'e');
    try expect(byte[5] == 0);
    try expect('e' == '\x65');
    try expect('\u{1f4a9}' == 128169);
    try expect('💯' == 128175);
    try expect(mem.eql(u8, "hello", "h\x65llo"));
    try expect("\xff"[0] == 0xff);
}

test "increment" {
    var y: i32 = 134;
    y += 1;

    try expect(y == 135);
}
