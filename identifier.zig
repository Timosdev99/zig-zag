const std = @import("std");
const @"i dont give a fuk" = 0xff;
const @"what the fuk" = 1122;
const c = @import("std").c;
pub extern "c" fn @"error"() void;
pub extern "c" fn @"fstat$INODE64"(fd: c.fd_t, buf: *c.Stat) c_int;

const Color = enum {
    red,
    @"really red",
};
const color: Color = .@"really red";

pub fn main() void {
    std.debug.print("printed\n", .{});
}
