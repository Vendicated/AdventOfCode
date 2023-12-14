Wow, I implemented the exact same algorithm in [ruby](solution.rb) and [crystal](solution.cr) (the code is nearly identical)
and Crystal is 62 times faster:

```
./solution  0.25s user 0.01s system 97% cpu 0.262 total
ruby solution.rb  15.49s user 0.11s system 99% cpu 15.681 total
```

like genuinely, the code is almost identical

```diff
# diff -uw solution.cr solution.rb

--- solution.cr 2023-12-14 17:53:11.742596153 +0100
+++ solution.rb 2023-12-14 17:54:13.123423262 +0100
@@ -1,3 +1,5 @@
+require "set"
+
 def tilt_north(map)
   (0...map.first.size).each do |j|
     loop do
@@ -84,23 +86,23 @@
 end

 def solve1(file)
-  map = File.read_lines(file).map &.chars
+  map = File.readlines(file, :chomp => true).map &:chars
   tilt_north map

   puts calculate_load map
 end

 def solve2(file)
-  map = File.read_lines(file).map &.chars
+  map = File.readlines(file, :chomp => true).map &:chars

-  prev_maps = {} of Array(Array(Char)) => Int32
+  prev_maps = {}
   rotations_done = 0
   cycle_happens_after = 0

   1000000000.times do |i|
     rotate map

-    dump = map.map &.dup
+    dump = map.map &:dup
     if prev_maps.has_key? dump
       rotations_done = i + 1
       cycle_happens_after = i - prev_maps[dump]
```
