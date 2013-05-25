# Gems
require 'tilt'
require 'pry'
require 'github/markup'
require 'pygments.rb'

# local classes
require './chapter_links'

CHAPTER_DIRECTORY = "chapters"
OUTPUT_DIRECTORY = "output"
CHAPTERS = Dir["#{CHAPTER_DIRECTORY}/**/**"].sort


class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, :lexer => language, :encoding => 'utf-8')
  end

#   def preprocess(full_document)
#     full_document.gsub!('%%', 'arsch')
#     full_document
#   end

end

def generate_output_path(path)
  # not the best solution, but it works
  path.gsub(CHAPTER_DIRECTORY, OUTPUT_DIRECTORY).gsub('md', 'html')
end

markdown = Redcarpet::Markdown.new(HTMLwithPygments, :fenced_code_blocks => true)

tilt = Tilt.new("layouts/default.html.erb")


# go through each chapter
CHAPTERS.each do |chapter|
  # open the chapter
  chapter_file = File.open(chapter, 'r')
  chapter_path = chapter_file.path

  # Inspiration: http://net.tutsplus.com/tutorials/ruby/ruby-for-newbies-the-tilt-gem/
  context = Object.new
  links = ChapterLinks.new

  if links.first_chapter?(CHAPTERS, chapter)
    links.next_link = CHAPTERS[links.next_link]
  elsif links.between_chapter?(CHAPTERS, chapter)
    links.previous_link = CHAPTERS[links.previous_link]
    links.next_link = CHAPTERS[links.next_link]
  elsif links.last_chapter?(CHAPTERS, chapter)
    links.previous_link = CHAPTERS[links.previous_link]
  end

  def next_links(links)
    if links.first_chapter
      links.next_link
    elsif links.between_chapter
      links.next_link
    else
      nil
    end
  end

  def previous_link(links)
    if links.last_chapter
      links.previous_link
    elsif links.between_chapter
      links.previous_link
    else
      nil
    end
  end

#   binding.pry


  text = ""
  body = chapter_file.readlines

  indicator = false
  body.each_with_index do |line, number|
    if line =~ /{(:.*=)(".*").*/
      text << "```#{$2.gsub("\"", '')}\n"
      indicator = true
    elsif body[number] == "\n" && body[number+1] == "\n" && indicator
      text << "```\n\n"
      indicator = false
    else
      text << line
    end
  end


  # rendering the markdown file with custom renderer
  # the context is custom variable, with other attributes which can be used in the ERB template file
  # the block statement will replace the yield block in the template
  output = tilt.render(context, :next_link => next_links(links), :previous_link => previous_link(links)) do
    markdown.render(text)
  end

  # define the place, where the output should be written
  output_path = generate_output_path(chapter_path)

  # writing the result in a file
  File.open(output_path, 'w') {|f| f.write(output) }

  chapter_file.close
end

