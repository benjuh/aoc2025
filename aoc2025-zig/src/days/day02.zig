const std = @import("std");
const common = @import("../common.zig");
const parse = @import("../parse.zig");

const Range = struct {
    start: u64,
    end: u64,
};

fn pow10(n: usize) u64 {
    var p: u64 = 1;
    for (0..n) |_| p *= 10;
    return p;
}

pub fn getRanges(input: []const u8, allocator: std.mem.Allocator) ![]Range {
    var ranges: std.ArrayList(Range) = .empty;
    var it = std.mem.splitScalar(u8, input, ',');
    while (it.next()) |range| {
        var it2 = std.mem.splitScalar(u8, range, '-');
        if (it2.next()) |start_str| {
            if (it2.next()) |end_str| {
                const l = std.fmt.parseInt(u64, start_str, 10) catch continue;
                const r = std.fmt.parseInt(u64, end_str, 10) catch continue;
                try ranges.append(allocator, .{ .start = l, .end = r });
            }
        }
    }
    return ranges.toOwnedSlice(allocator);
}

fn lowerBound(nums: []const u64, target: u64) usize {
    var lo: usize = 0;
    var hi: usize = nums.len;
    while (lo < hi) {
        const mid = lo + (hi - lo) / 2;
        if (nums[mid] < target) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    return lo;
}

// Part1: a 2d-digit half-repeat number has form S*(10^d+1) for d-digit S.
// Sum analytically — no per-number iteration.
pub fn part1(input: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    const ranges = try getRanges(input, allocator);
    defer allocator.free(ranges);

    var total: u64 = 0;
    for (ranges) |r| {
        var d: usize = 1;
        while (d <= 10) : (d += 1) {
            const factor = pow10(d) + 1;
            const s_min: u64 = if (d == 1) 1 else pow10(d - 1);
            const s_max: u64 = pow10(d) - 1;
            if (s_min * factor > r.end) break;

            const s_lo_raw = (r.start + factor - 1) / factor;
            const s_hi_raw = r.end / factor;
            const s_lo = @max(s_lo_raw, s_min);
            const s_hi = @min(s_hi_raw, s_max);
            if (s_lo > s_hi) continue;

            const count = s_hi - s_lo + 1;
            total += factor * (s_lo + s_hi) * count / 2;
        }
    }
    return std.fmt.allocPrint(allocator, "{d}", .{total});
}

// generateInvalid2: enumerate all numbers whose digit string is tiled by a
// proper prefix of length k (1 ≤ k ≤ n/2, k|n). Number = P*(10^n-1)/(10^k-1).
// Deduplicates via hash map, returns sorted owned slice.
fn generateInvalid2(max_val: u64, allocator: std.mem.Allocator) ![]u64 {
    var seen = std.AutoHashMap(u64, void).init(allocator);
    defer seen.deinit();

    var n: usize = 2;
    while (n <= 20) : (n += 1) {
        if (pow10(n - 1) > max_val) break;
        var k: usize = 1;
        while (k <= n / 2) : (k += 1) {
            if (n % k != 0) continue;
            const factor = (pow10(n) - 1) / (pow10(k) - 1);
            const p_min: u64 = if (k == 1) 1 else pow10(k - 1);
            const p_max: u64 = pow10(k) - 1;
            var p = p_min;
            while (p <= p_max) : (p += 1) {
                const num = p * factor;
                if (num <= max_val) {
                    try seen.put(num, {});
                }
            }
        }
    }

    var nums: std.ArrayList(u64) = .empty;
    var it = seen.keyIterator();
    while (it.next()) |key| {
        try nums.append(allocator, key.*);
    }
    const slice = try nums.toOwnedSlice(allocator);
    std.mem.sort(u64, slice, {}, std.sort.asc(u64));
    return slice;
}

// Part2: enumerate all tile-repeat numbers up to max range end, sort with
// prefix sums, then binary-search each range — O(log n) per range.
pub fn part2(input: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    const ranges = try getRanges(input, allocator);
    defer allocator.free(ranges);

    var max_val: u64 = 0;
    for (ranges) |r| {
        if (r.end > max_val) max_val = r.end;
    }

    const inv2 = try generateInvalid2(max_val, allocator);
    defer allocator.free(inv2);

    const prefix = try allocator.alloc(u64, inv2.len + 1);
    defer allocator.free(prefix);
    prefix[0] = 0;
    for (inv2, 0..) |v, i| {
        prefix[i + 1] = prefix[i] + v;
    }

    var total: u64 = 0;
    for (ranges) |r| {
        const lo = lowerBound(inv2, r.start);
        const hi = lowerBound(inv2, r.end + 1);
        total += prefix[hi] - prefix[lo];
    }
    return std.fmt.allocPrint(allocator, "{d}", .{total});
}

pub fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    const input = try parse.string(io, allocator, 2, false);

    const t1s = std.Io.Timestamp.now(io, .awake);
    const p1 = try part1(input, allocator);
    const t1e = std.Io.Timestamp.now(io, .awake);

    const t2s = std.Io.Timestamp.now(io, .awake);
    const p2 = try part2(input, allocator);
    const t2e = std.Io.Timestamp.now(io, .awake);

    common.runDay(io, 2, p1, p2, t1s, t1e, t2s, t2e);
}
