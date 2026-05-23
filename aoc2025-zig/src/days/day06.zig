const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

const Problem = struct {
    nums: []i64,
    op: u8,
};

fn parseRow(line: []const u8, allocator: std.mem.Allocator) ![]i64 {
    var nums: std.ArrayList(i64) = .empty;
    var it = std.mem.tokenizeScalar(u8, line, ' ');
    while (it.next()) |token| {
        const n = try std.fmt.parseInt(i64, token, 10);
        try nums.append(allocator, n);
    }
    return nums.toOwnedSlice(allocator);
}

fn applyOp(op: u8, nums: []const i64) i64 {
    if (op == '+') {
        var sum: i64 = 0;
        for (nums) |n| sum += n;
        return sum;
    }
    var product: i64 = 1;
    for (nums) |n| product *= n;
    return product;
}

pub fn part1(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    // Last row is ops; all prior rows are number rows.
    const num_rows = input.len - 1;

    const rows = try allocator.alloc([]i64, num_rows);
    for (input[0..num_rows], 0..) |line, i| {
        rows[i] = try parseRow(line, allocator);
    }

    var ops: std.ArrayList(u8) = .empty;
    var ops_it = std.mem.tokenizeScalar(u8, input[num_rows], ' ');
    while (ops_it.next()) |token| {
        try ops.append(allocator, token[0]);
    }

    const col_buf = try allocator.alloc(i64, num_rows);
    var sum: i64 = 0;
    for (ops.items, 0..) |op, i| {
        for (rows, 0..) |row, j| col_buf[j] = row[i];
        sum += applyOp(op, col_buf);
    }

    return std.fmt.allocPrint(allocator, "{d}", .{sum});
}

pub fn part2(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    const width = input[0].len;
    var problems: std.ArrayList(Problem) = .empty;
    var current_cols: std.ArrayList([]u8) = .empty;

    for (0..width) |i| {
        // Build vertical slice: one char per row at column i.
        const col = try allocator.alloc(u8, input.len);
        for (input, 0..) |row, j| {
            col[j] = if (i < row.len) row[i] else ' ';
        }

        var all_space = true;
        for (col) |c| {
            if (c != ' ') {
                all_space = false;
                break;
            }
        }

        if (!all_space) try current_cols.append(allocator, col);

        if ((all_space or i == width - 1) and current_cols.items.len > 0) {
            // First col's last char is the operator; strip it before parsing.
            const first = current_cols.items[0];
            const op = first[first.len - 1];
            first[first.len - 1] = ' ';

            var nums: std.ArrayList(i64) = .empty;
            for (current_cols.items) |col_str| {
                const trimmed = std.mem.trim(u8, col_str, " ");
                if (trimmed.len == 0) continue;
                const n = try std.fmt.parseInt(i64, trimmed, 10);
                try nums.append(allocator, n);
            }

            try problems.append(allocator, Problem{
                .nums = try nums.toOwnedSlice(allocator),
                .op = op,
            });
            current_cols = .empty;
        }
    }

    var sum: i64 = 0;
    for (problems.items) |p| sum += applyOp(p.op, p.nums);

    return std.fmt.allocPrint(allocator, "{d}", .{sum});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.lines(io, allocator, 6, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 6, p1, p2, t1s, t1e, t2s, t2e);
}
