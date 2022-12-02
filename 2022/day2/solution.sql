-- Works on sqlite3.40.0

-- ax rock 1
-- by paper 2
-- cz scissors 3

-- hardcoding the values for each combination feels like cheating but shrug it works


SELECT "Part 1";

SELECT (
WITH line AS (
  SELECT *
  -- read the file; replace newlines (0a) with spaces and turn into json array; use json_each to split into rows
  FROM json_each('["' || replace(trim(readfile(file.name)), x'0a', '","') || '"]')
  WHERE value != ''
)
SELECT file.name || ": " || SUM(x) FROM (SELECT
  (CASE value
    WHEN 'A X' THEN (SELECT 4)
    WHEN 'A Y' THEN (SELECT 8)
    WHEN 'A Z' THEN (SELECT 3)

    WHEN 'B X' THEN (SELECT 1)
    WHEN 'B Y' THEN (SELECT 5)
    WHEN 'B Z' THEN (SELECT 9)

    WHEN 'C X' THEN (Select 7)
    WHEN 'C Y' THEN (Select 2)
    WHEN 'C Z' THEN (Select 6)
    ELSE (SELECT 0)
  END) AS x
FROM line))
from filenames as file;


SELECT "Part 2";

SELECT (
WITH line AS (
  SELECT *
  FROM json_each('["' || replace(trim(readfile(file.name)), x'0a', '","') || '"]')
  WHERE value != ''
)
-- x lose y draw z win
-- 0 3 6
SELECT file.name || ": " || SUM(x) FROM (SELECT
  (CASE value
    WHEN 'A X' THEN (SELECT 3)
    WHEN 'A Y' THEN (SELECT 4)
    WHEN 'A Z' THEN (SELECT 8)

    WHEN 'B X' THEN (SELECT 1)
    WHEN 'B Y' THEN (SELECT 5)
    WHEN 'B Z' THEN (SELECT 9)

    WHEN 'C X' THEN (Select 2)
    WHEN 'C Y' THEN (Select 6)
    WHEN 'C Z' THEN (Select 7)
    ELSE (SELECT 0)
  END) AS x
FROM line))
from filenames as file;
