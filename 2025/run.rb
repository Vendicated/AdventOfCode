#!/usr/bin/ruby

require "date"

bench = ARGV.include? "--bench"
if ARGV[0] == "--bench"
    ARGV.shift
end

day = "day#{ARGV[0] || Date.today.day}"

commands = {
    "cr" => "crystal",
    "rb" => "ruby",
    "v" => "v run"
}

for ext, command in commands.entries do
    filename = "solution.#{ext}"
    next unless File.exist? "#{day}/#{filename}"

    if bench and ext == "cr"
        system "crystal build --release #{filename}", :chdir => day
        system "./solution", :chdir => day
        system "hyperfine ./solution", :chdir => day
    else
        system "#{command} #{filename}", :chdir => day
    end
end
