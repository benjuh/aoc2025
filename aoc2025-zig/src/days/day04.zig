const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

const directions = [8][2]i32{
    .{ 0, 1 },  .{ 1, 0 },
    .{ 0, -1 }, .{ -1, 0 },
    .{ 1, 1 },  .{ -1, 1 },
    .{ 1, -1 }, .{ -1, -1 },
};

fn countAdjacentPapers(board: anytype, x: usize, y: usize) usize {
    const rows = board.len;
    const cols = board[0].len;
    var count: usize = 0;
    for (directions) |dir| {
        const nx = @as(i32, @intCast(x)) + dir[0];
        const ny = @as(i32, @intCast(y)) + dir[1];
        if (nx >= 0 and nx < @as(i32, @intCast(rows)) and
            ny >= 0 and ny < @as(i32, @intCast(cols)))
        {
            if (board[@intCast(nx)][@intCast(ny)] == '@') count += 1;
        }
    }
    return count;
}

pub fn part1(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    const rows = input.len;
    const cols = input[0].len;
    var count: usize = 0;
    for (0..rows) |i| {
        for (0..cols) |j| {
            if (input[i][j] == '@' and countAdjacentPapers(input, i, j) <= 3) {
                count += 1;
            }
        }
    }
    return std.fmt.allocPrint(allocator, "{d}", .{count});
}

pub fn part2(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    const rows = input.len;
    const cols = input[0].len;

    const board = try allocator.alloc([]u8, rows);
    for (input, 0..) |line, i| {
        board[i] = try allocator.dupe(u8, line);
    }

    var total: usize = 0;
    var changed = true;
    while (changed) {
        changed = false;
        var queue: std.ArrayList([2]usize) = .empty;
        defer queue.deinit(allocator);
        for (0..rows) |i| {
            for (0..cols) |j| {
                if (board[i][j] == '@' and countAdjacentPapers(board, i, j) <= 3) {
                    total += 1;
                    changed = true;
                    try queue.append(allocator, .{ i, j });
                }
            }
        }
        for (queue.items) |loc| {
            board[loc[0]][loc[1]] = '.';
        }
    }
    return std.fmt.allocPrint(allocator, "{d}", .{total});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.lines(io, allocator, 4, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 4, p1, p2, t1s, t1e, t2s, t2e);
}
