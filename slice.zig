const std = @import("std");
const expectequal = std.testing.expectEqualSlices;
const expect = std.testing.expect;
const mem = std.mem;
const fmt = std.fmt;

test "slice array" {
    var array = [_]i32{ 1, 2, 3, 4, 5 };
    var know_in_runtime: usize = 0;
    _ = &know_in_runtime;
    const slice = array[know_in_runtime..array.len];
    const altslice: []const i32 = &.{ 1, 2, 3, 4, 5 };

    try expectequal(i32, slice, altslice);
    try expect(@TypeOf(slice) == []i32);
}

test "using slices for strings" {
    const hello: []const u8 = "hello";
    const world: []const u8 = "世界";

    var all_together: [100]u8 = undefined;

    var start: usize = 0;
    _ = &start;
    const all_together_slice = all_together[start..];
    const hello_world = try fmt.bufPrint(all_together_slice, "{s} {s}", .{ hello, world });

    try expect(mem.eql(u8, hello_world, "hello 世界"));
}

test "slice pointer" {
    var array: [10]u8 = undefined;
    const ptr = &array;
    try expect(@TypeOf(ptr) == *[10]u8);

    var start: usize = 0;
    var end: usize = 5;
    _ = .{ &start, &end };
    const slice = ptr[start..end];
    try expect(@TypeOf(slice) == []u8);
    slice[2] = 3;
    try expect(array[2] == 3);

    const ptr2 = slice[2..3];
    try expect(ptr2.len == 1);
    try expect(ptr2[0] == 3);
    try expect(@TypeOf(ptr2) == *[1]u8);
}

test "0-terminated slicing" {
    var array = [_]u8{ 3, 2, 1, 0, 3, 2, 1, 0 };
    var runtime_length: usize = 3;
    _ = &runtime_length;
    const slice = array[0..runtime_length :0];

    try expect(@TypeOf(slice) == [:0]u8);
    try expect(slice.len == 3);
}
