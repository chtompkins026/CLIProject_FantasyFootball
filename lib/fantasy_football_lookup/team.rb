require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball

  class Team
      @@players = [] #class variable

      #Team stores an array of players. It also prevents from duplicate players from being added

      def self.read_file
        doc = Nokogiri::HTML(open("./lib/site/roster.html"))
        players = doc.css('.players')
        table_body = players.css("tbody td")

        table_body.each_slice(3) do |slice|
          link = "https://www.fantasypros.com/nfl/players/" + slice[0].text.strip.downcase+ "-" + slice[1].text.strip.downcase + ".php"
          name = slice[0].text.strip + " " + slice[1].text.strip
          # look up each player
          puts name
          player = Player.all.detect { |person| person.name == name}
          @@players << player unless @@players.any? {|player_obj| player_obj.checker(player)}
          #checking to see if
         end
      end

      def self.look_up_player()
        self.print_players(@@players)
        begin
          puts "Select a number to view the following rankings: "
          name = gets.chomp.strip.to_i
          player = @@players[name-1]
        raise unless player
          rescue Exception => e
          puts "Can't find this player on your team, try again."
          retry
        end
        puts " "
        puts "Player Weekly Overview"
        puts "=" * 80
        puts player.overview
        puts "=" * 80
      end

      def self.print_players(players)
        players.each_with_index do |player, index|
          puts "#{index + 1}) #{player.name} - #{player.position}"
        end
      end

      def initialize()
        Team.read_file
        score = 0.0
        @@players.each do |player|
          score += player.score
          player.overview
        end
        puts "YOUR TEAM'S PROJECTED SCORE: #{score.round(2)}"
      end

      def self.players
        @@players
      end

  end #end of the Class
end #end of the Module
