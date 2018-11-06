require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball

  class Team
      @@ALL = []


      def self.read_file
        doc = Nokogiri::HTML(open("./lib/site/roster.html"))
        players = doc.css('.players')
        table_body = players.css("tbody td")

        table_body.each_slice(3) do |slice|
          @@ALL << slice[0].text.strip+ " "+ slice[1].text.strip
        end

      end

      def initialize()
        Team.read_file
        cli = FantasyFootball::CLI.new
        score = 0.0
        @@ALL.each do |name|
          score += cli.player_description(name)
        end
        puts "YOUR TEAM'S PROJECTED SCORE: #{score.round(2)}"
      end


      def self.all #class variable
        @@ALL
      end


  end #end of the Class
end #end of the Module
