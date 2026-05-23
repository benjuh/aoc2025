const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

const Instruction = struct { direction: i2, distance: i32 };

pub fn getInstructions(input: [][]const u8, allocator: std.mem.Allocator) ![]Instruction {
    var instructions: std.ArrayList(Instruction) = .empty;
    for (input) |line| {
        var direction: i2 = 1;
        if (line[0] == 'L') {
            direction = -1;
        }
        const distance = std.fmt.parseInt(i32, line[1..], 10) catch unreachable;
        try instructions.append(allocator, Instruction{ .direction = direction, .distance = distance });
    }

    return instructions.toOwnedSlice(allocator);
}

pub fn rotate(instruction: Instruction, current: i32) i32 {
    var res: i32 = current;
    if (instruction.distance >= current and instruction.direction == -1) {
        const difference: i32 = instruction.distance - current;
        res = 100 - @mod(difference, 100);
    } else if (current + instruction.distance >= 100 and instruction.direction == 1) {
        const sum = current + instruction.distance;
        res = @mod(sum - 100, 100);
    } else {
        res = current + (instruction.distance * instruction.direction);
    }

    if (res == -100 or res == 100) {
        res = 0;
    }

    return res;
}

pub fn rotate2(instruction: Instruction, current: i32) struct { dial_value: i32, zero_crossings: usize } {
    var zero_crossings: usize = 0;
    var res: i32 = current;

    if (instruction.direction == -1) {
        if (instruction.distance >= current) {
            if (current != 0 and @mod(instruction.distance, 100) >= current) {
                zero_crossings += 1;
            }
            zero_crossings += @intCast(@divFloor(instruction.distance, 100));
            res = 100 - (@mod(instruction.distance, 100) - current);
        } else {
            res = @mod(current - instruction.distance, 100);
        }
    } else {
        const amount_needed = 100 - current;
        if (instruction.distance >= amount_needed) {
            if (current != 0 and @mod(instruction.distance, 100) >= amount_needed) {
                zero_crossings += 1;
            }
            zero_crossings += @intCast(@divFloor(instruction.distance, 100));
            res = @mod(instruction.distance + current, 100);
        } else {
            res = current + @mod(instruction.distance, 100);
        }
    }

    res = @mod(res, 100);
    return .{ .dial_value = res, .zero_crossings = zero_crossings };
}

const START_VALUE = 50;

pub fn part1(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    const instructions = try getInstructions(input, allocator);

    var res: i32 = START_VALUE;
    var zero_hits: usize = 0;

    for (instructions) |instruction| {
        res = rotate(instruction, res);
        if (res == 0) {
            zero_hits += 1;
        }
    }

    return std.fmt.allocPrint(allocator, "{d}", .{zero_hits});
}

pub fn part2(input: [][]const u8, allocator: std.mem.Allocator) ![]const u8 {
    const instructions = try getInstructions(input, allocator);

    var dial: i32 = START_VALUE;
    var zero_crossings: usize = 0;

    for (instructions) |instruction| {
        const result = rotate2(instruction, dial);
        dial = result.dial_value;
        zero_crossings += result.zero_crossings;
    }
    return std.fmt.allocPrint(allocator, "{d}", .{zero_crossings});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.lines(io, allocator, 1, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 1, p1, p2, t1s, t1e, t2s, t2e);
}
