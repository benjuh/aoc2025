package parse

import (
	"fmt"
	"os"
	"strings"
)

func path(day int, isTest bool) string {
	if isTest {
		return fmt.Sprintf("../data/day%02d_test.txt", day)
	}
	return fmt.Sprintf("../data/day%02d.txt", day)
}

func String(day int, isTest bool) string {
	p := path(day, isTest)
	data, err := os.ReadFile(p)
	if err != nil {
		fmt.Fprintf(os.Stderr, "missing input: %s\n", p)
		os.Exit(1)
	}
	return strings.TrimSpace(string(data))
}

func Lines(day int, isTest bool) []string {
	return strings.Split(String(day, isTest), "\n")
}

func Sections(day int, isTest bool) [][]string {
	raw := String(day, isTest)
	parts := strings.Split(raw, "\n\n")
	sections := make([][]string, len(parts))
	for i, part := range parts {
		sections[i] = strings.Split(strings.TrimSpace(part), "\n")
	}
	return sections
}

func PrintString(s string) {
	fmt.Println(s)
}

func PrintLines(lines []string) {
	for _, line := range lines {
		fmt.Printf("%s\n", line)
	}
}
