require 'pry'
file = File.open("parsing.md")

text = ''
indicator = false
# indicator_one = false
# indicator_two = false

body = file.readlines

body.each_with_index do |line, number|
  if line =~ /{(:.*=)(".*").*/
    text << "```#{$2.gsub("\"", '')}\n"
    indicator = true
  elsif indicator && body[number] == "\n" && body[number+1] == "\n"
    text << "```\n\n"
    indicator = false
  else
    text << line
  end
end

puts text
