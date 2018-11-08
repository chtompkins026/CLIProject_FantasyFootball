require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball

  class Team
      @@PLAYERS = []

      def self.read_file
        doc = Nokogiri::HTML(open("./lib/site/roster.html"))
        players = doc.css('.players')
        table_body = players.css("tbody td")

        table_body.each_slice(3) do |slice|
          player = Player.new(slice[0].text.strip+ " " + slice[1].text.strip, slice[2].text.strip)
          @@PLAYERS << player unless @@PLAYERS.include?(player)
         end
      end

      def self.look_up_player()
        puts "Enter a name: "
        name = gets.chomp.strip
        player = @@PLAYERS.detect {|p| p.name == name }
        if player
          puts player.to_s
        else
          puts "Can't find this player on your team, try again."
        end
        puts "=" * 80
      end

      def initialize()
        Team.read_file
        score = 0.0
        @@PLAYERS.each do |player|
          score += Scraper.player_description(nil,player)
        end
        puts "YOUR TEAM'S PROJECTED SCORE: #{score.round(2)}"
      end


  end #end of the Class
end #end of the Module
