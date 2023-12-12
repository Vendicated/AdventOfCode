#!/usr/bin/ruby

require "date"

day = "day#{ARGV[0] || Date.today.day}"

commands = {
    "cr" => "crystal",
    "rb" => "ruby"
}

for ext, command in commands.entries do
    filename = "solution.#{ext}"
    next unless File.exist? "#{day}/#{filename}"

    system "#{command} #{filename}", :chdir => day
end
