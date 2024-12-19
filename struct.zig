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
