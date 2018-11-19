require 'open-uri'
require 'pry'
require 'byebug'

class Scraper
  @@ALL = [["|Name|","|Pos|","|Team|", "|Opp|"],[" ", " ", " "," "]] #added this for visual sake so you could see the columns
  @@IDS = ["data-name","data-position","data-team","data-opp"]
  #IDS - flexible, so that if we wanted to pull in more data we would add this in the array

   def self.player_ranker(link) #pulls in the rankings of each player
      doc = Nokogiri::HTML(open(link))

      players = doc.css('.player-row')

      # @@ALL = [["|Name|","|Pos|","|Team|", "|Opp|"],[" ", " ", " "," "]]

        players.each_with_index do |player, index|
          @@ALL << []
          @@IDS.each do |id|
            @@ALL[index + 2] << player.css("input").attribute("#{id}").text
            #pushing the index + 2 b/c of the top array we have at line 5
          end
        end
        show_all
    end


    def self.show_all
      @@ALL.each_index do |idx|
        var = @@ALL[idx].join(" - ")
          if idx < 2
            puts var
          else
            puts  "#{idx - 1}. #{var}"   #When you pick the player this is literally what you see
          end
      end
    end

    def self.player_description(link=nil, player = nil) #returns the player description... Two uses. Parsing from internet/parsing from our own team.
      #If player is nil, it goes through the players and finds that player. If player is not nil, it will go straight to the name

      if player.nil?

        doc = Nokogiri::HTML(open(link))
        players = doc.css('.player-row')

        puts "Pick a name to get a description: "
        name = gets.chomp
        player_link = players.detect do |p|
          p.css("a").attribute("href").value.include? name.downcase.gsub(" ","-")
        end
        doc = Nokogiri::HTML(open("https://www.fantasypros.com/nfl/players/" + player_link.css("a").attribute("href")))
      else
        name = player.name if player.is_a? Player
        name = name.gsub(" ", "-").downcase
        doc = Nokogiri::HTML(open("https://www.fantasypros.com/nfl/players/#{name}.php"))
      end

      return display_ranking(doc,player)
    end


    def self.ranker(doc) #pulls just the player ranking for said position and his projected points
      answer = []
      doc.search('.pull-right').each_with_index do |word, idx|
        if idx == 8 || idx == 9
          answer.push("#{word.text} ")
        end
      end
      answer
    end

    def self.setPlayerScoreRank(player,game,rank)
      if player
        player.score = rank
        player.team = game

        puts " "
        puts player.name
      end
    end


    def self.display_ranking(doc,player=nil)
      ranking = ranker(doc)


      notes = doc.css('.content').first.css("p").text
      game = doc.css('.next-game').text.strip.split.join(" ")

      setPlayerScoreRank(player,game,ranking[1])


      puts " "
      puts ranking.join(" | ")
      puts " "
      puts notes
      puts " "
      puts game

      return ranking[1].gsub(/[a-zA-Z]*/,"").strip.to_f  #taking out all letters and then changing to float.
      #* means everything. This is commonly called wildcard

    end

end #end of the Scraper Class
