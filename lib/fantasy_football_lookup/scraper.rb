require 'open-uri'
require 'pry'

attr_accessor :players

class Scraper
@@ALL = [["|Name|","|Pos|","|Team|", "|Opp|"],[" ", " ", " "," "]]
@@IDS = ["data-name","data-position","data-team","data-opp"]


  def self.scrape_index_page(player_link) #pulls the ranking of each player
    doc = Nokogiri::HTML(open(@link))
    players = doc.css('.player-row')

      players.each_with_index do |player, index|
        @@ALL << []
        @@IDS.each do |id|
          @@ALL[index + 2] << player.css("input").attribute("#{id}").text
        end
      end

    show_all
    end
  end #scrape_index_page

  def self.player_description(name = nil) #returns the player description
    if name.nil?

      doc = Nokogiri::HTML(open(@link))
      players = doc.css('.player-row')

      puts "Pick a name to get a description: "
      name = gets.chomp
      player_link = players.detect do |p|
        p.css("a").attribute("href").value.include? name.downcase.gsub(" ","-")
      end
      doc = Nokogiri::HTML(open("https://www.fantasypros.com/nfl/players/" + player_link.css("a").attribute("href")))
    else
      name = name.gsub(" ", "-").downcase
      doc = Nokogiri::HTML(open("https://www.fantasypros.com/nfl/players/#{name}.php"))
    end

    return display_ranking(doc)
  end


end #end of the Scraper Class
