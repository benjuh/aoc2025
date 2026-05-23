package day03

import (
	"fmt"
	"strconv"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

func getValueOfDigit(voltage byte) int {
	return int(voltage - ZERO)
}

const ZERO = 48

func pickDigit(bank string, chosen_digits string, start int, batteries int) string {
	n := len(chosen_digits)
	if n == batteries {
		return chosen_digits
	}
	candidate := byte('0')
	index_of_candidate := start

	for i := 0; i <= len(bank)-(batteries-n); i++ {
		val := byte(bank[i])
		if getValueOfDigit(val) > getValueOfDigit(candidate) {
			candidate = val
			index_of_candidate = i
		}
	}

	return pickDigit(bank[index_of_candidate+1:], chosen_digits+string(candidate), index_of_candidate, batteries)

}

func Part1(banks []string) string {
	var sum int
	for _, bank := range banks {
		chosen_digits := pickDigit(bank, "", 0, 2)
		value, _ := strconv.Atoi(chosen_digits)
		sum += value
	}
	return fmt.Sprintf("%d", sum)
}

func Part2(banks []string) string {
	var sum int
	for _, bank := range banks {
		chosen_digits := pickDigit(bank, "", 0, 12)
		value, _ := strconv.Atoi(chosen_digits)
		sum += value
	}

	return fmt.Sprintf("%d", sum)
}

func Run() {
	input := parse.Lines(3, false)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(3, p1, p2, t1, t2)
}
