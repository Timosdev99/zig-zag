const std = @import("std");
const expect = std.testing.expect;

const point = struct { x: f32, y: f32 };

const point2 = packed struct { x: f32, y: f32 };

const p = point{ .x = 1.00, .y = 7.00 };

const p2 = point{ .x = 4.00, .y = undefined };

const vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) vec3 {
        return vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn dot(self: vec3, other: vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }
};

test "dot product" {
    const v1 = vec3.init(1.0, 0.0, 0.0);
    const v2 = vec3.init(0.0, 1.0, 0.0);

    try expect(vec3.dot(v1, v2) == 0.0);
}
const Empty = struct {
    pub const PI = 3.14;
};
test "struct namespaced variable" {
    try expect(Empty.PI == 3.14);
    try expect(@sizeOf(Empty) == 0);

    const does_nothing = Empty{};

    _ = does_nothing;
}

// in Zig:
fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last: ?*Node,
        len: usize,
    };
}

test "linked list" {
    try expect(LinkedList(i32) == LinkedList(i32));

    const list = LinkedList(i32){
        .first = null,
        .last = null,
        .len = 0,
    };
    try expect(list.len == 0);

    const ListOfInts = LinkedList(i32);
    try expect(ListOfInts == LinkedList(i32));

    var node = ListOfInts.Node{
        .prev = null,
        .next = null,
        .data = 1234,
    };
    const list2 = LinkedList(i32){
        .first = &node,
        .last = &node,
        .len = 1,
    };

    try expect(list2.first.?.data == 1234);
}

//bad default value
const assert = @import("std").debug.assert;

const threshold = struct {
    minimum: f32,
    maximum: f32,

    const default: threshold = .{
        .minimum = 0.25,
        .maximum = 0.75,
    };
    const category = enum { low, medium, high };

    fn categorize(t: threshold, value: f32) category {
        assert(t.maximum > t.minimum);
        if (value > t.minimum) return .low;
        if (value > t.maximum) return .high;
        return .medium;
    }
};

// initailizing
const treehold = struct {
    max: f32,
    min: f32,

    const classes = enum { high, low, mid };

    fn init(x: f32, y: f32) treehold {
        return treehold{ .max = x, .min = y };
    }

    fn class(t: treehold, val: f32) classes {
        if (val > t.max) return .high;
        if (val < t.min) return .low;
        return .mid;
    }
};

pub fn main() !void {
    var Threshold: threshold = .{
        .minimum = undefined,
        .maximum = 0.20,
    };
    const category = Threshold.categorize(0.90);

    try std.io.getStdOut().writeAll(@tagName(category));

    var tree = treehold.init(4.0, 7.0);
    const class = tree.class(1);

    try std.io.getStdOut().writeAll((@tagName(class)));
}

// test packed struct

const native_endian = @import("builtin").target.cpu.arch.endian();

const Full = packed struct {
    number: u16,
};
const Divided = packed struct {
    half1: u8,
    quarter3: u4,
    quarter4: u4,
};

test "@bitCast between packed structs" {
    try doTheTest();
    try comptime doTheTest();
}

fn doTheTest() !void {
    try expect(@sizeOf(Full) == 2);
    try expect(@sizeOf(Divided) == 2);
    const full = Full{ .number = 0x1234 };
    const divided: Divided = @bitCast(full);
    try expect(divided.half1 == 0x34);
    try expect(divided.quarter3 == 0x2);
    try expect(divided.quarter4 == 0x1);

    const ordered: [2]u8 = @bitCast(full);
    switch (native_endian) {
        .big => {
            try expect(ordered[0] == 0x12);
            try expect(ordered[1] == 0x34);
        },
        .little => {
            try expect(ordered[0] == 0x34);
            try expect(ordered[1] == 0x12);
        },
    }
}

const BitField = packed struct {
    a: u3,
    b: u3,
    c: u2,
};

test "offsets of non-byte-aligned fields" {
    comptime {
        try expect(@bitOffsetOf(BitField, "a") == 0);
        try expect(@bitOffsetOf(BitField, "b") == 3);
        try expect(@bitOffsetOf(BitField, "c") == 6);

        try expect(@offsetOf(BitField, "a") == 0);
        try expect(@offsetOf(BitField, "b") == 0);
        try expect(@offsetOf(BitField, "c") == 0);
    }
}

const S = packed struct { b: u32, a: u32 };

test "overaligned pointer to packed struct" {
    var foo: S align(4) = .{ .a = 1, .b = 2 };
    const ptr: *align(4) S = &foo;
    const ptr_to_b: *u32 = &ptr.b;
    try expect(ptr_to_b.* == 2);
}

test "fully anon struct" {
    try check(.{ .float = @as(f32, 12.00), .int = @as(u32, 12), .b = true, .s = "hi" });
}

fn check(argrs: anytype) !void {
    try expect(argrs.float == 12.00);
    try expect(argrs.int == 12);
    try expect(argrs.b);
    try expect(argrs.s[0] == 'h');
    try expect(argrs.s[1] == 'i');
}

const complextypetag = enum {
    ok,
    notok,
};

const complex = union(complextypetag) { ok: u8, notok: bool };

test "checking" {
    const c = complex{ .ok = 42 };
    switch (c) {
        complextypetag.ok => |*val| val.* += 1,
        complextypetag.notok => unreachable,
    }

    try expect(c.ok == 43);
}
