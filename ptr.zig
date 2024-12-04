const expect = @import("std").testing.expect;
const std = @import("std");

test "address of syntax" {
    const x: i32 = 1234;
    const x_ptr = &x;

    try expect(x_ptr.* == 1234);

    try expect(@TypeOf(x_ptr) == *const i32);

    var y: i32 = 5678;
    const y_ptr = &y;
    try expect(@TypeOf(y_ptr) == *i32);
    y_ptr.* += 1;
    try expect(y_ptr.* == 5679);
}

test "pointer array access" {
    var array = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const ptr = &array[2];
    try expect(@TypeOf(ptr) == *u8);

    try expect(array[2] == 3);
    ptr.* += 1;
    try expect(array[2] == 4);
}

test "pointer slicing" {
    var array = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const slice = array[2..4];
    try expect(slice.len == 2);

    try expect(array[3] == 4);
    slice[1] += 1;
    try expect(array[3] == 5);
}

test "comptime pointers" {
    comptime {
        var x: i32 = 1;
        const ptr = &x;
        ptr.* += 1;
        x += 1;
        try expect(ptr.* == 3);
    }
}

// test "topointer and toInt" {
//     const point =  @ptrFromInt(*i32, 0xdeadbee0);
//     const addr = @intFromPtr(point);
//     try expect(@TypeOf(addr) == usize);
//     try expect(addr == 0xdeadbee0);
// }

test "pointer casting" {
    const bytes align(@alignOf(u32)) = [_]u8{ 0x12, 0x12, 0x12, 0x12 };
    const u32_value = std.mem.bytesAsSlice(u32, bytes[0..])[0];
    try expect(u32_value == 0x12121212);
}

test "variable alignment" {
    var x: i32 = 1234;
    const align_of_i32 = @alignOf(@TypeOf(x));
    try expect(@TypeOf(&x) == *i32);
    try expect(*i32 == *align(align_of_i32) i32);
    // if (std.Target.current.cpu.arch == .x86_64) {
    //     try expect(@typeInfo(*i32).Pointer.alignment == 4);
    // }
}
