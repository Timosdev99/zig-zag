const std = @import("std");
const expectequal = std.testing.expectEqualSlices;
const expect = std.testing.expect;

test "slice array" {
    var array = [_]i32{ 1, 2, 3, 4, 5 };
    var know_in_runtime: usize = 0;
    _ = &know_in_runtime;
    const slice = array[know_in_runtime..array.len];
    const altslice: []const i32 = &.{ 1, 2, 3, 4, 5 };

    try expectequal(i32, slice, altslice);
    try expect(@TypeOf(slice) == []i32);
}
