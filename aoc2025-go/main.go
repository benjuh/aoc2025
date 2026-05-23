package main

import (
	"fmt"
	"os"
	"strconv"

	"aoc2025-go/days/day01"
	"aoc2025-go/days/day02"
	"aoc2025-go/days/day03"
	"aoc2025-go/days/day04"
	"aoc2025-go/days/day05"
	"aoc2025-go/days/day06"
	"aoc2025-go/days/day07"
	"aoc2025-go/days/day08"
	"aoc2025-go/days/day09"
	"aoc2025-go/days/day10"
	"aoc2025-go/days/day11"
	"aoc2025-go/days/day12"
)

type runFn func()

var days = map[int]runFn{
	1:  day01.Run,
	2:  day02.Run,
	3:  day03.Run,
	4:  day04.Run,
	5:  day05.Run,
	6:  day06.Run,
	7:  day07.Run,
	8:  day08.Run,
	9:  day09.Run,
	10: day10.Run,
	11: day11.Run,
	12: day12.Run,
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: aoc2025-go <day>")
		os.Exit(1)
	}
	day, err := strconv.Atoi(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "invalid day: %s\n", os.Args[1])
		os.Exit(1)
	}
	fn, ok := days[day]
	if !ok {
		fmt.Fprintf(os.Stderr, "day %d not implemented\n", day)
		os.Exit(1)
	}
	fn()
}
