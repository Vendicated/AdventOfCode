package main

// It would have been simpler to just build a tree, then traverse it
// first in post order to calculate the size of each directory, then
// in pre order to find the directories matching the criteria.
// But I wanted to do it with a flat map

import (
	"bufio"
	"fmt"
	"os"
	"path"
	"strconv"
	"strings"
)

const SizeThreshold = 100000
const NeededSpace = 30000000
const TotalSpace = 70000000

func Unwrap[T any](v T, err error) T {
	if err != nil {
		panic(err)
	}
	return v
}

func run(file string) {
	f := Unwrap(os.Open(file))
	defer f.Close()

	scanner := bufio.NewScanner(f)
	scanner.Split(bufio.ScanLines)

	sizes := make(map[string]int)
	currentPath := ""

	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "$ cd ") {
			dest := line[5:]
			currentPath = path.Join(currentPath, dest)
		} else if line != "$ ls" {
			dirOrSize := strings.Split(line, " ")[0]
			if dirOrSize != "dir" {
				sizes[currentPath] += Unwrap(strconv.Atoi(dirOrSize))
			}
		}
	}

	deepestPathLength := 0
	for p := range sizes {
		depth := strings.Count(p, "/")
		if depth > deepestPathLength {
			deepestPathLength = depth
		}
	}

	for depth := deepestPathLength; depth >= 1; depth-- {
		for p, size := range sizes {
			if p == "/" || strings.Count(p, "/") != depth {
				continue
			}
			sizes[path.Dir(p)] += size
		}
	}

	freeSpace := TotalSpace - sizes["/"]
	spaceToClear := NeededSpace - freeSpace

	sizeSum := 0
	targetDirSize := TotalSpace
	for _, size := range sizes {
		if size <= SizeThreshold {
			sizeSum += size
		}
		if size >= spaceToClear && size < targetDirSize {
			targetDirSize = size
		}
	}
	fmt.Println(file)
	fmt.Println("Part 1:", sizeSum)
	fmt.Println("Part 2:", targetDirSize)
}

func main() {
	for _, file := range os.Args[1:] {
		run(file)
	}
}
