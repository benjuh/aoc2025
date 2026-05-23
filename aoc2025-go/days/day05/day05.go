package day05

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

const IS_TEST = false

type Range struct {
	Start int
	End   int
}

func parseRanges(lines []string) []Range {
	ranges := make([]Range, 0, len(lines))
	for _, line := range lines {
		r := strings.SplitN(line, "-", 2)
		start, _ := strconv.Atoi(r[0])
		end, _ := strconv.Atoi(r[1])
		ranges = append(ranges, Range{start, end})
	}
	return ranges
}

func Part1(input [][]string) string {
	ranges := parseRanges(input[0])
	total := 0
	for _, line := range input[1] {
		id, _ := strconv.Atoi(line)
		for _, r := range ranges {
			if id >= r.Start && id <= r.End {
				total++
				break
			}
		}
	}
	return fmt.Sprintf("%d", total)
}

func Part2(input [][]string) string {
	ranges := parseRanges(input[0])
	sort.Slice(ranges, func(i, j int) bool {
		return ranges[i].Start < ranges[j].Start
	})

	i := 0
	for i+1 < len(ranges) {
		a, b := ranges[i], ranges[i+1]
		if b.Start <= a.End {
			if b.End > a.End {
				ranges[i].End = b.End
			}
			ranges = append(ranges[:i+1], ranges[i+2:]...)
		} else {
			i++
		}
	}

	total := 0
	for _, r := range ranges {
		total += r.End - r.Start + 1
	}
	return fmt.Sprintf("%d", total)
}

func Run() {
	input := parse.Sections(5, IS_TEST)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(5, p1, p2, t1, t2)
}
