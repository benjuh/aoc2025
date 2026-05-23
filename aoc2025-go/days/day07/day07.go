package day07

import (
	"fmt"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

type Position struct {
	row, col int
}

func getStart(board []string) Position {
	for row := range board {
		for col, c := range board[row] {
			if c == 'S' {
				return Position{row, col}
			}
		}
	}
	panic("no start")
}

func inBounds(board []string, row, col int) bool {
	return row >= 0 && row < len(board) && col >= 0 && col < len(board[row])
}

func countSplits(board []string, pos Position, visited map[Position]struct{}) int {
	splits := 0
	for {
		if _, seen := visited[pos]; seen {
			return splits
		}
		visited[pos] = struct{}{}

		nextRow := pos.row + 1
		if !inBounds(board, nextRow, pos.col) {
			return splits
		}

		if board[nextRow][pos.col] == '^' {
			splits++
			if inBounds(board, nextRow, pos.col-1) {
				splits += countSplits(board, Position{nextRow, pos.col - 1}, visited)
			}
			if inBounds(board, nextRow, pos.col+1) {
				splits += countSplits(board, Position{nextRow, pos.col + 1}, visited)
			}
			return splits
		}
		pos.row = nextRow
	}
}

func countPaths(board []string, pos Position, memo map[Position]int) int {
	var straight []Position
	for {
		if val, exists := memo[pos]; exists {
			for _, p := range straight {
				memo[p] = val
			}
			return val
		}

		nextRow := pos.row + 1
		if !inBounds(board, nextRow, pos.col) {
			for _, p := range straight {
				memo[p] = 1
			}
			memo[pos] = 1
			return 1
		}

		if board[nextRow][pos.col] == '^' {
			result := 0
			if inBounds(board, nextRow, pos.col-1) {
				result += countPaths(board, Position{nextRow, pos.col - 1}, memo)
			}
			if inBounds(board, nextRow, pos.col+1) {
				result += countPaths(board, Position{nextRow, pos.col + 1}, memo)
			}
			memo[pos] = result
			for _, p := range straight {
				memo[p] = result
			}
			return result
		}

		straight = append(straight, pos)
		pos.row = nextRow
	}
}

func Part1(board []string) string {
	visited := make(map[Position]struct{})
	splits := countSplits(board, getStart(board), visited)
	return fmt.Sprintf("%d", splits)
}

func Part2(board []string) string {
	memo := make(map[Position]int)
	count := countPaths(board, getStart(board), memo)
	return fmt.Sprintf("%d", count)
}

func Run() {
	input := parse.Lines(7, false)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(7, p1, p2, t1, t2)
}
