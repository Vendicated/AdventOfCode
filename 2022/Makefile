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
