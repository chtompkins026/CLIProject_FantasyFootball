require "open-uri"
require "nokogiri"
require 'byebug'


class Player

    attr_accessor :name, :score, :team, :position, :link, :description, :opp, :posranking
    @@all = []

    # Initialize the position and the name of the player.
    def initialize(name, position=nil, team=nil, opp =nil, link=nil)
      @name = name
      @position = position
      @team = team
      @link = link
      @opp = opp

      return if @@all.any? {|player_name| checker(player_name)} #stop from scraping again

      unless link.nil?
        player_name = name.gsub(" ", "-").downcase
        doc = Nokogiri::HTML(open(@link))
        @description = doc.css('.content').first.css("p").text
        @posranking = ranker(doc)[0]
        @score = ranker(doc)[1]
      end

      @@all << self unless @@all.any? {|player_name| checker(player_name)}
    end


      def ranker(doc) #pulls just the player ranking for said position and his projected points
        answer = []
        doc.search('.pull-right').each_with_index do |word, idx|
          if idx == 7 || idx == 8
            answer.push("#{word.text} ")
          end
        end
        answer
      end


    # Players are considered == if they have the same names test
    # the weeks or score my be different as the seasons continues.
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
      self.print_players

      begin
        puts "Enter the player's index to see his stats: "
        p_index = gets.chomp.to_i

        raise IndexError if p_index <= 0 || p_index >= @@all.size
          rescue IndexError => ie
          puts "Please select a correct index!"
          retry
      end

      begin
        player = @@all[p_index-1]
        raise unless player
          rescue Exception => e
          puts "Can't find this player on your team, try again."
          retry
      end

        player.overview
    end


    def self.print_players
      @@all.each_with_index do |player, index|
        puts "#{index + 1}) #{player.name} - #{player.position}"
      end
    end

    def self.all
      @@all
    end

end #end of the Class
