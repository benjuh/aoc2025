# Advent of Code 2025

Dual Go + Zig solutions with a unified CLI runner.

## Usage

```
./aoc [DAY | START-END] [-n N] [-a] [-b]
```

### Modes

| Command | Description |
|---|---|
| `./aoc` | Benchmark all days (10 iterations each) |
| `./aoc 1-12` | Benchmark days 1–12 |
| `./aoc 7` | Show answers for day 7 |
| `./aoc 7 -b` | Benchmark day 7 (50 iterations) |

### Flags

| Flag | Default | Description |
|---|---|---|
| `-n N` / `--iterations N` | 10 (range), 50 (single `-b`) | Iterations per day |
| `-a` / `--show-answers` | off | Print answers alongside benchmark times |
| `-b` / `--benchmark` | off | Benchmark a single day instead of showing answers |
| `-h` / `--help` | | Show usage |

### Examples

```bash
# Show answers for day 1
./aoc 1

# Benchmark days 1–5, 20 iterations
./aoc 1-5 -n 20

# Benchmark day 4, show answers too
./aoc 4 -b -a

# Full benchmark, all days, 50 iterations
./aoc -n 50
```

### Benchmark output

```
  Day    Pt    Go (avg×10)    Zig (avg×10)    Faster
  ───────────────────────────────────────────────────
  Day 1  P1         96.9µs          51.0µs   Zig 1.90x
         P2         96.9µs          62.2µs   Zig 1.56x
  ...
  ───────────────────────────────────────────────────
  Total  P1        1.087ms         581.9µs
         P2       14.646ms          7.879ms
  Binary             2.5MB          456.2KB

  ×10 iterations per day
```

Times are parsed from each binary's internal timer, excluding process startup overhead.

## Requirements

- Go 1.21+
- Zig 0.14+ (built with `zig build -Doptimize=ReleaseFast`)

## Structure

```
aoc          # CLI runner script
aoc2025-go/  # Go solutions (days 1–12)
aoc2025-zig/ # Zig solutions (days 1–25)
data/        # Puzzle inputs (dayNN.txt) and test inputs (dayNN_test.txt)
```
