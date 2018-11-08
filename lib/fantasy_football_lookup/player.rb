require "open-uri"
require "nokogiri"
require 'byebug'


class Player

    attr_accessor :name, :score, :team,:position

    # Initialize the position and the name of the player.
    def initialize(name, position=nil)
      @name = name
      @position = position
    end

    # Players are considered == if they have the same names
    # the weeks or score my be different as the seasons continues.
    def ==(obj)
        #puts "#{@name} == #{obj.name}"
    	return false if @name.downcase != obj.name.downcase
    	return true
    end


    #    Override the to string method to print out the strig representation
    #    of the player per every object
    def to_s
        "Name: #{@name}\nScore: #{@score}\nPosition: #{@position}\nWeek: #{team}\n"
    end

end #end of the Class
