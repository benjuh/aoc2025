const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

fn pickDigits(bank: []const u8, digits: []const u8, start: usize, batteries: usize, allocator: std.mem.Allocator) ![]const u8 {
    const n = digits.len;
    if (n == batteries) return digits;

    var candidate: u8 = '0';
    var index_of_candidate: usize = start;

    for (0..bank.len - (batteries - n) + 1) |i| {
        const val = bank[i];
        if (val > candidate) {
            candidate = val;
            index_of_candidate = i;
        }
    }

    const combined = try std.mem.concat(allocator, u8, &.{ digits, &[_]u8{candidate} });
    return pickDigits(bank[index_of_candidate + 1 ..], combined, index_of_candidate, batteries, allocator);
}

pub fn part1(banks: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    var sum: usize = 0;
    for (banks) |bank| {
        const digits = try pickDigits(bank, "", 0, 2, allocator);
        sum += try std.fmt.parseInt(usize, digits, 10);
    }
    return std.fmt.allocPrint(allocator, "{d}", .{sum});
}

pub fn part2(banks: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    var sum: usize = 0;
    for (banks) |bank| {
        const digits = try pickDigits(bank, "", 0, 12, allocator);
        sum += try std.fmt.parseInt(usize, digits, 10);
    }
    return std.fmt.allocPrint(allocator, "{d}", .{sum});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.lines(io, allocator, 3, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 3, p1, p2, t1s, t1e, t2s, t2e);
}
