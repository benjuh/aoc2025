package day06

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

const IS_TEST = false

type Problem struct {
	nums []int
	op   string
}

type Grid struct {
	rows [][]int
	ops  []string
}

func parseRow(line string) []int {
	fields := strings.Fields(line)
	nums := make([]int, len(fields))
	for i, f := range fields {
		nums[i], _ = strconv.Atoi(f)
	}
	return nums
}

func parseGrid(input []string) Grid {
	numRows := len(input) - 1
	rows := make([][]int, numRows)
	for i := range numRows {
		rows[i] = parseRow(input[i])
	}
	return Grid{rows: rows, ops: strings.Fields(input[numRows])}
}

func parseProblems(input []string) []Problem {
	var problems []Problem
	var currentCols []string

	width := len(input[0])
	for i := range width {
		var b strings.Builder
		for j := range input {
			if i < len(input[j]) {
				b.WriteByte(input[j][i])
			}
		}
		col := b.String()

		allSpace := strings.Count(col, " ") == len(col)
		if !allSpace {
			currentCols = append(currentCols, col)
		}
		if (allSpace || i == width-1) && len(currentCols) > 0 {
			problems = append(problems, buildProblem(currentCols))
			currentCols = nil
		}
	}
	return problems
}

func buildProblem(cols []string) Problem {
	first := cols[0]
	op := string(first[len(first)-1])
	cols[0] = first[:len(first)-1]

	nums := make([]int, 0, len(cols))
	for _, col := range cols {
		trimmed := strings.TrimSpace(col)
		if trimmed == "" {
			continue
		}
		num, err := strconv.Atoi(trimmed)
		if err != nil {
			panic(err)
		}
		nums = append(nums, num)
	}
	return Problem{nums: nums, op: op}
}

func applyOp(op string, nums []int) int {
	if op == "+" {
		sum := 0
		for _, n := range nums {
			sum += n
		}
		return sum
	}
	product := 1
	for _, n := range nums {
		product *= n
	}
	return product
}

func Part1(input []string) string {
	grid := parseGrid(input)
	sum := 0
	for i, op := range grid.ops {
		col := make([]int, len(grid.rows))
		for j, row := range grid.rows {
			col[j] = row[i]
		}
		sum += applyOp(op, col)
	}
	return fmt.Sprintf("%d", sum)
}

func Part2(input []string) string {
	problems := parseProblems(input)
	sum := 0
	for _, p := range problems {
		sum += applyOp(p.op, p.nums)
	}
	return fmt.Sprintf("%d", sum)
}

func Run() {
	input := parse.Lines(6, IS_TEST)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(6, p1, p2, t1, t2)
}
