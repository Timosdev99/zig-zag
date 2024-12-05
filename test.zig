const std = @import("std");
const expect = std.testing.expect;
const builtin = @import("builtin");

test "detect leak" {
    var list = std.ArrayList(u21).init(std.testing.allocator);
    defer list.deinit();
    try list.append('☔');

    try expect(list.items.len == 1);
}

test "this will be skipped" {
    return error.SkipZigTest;
}

test "detect builtin" {
    try expect(istest() == true);
}

fn istest() bool {
    return builtin.is_test;
}

test "expectEqual demo" {
    const expected: i32 = 42;
    const actual = 42;

    try std.testing.expectEqual(expected, actual);
}

test "expectError demo" {
    const expected_error = error.DemoError;
    const actual_error_union: anyerror!void = error.DemoError;
    try std.testing.expectError(expected_error, actual_error_union);
}

var y: i32 = add(10, x);
const x: i32 = add(12, 34);

test "container level variables" {
    try expect(x == 46);
    try expect(y == 56);
}

fn add(a: i32, b: i32) i32 {
    return a + b;
}
