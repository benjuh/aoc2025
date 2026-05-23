const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

const Range = struct {
    start: usize,
    end: usize,
};

fn parseRanges(lines: [][]const u8, allocator: std.mem.Allocator) !std.ArrayList(Range) {
    var ranges: std.ArrayList(Range) = .empty;
    for (lines) |line| {
        const dash = std.mem.indexOfScalar(u8, line, '-') orelse continue;
        const start = try std.fmt.parseInt(usize, line[0..dash], 10);
        const end = try std.fmt.parseInt(usize, line[dash + 1 ..], 10);
        try ranges.append(allocator, Range{ .start = start, .end = end });
    }
    return ranges;
}

pub fn part1(input: [][][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    var ranges = try parseRanges(input[0], allocator);
    defer ranges.deinit(allocator);

    var total: usize = 0;
    for (input[1]) |line| {
        const id = try std.fmt.parseInt(usize, line, 10);
        for (ranges.items) |r| {
            if (id >= r.start and id <= r.end) {
                total += 1;
                break;
            }
        }
    }
    return std.fmt.allocPrint(allocator, "{d}", .{total});
}

pub fn part2(input: [][][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    var ranges = try parseRanges(input[0], allocator);
    defer ranges.deinit(allocator);

    std.mem.sort(Range, ranges.items, {}, struct {
        fn lt(_: void, a: Range, b: Range) bool {
            return a.start < b.start;
        }
    }.lt);

    var i: usize = 0;
    while (i + 1 < ranges.items.len) {
        const a = ranges.items[i];
        const b = ranges.items[i + 1];
        if (b.start <= a.end) {
            ranges.items[i] = Range{ .start = a.start, .end = @max(a.end, b.end) };
            _ = ranges.orderedRemove(i + 1);
        } else {
            i += 1;
        }
    }

    var total: usize = 0;
    for (ranges.items) |r| {
        total += r.end - r.start + 1;
    }
    return std.fmt.allocPrint(allocator, "{d}", .{total});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.sections(io, allocator, 5, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 5, p1, p2, t1s, t1e, t2s, t2e);
}
