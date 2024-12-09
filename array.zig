const assert = @import("std").debug.assert;
const expect = @import("std").testing.expect;
const mem = @import("std").mem;

const array = [_]u8{ 'h', 'e', 'l', 'l', 'o' };

comptime {
    assert(array.len == 5);
}

const string_message = "hello";

comptime {
    assert(mem.eql(u8, &array, string_message));
}

test "iterate over an array" {
    var sum: usize = 0;
    for (array) |byte| {
        sum += byte;
    }
    try expect(sum == 'h' + 'e' + 'l' * 2 + 'o');
}

// var some_integers: [100]i32 = undefined;

// test "modify an array" {
//     for (some_integers) |i| {
//         const int: i32 = undefined;
//         const item = &int;
//         //const intCast = @import("intCast");
//         item.* = @intCast(i32, i);
//     }
//     try expect(some_integers[10] == 10);
//     try expect(some_integers[99] == 99);
// }

const part_one = [_]i32{ 1, 2, 3, 4 };
const part_two = [_]i32{ 5, 6, 7, 8 };
const all_of_it = part_one ++ part_two;
comptime {
    assert(mem.eql(i32, &all_of_it, &[_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 }));
}

const hello = "hello";
const world = "world";
const hello_world = hello ++ " " ++ world;
comptime {
    assert(mem.eql(u8, hello_world, "hello world"));
}

const pattern = "ab" ** 3;
comptime {
    assert(mem.eql(u8, pattern, "ababab"));
}

const all_zero = [_]u16{0} ** 10;

comptime {
    assert(all_zero.len == 10);
    assert(all_zero[5] == 0);
}

// var more_points = [_]Point{makePoint(3)} ** 10;
// fn makePoint(x: i32) Point {
//     return Point{
//         .x = x,
//         .y = x * 2,
//     };
// }
// test "array initialization with function calls" {
//     try expect(more_points[4].x == 3);
//     try expect(more_points[4].y == 6);
//     try expect(more_points.len == 10);
// }

var myarray: [4]u8 = .{ 11, 22, 33, 44 };

test "anonymous list literal syntax" {
    try expect(myarray[0] == 11);
    try expect(myarray[1] == 22);
    try expect(myarray[2] == 33);
    try expect(myarray[3] == 44);
}

test "fully anonymous list literal" {
    try dump(.{ @as(u32, 1234), @as(f64, 12.34), true, "hi" });
}

fn dump(args: anytype) !void {
    try expect(args.@"0" == 1234);
    try expect(args.@"1" == 12.34);
    try expect(args.@"2");
    try expect(args.@"3"[0] == 'h');
    try expect(args.@"3"[1] == 'i');
}

const nullarray = [_:0]u8{ 1, 2, 3, 4 };

test "null terminated array" {
    try expect(@TypeOf(nullarray) == [4:0]u8);
    try expect(nullarray.len == 4);
    try expect(nullarray[4] == 0);
}
