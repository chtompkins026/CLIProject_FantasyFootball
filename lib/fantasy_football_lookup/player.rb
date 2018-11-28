require "open-uri"
require "nokogiri"
require 'byebug'


class Player

    attr_accessor :name, :score, :team, :position, :link, :description
    @@all = []

    # Initialize the position and the name of the player.
    def initialize(name, position=nil, team=nil, link=nil)
      @name = name
      @position = position
      @team = team
      @link = link

      return if @@all.any? {|player_name| checker(player_name)} #stop from scraping again

      unless link.nil?
        player_name = name.gsub(" ", "-").downcase
        doc = Nokogiri::HTML(open(@link))
        @description = doc.css('.content').first.css("p").text
      end

      @@all << self unless @@all.any? {|player_name| checker(player_name)}
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
        "Name: #{@name}\nProjected Score: #{@score}\nPosition: #{@position}\nWeek: #{team}\n"
    end

    def self.look_up_player()
      begin
      puts "Enter the player's name you want to look up: "
      name = gets.chomp.strip.downcase
      player = @@all.detect {|p| p.name.downcase == name.downcase }
        raise unless player
      rescue Exception => e
        puts "Can't find this player, try again."
        retry
      end

      puts player.overview
      puts "=" * 80
    end

    def self.all
      @@all
    end

end #end of the Class
