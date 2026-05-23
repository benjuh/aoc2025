const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

pub fn part1(input: [][]const u8) ![]const u8 {
    _ = input;
    return "";
}

pub fn part2(input: [][]const u8) ![]const u8 {
    _ = input;
    return "";
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.lines(io, allocator, 10, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 10, p1, p2, t1s, t1e, t2s, t2e);
}
