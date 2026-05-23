package day02

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
	"time"

	"aoc2025-go/common"
	"aoc2025-go/parse"
)

type Range struct {
	Start int
	End   int
}

func pow10(n int) int {
	p := 1
	for range n {
		p *= 10
	}
	return p
}

func getRanges(input string) []Range {
	ranges := []Range{}
	for s := range strings.SplitSeq(input, ",") {
		split := strings.Split(s, "-")
		start, _ := strconv.Atoi(split[0])
		end, _ := strconv.Atoi(split[1])
		ranges = append(ranges, Range{start, end})
	}
	return ranges
}

// Part1: a 2d-digit half-repeat number has form S*(10^d+1) for d-digit S.
// Sum analytically over each range — no per-number iteration.
func Part1(input string) string {
	ranges := getRanges(input)
	total := 0
	for _, r := range ranges {
		for d := 1; d <= 10; d++ {
			factor := pow10(d) + 1
			sMin := 1
			if d > 1 {
				sMin = pow10(d - 1)
			}
			sMax := pow10(d) - 1
			sLo := (r.Start + factor - 1) / factor
			sHi := r.End / factor
			if sLo < sMin {
				sLo = sMin
			}
			if sHi > sMax {
				sHi = sMax
			}
			if sLo > sHi {
				continue
			}
			count := sHi - sLo + 1
			total += factor * (sLo+sHi) * count / 2
		}
	}
	return fmt.Sprintf("%d", total)
}

// generateInvalid2 enumerates all numbers whose digit string is tiled by a
// proper prefix of length k (1 ≤ k ≤ n/2, k|n). The number equals P *
// (10^n-1)/(10^k-1) for each k-digit pattern P. Deduplicates via map.
func generateInvalid2(maxVal int) []int {
	seen := make(map[int]struct{})
	for n := 2; n <= 20; n++ {
		if pow10(n-1) > maxVal {
			break
		}
		for k := 1; k <= n/2; k++ {
			if n%k != 0 {
				continue
			}
			factor := (pow10(n) - 1) / (pow10(k) - 1)
			pMin := 1
			if k > 1 {
				pMin = pow10(k - 1)
			}
			pMax := pow10(k) - 1
			for p := pMin; p <= pMax; p++ {
				num := p * factor
				if num <= maxVal {
					seen[num] = struct{}{}
				}
			}
		}
	}
	nums := make([]int, 0, len(seen))
	for n := range seen {
		nums = append(nums, n)
	}
	sort.Ints(nums)
	return nums
}

// Part2: enumerate all tile-repeat numbers up to max range end, sort with
// prefix sums, then binary-search each range for O(log n) per range.
func Part2(input string) string {
	ranges := getRanges(input)
	maxVal := 0
	for _, r := range ranges {
		if r.End > maxVal {
			maxVal = r.End
		}
	}

	inv2 := generateInvalid2(maxVal)
	prefix := make([]int, len(inv2)+1)
	for i, v := range inv2 {
		prefix[i+1] = prefix[i] + v
	}

	total := 0
	for _, r := range ranges {
		lo := sort.SearchInts(inv2, r.Start)
		hi := sort.SearchInts(inv2, r.End+1)
		total += prefix[hi] - prefix[lo]
	}
	return fmt.Sprintf("%d", total)
}

func Run() {
	input := parse.String(2, false)

	t1s := time.Now()
	p1 := Part1(input)
	t1 := time.Since(t1s)

	t2s := time.Now()
	p2 := Part2(input)
	t2 := time.Since(t2s)

	common.RunDay(2, p1, p2, t1, t2)
}
