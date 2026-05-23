package day01

import (
	"fmt"
	"strconv"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

const DIAL_START = 50

type Rotation struct {
	direction int
	rotations int
}

func get_directions(input []string) []Rotation {
	var directions []Rotation
	for _, line := range input {
		direction := 1
		if line[0] == 'L' {
			direction = -1
		}
		rotations, _ := strconv.Atoi(line[1:])
		directions = append(directions, Rotation{direction, rotations})
	}
	return directions

}

func rotate_dial(r Rotation, current int) int {
	res := current
	if r.rotations >= current && r.direction == -1 {
		difference := r.rotations - current
		res = 100 - (difference % 100)
	} else if current+r.rotations >= 100 && r.direction == 1 {
		sum := current + r.rotations
		res = (sum - 100) % 100
	} else {
		res = current + (r.rotations * r.direction)
	}
	if res == -100 || res == 100 {
		res = 0
	}

	return res
}

func rotate_dial2(r Rotation, current int) (int, int) {
	zero_crossings := 0
	var res int
	if r.direction == -1 {
		if r.rotations >= current {
			if current != 0 && r.rotations%100 >= current {
				zero_crossings += 1
			}
			zero_crossings += r.rotations / 100
			res = 100 - ((r.rotations % 100) - current)
		} else {
			res = (current - r.rotations) % 100
		}
	} else {
		amount_needed := 100 - current
		if r.rotations >= amount_needed {
			if current != 0 && r.rotations%100 >= amount_needed {
				zero_crossings += 1
			}
			zero_crossings += r.rotations / 100
			res = (r.rotations + current) % 100
		} else {
			res = r.rotations + current%100
		}

	}
	res = res % 100

	return res, zero_crossings
}

func Part1(input []string) string {
	_ = input
	directions := get_directions(input)
	zero_hits := 0
	current := DIAL_START
	for _, d := range directions {
		current = rotate_dial(d, current)
		if current == 0 {
			zero_hits++
		}
	}

	return fmt.Sprintf("%d", zero_hits)
}

func Part2(input []string) string {
	directions := get_directions(input)
	zero_hits := 0
	current := DIAL_START
	for _, d := range directions {
		res, zero_crossings := rotate_dial2(d, current)
		zero_hits += zero_crossings
		current = res
	}
	return fmt.Sprintf("%d", zero_hits)
}

func Run() {
	input := parse.Lines(1, false)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(1, p1, p2, t1, t2)
}
