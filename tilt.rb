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

  def preprocess(full_document)
    full_document.gsub!('%%', 'arsch')
    full_document
  end

  def header(title, level)
    @headers ||= []
    # you can use this permalink style: 1-foo-bar with the level in it
    permalink = "#{level}-#{title.gsub(/\W+/, "-")}"

    # .. or just use title. you might like a better regex here, too
#     permalink = title.gsub(/\W+/, "-")

    # for extra credit: implement this as its own method
    if @headers.include?(permalink)
      permalink += "_1"
      # my brain hurts
      loop do
        break if !@headers.include?(permalink)
        # generate titles like foo-bar_1, foo-bar_2
        permalink.gsub!(/\_(\d+)$/, "_#{$1.to_i + 1}")
      end
    end
    @headers << permalink
    %(\n<a name="#{permalink}" class="anchor" href="##{permalink}"><span class="anchor-icon">#{title}</span></a><h#{level} id=\"#{permalink}\">#{title}</h#{level}>\n)
  end
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

#   tmp = chapter_file
#
#    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC).render(tmp.read)
#    puts html_toc
#
#    puts html_toc
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

  def format(link)
    link.gsub('md', 'html').gsub('chapters', '/output')
  end
  # rendering the markdown file with custom renderer
  # the context is custom variable
  # the block statement will replace the yield block in the template
  output = tilt.render(context, :next_link => next_links(links), :previous_link => previous_link(links)) do
    markdown.render(chapter_file.read)
  end
#   puts output

#    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:with_toc_data => true))
#   html = markdown.render(output)

  # define the place, where the output should be written
  output_path = generate_output_path(chapter_path)

  # writing the result in a file
  File.open(output_path, 'w') {|f| f.write(output) }

  chapter_file.close
end

