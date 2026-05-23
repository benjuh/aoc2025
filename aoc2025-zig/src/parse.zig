const std = @import("std");
const common = @import("common.zig");

pub fn string(io: std.Io, allocator: std.mem.Allocator, day: u8, is_test: bool) ![]const u8 {
    var path_buf: [48]u8 = undefined;
    const suffix: []const u8 = if (is_test) "_test" else "";
    const path = try std.fmt.bufPrint(&path_buf, "../data/day{d:0>2}{s}.txt", .{ day, suffix });
    const raw = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .unlimited) catch |err| {
        std.debug.print("missing input: {s}\n", .{path});
        return err;
    };
    return std.mem.trimEnd(u8, raw, "\n\r \t");
}

pub fn lines(io: std.Io, allocator: std.mem.Allocator, day: u8, is_test: bool) ![][]const u8 {
    const raw = try string(io, allocator, day, is_test);
    return common.getStringArray(allocator, raw);
}

pub fn sections(io: std.Io, allocator: std.mem.Allocator, day: u8, is_test: bool) ![][][]const u8 {
    const raw = try string(io, allocator, day, is_test);
    var result: std.ArrayList([][]const u8) = .empty;
    var block_it = std.mem.splitSequence(u8, raw, "\n\n");
    while (block_it.next()) |block| {
        const trimmed = std.mem.trim(u8, block, "\n\r \t");
        const block_lines = try common.getStringArray(allocator, trimmed);
        try result.append(allocator, block_lines);
    }
    return result.toOwnedSlice(allocator);
}

pub fn printString(s: []const u8) void {
    std.debug.print("{s}\n", .{s});
}

pub fn printLines(ls: [][]const u8) void {
    for (ls, 0..) |line, i| {
        std.debug.print("{d}: {s}\n", .{ i, line });
    }
}
