watch('/(.*).md') { |md| changed(md[0])}

def changed(md)
  puts "hello"
  system("ruby tilt.rb")
  puts "hello"
end

