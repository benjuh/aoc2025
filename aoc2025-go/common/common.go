package common

import (
	"fmt"
	"strings"
	"time"
)

const (
	blazingFast = 0
	okayTime    = 200
	badTime     = 500
)

const (
	bold    = "\033[1m"
	grey    = "\033[90m"
	green   = "\033[32m"
	orange  = "\033[33m"
	red     = "\033[31m"
	blazing = "\033[38;5;155m"
	reset   = "\033[0m"
)

func GetString(data []byte) string {
	return strings.TrimSpace(string(data))
}

func GetStringArray(data []byte) []string {
	return strings.Split(GetString(data), "\n")
}

func PrintHeader(day int, lang string) {
	fmt.Printf("\n%s[%s %sDay %02d %s%s]%s\n", grey, reset, bold, day, grey, reset, reset)
	fmt.Printf("%s%s%s\n", grey, lang, reset)
}

func timeColor(d time.Duration) string {
	ms := d.Milliseconds()
	switch {
	case ms == blazingFast:
		return blazing
	case ms < okayTime:
		return green
	case ms < badTime:
		return orange
	default:
		return red
	}
}

func PrintAnswer(part1, part2 string, time1, time2 time.Duration) {
	c1 := timeColor(time1)
	c2 := timeColor(time2)
	fmt.Printf("  %s%-12s%s  %sPart 1: %s%s\n", c1, time1, reset, bold, reset, part1)
	fmt.Printf("  %s%-12s%s  %sPart 2: %s%s\n", c2, time2, reset, bold, reset, part2)
}

func RunDay(day int, part1, part2 string, time1, time2 time.Duration) {
	PrintHeader(day, "Go")
	PrintAnswer(part1, part2, time1, time2)
}
