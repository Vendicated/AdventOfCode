require "yaml"

day = "day#{ARGV[0]}"

scripts = YAML.load_file "scripts.yml"
cmd = scripts[day]

system cmd, :chdir => day
