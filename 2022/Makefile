.PHONY: all $(MAKECMDGOALS)

day1:
	gcc day1/main.c -o build/1 -g -Wall -fsanitize=address
	build/1 day1/example.txt
	build/1 day1/input.txt

day2:
	sqlite3 < day2/solution.sql --cmd "\
	CREATE TEMP TABLE filenames(name Text);\
	INSERT INTO filenames VALUES('day2/example.txt'), ('day2/input.txt');\
	"

day3:
	pwsh day3/solution.ps1 day3/example.txt day3/input.txt
day4:
	bash day4/solution.bash day4/example.txt day4/input.txt
day5:
	perl day5/solution.perl day5/example.txt day5/input.txt
day6:
	nim compile --out=build/day6 --run day6/solution.nim day6/example.txt day6/input.txt
day7:
	go run day7/solution.go day7/example.txt day7/input.txt
day8:
	v run day8/solution.v day8/example.txt day8/input.txt
