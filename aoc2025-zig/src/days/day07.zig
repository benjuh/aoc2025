const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

const Position = struct {
    row: usize,
    col: usize,
};

fn getStart(board: [][]const u8) Position {
    for (board, 0..) |line, row| {
        for (line, 0..) |c, col| {
            if (c == 'S') return .{ .row = row, .col = col };
        }
    }
    unreachable;
}

fn inBounds(board: [][]const u8, row: isize, col: isize) bool {
    if (row < 0 or col < 0) return false;
    const r: usize = @intCast(row);
    if (r >= board.len) return false;
    const c: usize = @intCast(col);
    return c < board[r].len;
}

fn countSplits(
    board: [][]const u8,
    start: Position,
    visited: *std.AutoHashMap(Position, void),
    allocator: std.mem.Allocator,
) !usize {
    var pos = start;
    var splits: usize = 0;
    while (true) {
        const entry = try visited.getOrPut(pos);
        if (entry.found_existing) return splits;

        const next_row: isize = @as(isize, @intCast(pos.row)) + 1;
        if (!inBounds(board, next_row, @intCast(pos.col))) return splits;

        const nr: usize = @intCast(next_row);
        if (board[nr][pos.col] == '^') {
            splits += 1;
            const lc: isize = @as(isize, @intCast(pos.col)) - 1;
            const rc: isize = @as(isize, @intCast(pos.col)) + 1;
            if (inBounds(board, next_row, lc)) {
                splits += try countSplits(board, .{ .row = nr, .col = @intCast(lc) }, visited, allocator);
            }
            if (inBounds(board, next_row, rc)) {
                splits += try countSplits(board, .{ .row = nr, .col = @intCast(rc) }, visited, allocator);
            }
            return splits;
        }
        pos.row = nr;
    }
}

fn countPaths(
    board: [][]const u8,
    start: Position,
    memo: *std.AutoHashMap(Position, usize),
    allocator: std.mem.Allocator,
) !usize {
    var straight: std.ArrayList(Position) = .empty;
    defer straight.deinit(allocator);

    var pos = start;
    while (true) {
        if (memo.get(pos)) |val| {
            for (straight.items) |p| try memo.put(p, val);
            return val;
        }

        const next_row: isize = @as(isize, @intCast(pos.row)) + 1;
        if (!inBounds(board, next_row, @intCast(pos.col))) {
            for (straight.items) |p| try memo.put(p, 1);
            try memo.put(pos, 1);
            return 1;
        }

        const nr: usize = @intCast(next_row);
        if (board[nr][pos.col] == '^') {
            var result: usize = 0;
            const lc: isize = @as(isize, @intCast(pos.col)) - 1;
            const rc: isize = @as(isize, @intCast(pos.col)) + 1;
            if (inBounds(board, next_row, lc)) {
                result += try countPaths(board, .{ .row = nr, .col = @intCast(lc) }, memo, allocator);
            }
            if (inBounds(board, next_row, rc)) {
                result += try countPaths(board, .{ .row = nr, .col = @intCast(rc) }, memo, allocator);
            }
            try memo.put(pos, result);
            for (straight.items) |p| try memo.put(p, result);
            return result;
        }

        try straight.append(allocator, pos);
        pos.row = nr;
    }
}

pub fn part1(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    var visited = std.AutoHashMap(Position, void).init(allocator);
    defer visited.deinit();
    const splits = try countSplits(input, getStart(input), &visited, allocator);
    return std.fmt.allocPrint(allocator, "{d}", .{splits});
}

pub fn part2(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    var memo = std.AutoHashMap(Position, usize).init(allocator);
    defer memo.deinit();
    const count = try countPaths(input, getStart(input), &memo, allocator);
    return std.fmt.allocPrint(allocator, "{d}", .{count});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.lines(io, allocator, 7, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 7, p1, p2, t1s, t1e, t2s, t2e);
}
