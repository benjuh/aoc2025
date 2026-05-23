const std = @import("std");
const day01 = @import("days/day01.zig");
const day02 = @import("days/day02.zig");
const day03 = @import("days/day03.zig");
const day04 = @import("days/day04.zig");
const day05 = @import("days/day05.zig");
const day06 = @import("days/day06.zig");
const day07 = @import("days/day07.zig");
const day08 = @import("days/day08.zig");
const day09 = @import("days/day09.zig");
const day10 = @import("days/day10.zig");
const day11 = @import("days/day11.zig");
const day12 = @import("days/day12.zig");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(arena);

    if (args.len < 2) {
        std.debug.print("usage: aoc2025-zig <day>\n", .{});
        return error.InvalidArgs;
    }

    const day = std.fmt.parseInt(u8, args[1], 10) catch {
        std.debug.print("invalid day: {s}\n", .{args[1]});
        return error.InvalidArgs;
    };

    switch (day) {
        1 => try day01.run(io, arena),
        2 => try day02.run(io, arena),
        3 => try day03.run(io, arena),
        4 => try day04.run(io, arena),
        5 => try day05.run(io, arena),
        6 => try day06.run(io, arena),
        7 => try day07.run(io, arena),
        8 => try day08.run(io, arena),
        9 => try day09.run(io, arena),
        10 => try day10.run(io, arena),
        11 => try day11.run(io, arena),
        12 => try day12.run(io, arena),
        else => std.debug.print("day {d} not implemented\n", .{day}),
    }
}
