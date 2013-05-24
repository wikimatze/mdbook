require 'tilt'
require 'pry'
require 'github/markup'
require 'pygments.rb'

CHAPTER_DIRECTORY = "chapters"
OUTPUT_DIRECTORY = "output"

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, :lexer => language, :encoding => 'utf-8')
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
    %(\n<a name="#{permalink}" class="anchor" href="##{permalink}"><span class="anchor-icon">aa</span></a><h#{level} id=\"#{permalink}\">#{title}</h#{level}>\n)
  end
end

def generate_output_path(path)
  # not the best solution, but it works
  path.gsub(CHAPTER_DIRECTORY, OUTPUT_DIRECTORY).gsub('md', 'html')
end

markdown = Redcarpet::Markdown.new(HTMLwithPygments, :fenced_code_blocks => true)

tilt = Tilt.new("layouts/default.html.erb")

# go through each chapter
Dir["#{CHAPTER_DIRECTORY}/**/**"].each do |chapter|
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
  def context.title
    "Tuts+ Sites"
  end

#   def context.toc
#     html_toc
#   end

  # rendering the markdown file with custom renderer
  # the context is custom variable
  # the block statement will replace the yield block in the template
  output = tilt.render do
    markdown.render(chapter_file.read)
  end
#   puts output

#    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:with_toc_data => true))
#   html = markdown.render(output)

  html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
#   markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:with_toc_data => true))
  toc  = html_toc.render(chapter_file.read)
  html = markdown.render(chapter_file.read)
  # define the place, where the output should be written
  output_path = generate_output_path(chapter_path)

  # writing the result in a file
  File.open(output_path, 'w') {|f| f.write(output) }

  chapter_file.close
end

