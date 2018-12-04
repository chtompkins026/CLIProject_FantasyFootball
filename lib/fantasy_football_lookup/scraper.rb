require 'open-uri'
require 'pry'
require 'byebug'

class Scraper
  @@all = [["|Rank|","|Name|","|Pos|","|Team|", "|Opp|"],[" "," ", " ", " "," "]] #added this for visual sake so you could see the columns
  @@id = ["data-name","data-position","data-team","data-opp"].freeze
  #idS - flexible, so thats if we wanted to pull in more data we would add this in the array


    def self.create_players(link)
      doc = Nokogiri::HTML(open(link))
      players = doc.css('.player-row')

        players.each do |play|
          unless play.nil?
            name = play.css("input").attribute("data-name").text.nil? ? "N/A" : play.css("input").attribute("data-name").text
            position = play.css("input").attribute("data-position").text.nil? ? "N/A" : play.css("input").attribute("data-position").text
            team = play.css("input").attribute("data-team").text.nil? ? "N/A" : play.css("input").attribute("data-team").text
            opp = play.css("input").attribute("data-opp").text.nil? ? "N/A" : play.css("input").attribute("data-opp").text
            nlink = "https://www.fantasypros.com/nfl/players/" + play.css("a").attribute("href")
            ndoc = Nokogiri::HTML(open(nlink))

            if ndoc.nil?
              Player.new(name, position, team, opp, nlink)
            else
              description = (ndoc.css('.content').first.css("p").text).nil? ? "N/A" : ndoc.css('.content').first.css("p").text
              posranking = (ranker(ndoc)[0]).nil? ? "N/A" : ranker(ndoc)[0]
              score = (ranker(ndoc)[1]).nil? ? "N/A" : ranker(ndoc)[1]
              Player.new(name, position, team, opp, nlink, description, posranking, score)
            end
          end

          puts "Player number #{Player.all.size} has been created!"
        end
    end

    def self.ranker(doc) #pulls just the player ranking for said position and his projected points
      answer = []
      doc.search('.pull-right').each_with_index do |word, idx|
        if idx == 7 || idx == 8
          answer.push("#{word.text} ")
        end
      end
      answer
    end

end #end of the Scraper Class
