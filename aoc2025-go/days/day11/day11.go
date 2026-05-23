package day11

import (
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

func Part1(input []string) string {
	_ = input
	return ""
}

func Part2(input []string) string {
	_ = input
	return ""
}

func Run() {
	input := parse.Lines(11, false)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(11, p1, p2, t1, t2)
}
