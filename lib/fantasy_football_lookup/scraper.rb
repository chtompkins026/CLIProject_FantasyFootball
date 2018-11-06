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


end #end of the Scraper Class
