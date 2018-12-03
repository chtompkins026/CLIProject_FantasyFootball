require "open-uri"
require "nokogiri"
require 'byebug'


class Player

      attr_accessor :name, :score, :team, :position, :link, :description, :opp, :posranking
      POSITIONS = ["rb","qb","wr","te","flex","k"]
      @@all = []

      # Initialize the position and the name of the player.
      def initialize(name, position=nil, team=nil, opp =nil, link=nil,description=nil, posranking=nil, score=nil)
        @name = name
        @position = position
        @team = team
        @link = link
        @opp = opp
        @description = description
        @posranking = posranking
        @score = score.to_f

        @@all << self unless @@all.any? {|player_name| checker(player_name)}
      end

      # Players are considered == if they have the same names && positions
      # the weeks or score my be different as the seasons as rankings updated every TUESDAY
      def checker(obj)
          #puts "#{@name} == #{obj.name}"
      	return false if @name.downcase != obj.name.downcase || @position != obj.position
      	return true
      end

      #    Override the to string method to print out the strig representation
      #    of the player per every object
      def overview
          puts " "
          puts "Name: #{@name}\nPosition Ranking: #{@posranking}\nProjected Score: #{@score}\nPosition: #{@position}\nTeam: #{@team}\n"
          puts "Description: #{@description}"
      end

      def self.look_up_player()
        print_rankings(@@all)
      end

      def self.print_rankings(array)
        current_list = array.each_with_index do |player, index|
          puts "#{index + 1} #{player.name} - #{player.team} - #{player.opp}"
        end

        FantasyFootball::CLI.player_description(current_list)
      end

      def self.ranker(selected)
        lpos = POSITIONS[selected]

        if lpos == "flex"
          answer = @@all.select {|player| player.position.downcase != "qb"}
        else
          answer = @@all.select {|player| player.position.downcase == lpos}
        end

        print_rankings(answer)
      end

      def self.all
        @@all
      end

end #end of the Class
