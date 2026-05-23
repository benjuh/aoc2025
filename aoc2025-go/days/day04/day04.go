package day04

import (
	"fmt"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

var board [][]byte

func buildBoard(input []string) {
	board = make([][]byte, len(input))
	for i, line := range input {
		board[i] = []byte(line)
	}
}

var directions = [8][2]int{
	{0, 1},
	{1, 0},
	{0, -1},
	{-1, 0},
	{1, 1},
	{-1, 1},
	{1, -1},
	{-1, -1},
}

type Location struct {
	x, y int
}

func countAdjacentPapers(x, y, rows, cols int) int {
	adjacentPapers := 0
	for _, dir := range directions {
		nx, ny := x+dir[0], y+dir[1]
		if nx >= 0 && nx < rows && ny >= 0 && ny < cols {
			if board[nx][ny] == '@' {
				adjacentPapers++
			}
		}
	}
	return adjacentPapers
}

func PrintBoard() {
	for _, line := range board {
		fmt.Printf("%s\n", line)
	}
}

func Part1(input []string) string {
	buildBoard(input)
	rows, cols := len(board), len(board[0])
	accessiblePapers := 0
	for i := range rows {
		for j := range cols {
			if board[i][j] == '@' && countAdjacentPapers(i, j, rows, cols) <= 3 {
				accessiblePapers++
			}
		}
	}
	return fmt.Sprintf("%d", accessiblePapers)
}

func Part2(input []string) string {
	buildBoard(input)
	rows, cols := len(board), len(board[0])
	accessiblePapers := 0
	changes := 0
	hasStarted := false
	for changes > 0 || !hasStarted {
		hasStarted = true
		changes = 0
		queue := make([]Location, 0, rows*cols/8)
		for i := range rows {
			for j := range cols {
				if board[i][j] == '@' && countAdjacentPapers(i, j, rows, cols) <= 3 {
					accessiblePapers++
					changes++
					queue = append(queue, Location{i, j})
				}
			}
		}
		for _, loc := range queue {
			board[loc.x][loc.y] = '.'
		}
	}
	return fmt.Sprintf("%d", accessiblePapers)
}

func Run() {
	input := parse.Lines(4, false)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(4, p1, p2, t1, t2)
}
