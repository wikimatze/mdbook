require 'pry'

class ChapterLinks
  attr_accessor :chapters, :previous_link, :next_link, :first_chapter, :last_chapter, :between_chapter

  def first_chapter?(chapters, current)
    if chapters.first == current
      @first_chapter = true
      @next_link = chapters.index(current) + 1
      @previous_link = nil
    else
      @first_chapter = false
    end
    @first_chapter
  end

  def last_chapter?(chapters, current)
    if chapters.last == current
      @last_chapter = true
      @previous_link = chapters.index(current) - 1
      @next_link = nil
    else
      @last_chapter = false
    end
    @last_chapter
  end

  def between_chapter?(chapters, current)
    if chapters.first != current && chapters.last != current
      @between_chapter = true
      @previous_link = chapters.index(current) - 1
      @next_link = chapters.index(current) + 1
    else
      @between_chapter  = false
    end
    @between_chapter
  end
end

links = ChapterLinks.new

chapters.each do |chapter|
  if links.first_chapter?(chapters, chapter)
    links.next_link = chapters[links.next_link]
  elsif links.between_chapter?(chapters, chapter)
    links.previous_link = chapters[links.previous_link]
    links.next_link = chapters[links.next_link]
  elsif links.last_chapter?(chapters, chapter)
    links.previous_link = chapters[links.previous_link]
  else
    puts "Error"
  end
end

# links.between_chapter?(chapters, "3")


