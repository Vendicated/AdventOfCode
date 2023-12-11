#!/usr/bin/ruby

day = "day#{ARGV[0]}"

commands = {
    "cr" => "crystal",
    "rb" => "ruby"
}

for ext, command in commands.entries do
    filename = "solution.#{ext}"
    next unless File.exist? "#{day}/#{filename}"

    system "#{command} #{filename}", :chdir => day
end
