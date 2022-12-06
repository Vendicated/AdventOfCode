import std/sets
import std/os

when not declared(commandLineParams):
    echo("skill issue")
    quit(1)

proc run(line: string, logName: string, length: int32) =
    var lastChars = newSeq[char](length)

    for i in countup(0, line.len):
        lastChars[i mod length] = line[i]
        if i >= length and toHashSet(lastChars).len == length:
            echo(logName & ": " & $(i + 1))
            break

for filename in commandLineParams():
    let f = open(filename)
    defer: f.close

    let line = f.readLine

    run(line, filename & " Part 1", 4)
    run(line, filename & " Part 2", 14)
