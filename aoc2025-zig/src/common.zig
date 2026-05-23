const std = @import("std");

pub const Color = struct {
    pub const bold = "\x1b[1m";
    pub const grey = "\x1b[90m";
    pub const green = "\x1b[32m";
    pub const orange = "\x1b[33m";
    pub const red = "\x1b[31m";
    pub const blazing = "\x1b[38;5;155m";
    pub const reset = "\x1b[0m";
};

const blazing_fast_ms: i96 = 0;
const okay_ms: i96 = 200;
const bad_ms: i96 = 500;

pub fn getString(data: []const u8) []const u8 {
    return std.mem.trimEnd(u8, data, "\n\r ");
}

pub fn getStringArray(allocator: std.mem.Allocator, data: []const u8) ![][]const u8 {
    const trimmed = getString(data);
    var list: std.ArrayList([]const u8) = .empty;
    var it = std.mem.splitScalar(u8, trimmed, '\n');
    while (it.next()) |line| {
        try list.append(allocator, std.mem.trimEnd(u8, line, "\r\t "));
    }
    return list.toOwnedSlice(allocator);
}

fn timeColor(d: std.Io.Duration) []const u8 {
    const ms = @divTrunc(d.nanoseconds, std.time.ns_per_ms);
    if (ms == blazing_fast_ms) return Color.blazing;
    if (ms < okay_ms) return Color.green;
    if (ms < bad_ms) return Color.orange;
    return Color.red;
}

fn fmtDuration(d: std.Io.Duration, buf: []u8) []const u8 {
    const ns: u64 = @intCast(@max(0, d.nanoseconds));
    const ms = ns / std.time.ns_per_ms;
    const us = (ns % std.time.ns_per_ms) / std.time.ns_per_us;
    if (ms > 0) {
        return std.fmt.bufPrint(buf, "{d}ms", .{ms}) catch buf[0..0];
    }
    return std.fmt.bufPrint(buf, "{d}\xc2\xb5s", .{us}) catch buf[0..0];
}

pub fn printHeader(day: u8) void {
    std.debug.print("\n{s}[{s} {s}Day {d:0>2} {s}{s}]{s}\n", .{
        Color.grey, Color.reset, Color.bold, day, Color.grey, Color.reset, Color.reset,
    });
    std.debug.print("{s}Zig{s}\n", .{ Color.grey, Color.reset });
}

pub fn printAnswer(part1: []const u8, part2: []const u8, d1: std.Io.Duration, d2: std.Io.Duration) void {
    var buf1: [32]u8 = undefined;
    var buf2: [32]u8 = undefined;
    const s1 = fmtDuration(d1, &buf1);
    const s2 = fmtDuration(d2, &buf2);
    const c1 = timeColor(d1);
    const c2 = timeColor(d2);

    std.debug.print("  {s}{s:<12}{s}  {s}Part 1: {s}{s}\n", .{ c1, s1, Color.reset, Color.bold, Color.reset, part1 });
    std.debug.print("  {s}{s:<12}{s}  {s}Part 2: {s}{s}\n", .{ c2, s2, Color.reset, Color.bold, Color.reset, part2 });
}

pub fn runDay(
    io: std.Io,
    day: u8,
    part1: []const u8,
    part2: []const u8,
    t1_start: std.Io.Timestamp,
    t1_end: std.Io.Timestamp,
    t2_start: std.Io.Timestamp,
    t2_end: std.Io.Timestamp,
) void {
    _ = io;
    printHeader(day);
    printAnswer(part1, part2, t1_start.durationTo(t1_end), t2_start.durationTo(t2_end));
}
