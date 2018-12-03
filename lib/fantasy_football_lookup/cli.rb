require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball
  class CLI
    LOOKUP_POSITIONS = ["flex","k","qb"]   #this is a constant
    POSITIONS = ["rb","qb","wr","te","flex","k"]
    #our menu is flexible because it is tied to the  array. If we wanted to add something in, then we just add it in
    #Everything with the CLI deals with input and output. Jumps to other classes for everything else

    attr_reader :selected, :ranker

    def send_link
      LOOKUP_POSITIONS.each_with_index do |pos, index|
        link = "https://www.fantasypros.com/nfl/rankings/#{LOOKUP_POSITIONS[index]}.php"
        Scraper.create_players(link)
      end
    end


    def select_option
      menu
      puts "Select a number to view the following rankings: "
      begin
        @selected = Integer(gets.chomp)
        raise if @selected < 0 || @selected > (POSITIONS.count + 2)
      rescue Exception => e
        puts "Try again, that selection does not exist!"
        retry
      end

      if @selected == POSITIONS.count
        FantasyFootball::Team.new
        return false
      elsif @selected == POSITIONS.count + 1
        Team.look_up_player
        return false
      elsif  @selected == POSITIONS.count + 2
        Player.look_up_player
        return false
      end

      Player.ranker(@selected)
      return true
    end

    def menu  #this will open up what you see
      puts "MENU"
      puts "=" * 80

      POSITIONS.each_with_index do |pos, index|
        puts "#{index} #{pos}"
      end

      puts "#{POSITIONS.count} import your team"

      puts "#{POSITIONS.count+1} look up player on your team"

      puts "#{POSITIONS.count+2} look up any player on site rankings"

      puts "=" * 80
    end

    def run_loop #runs through all the positions that we have
      select_option
      check_out
    end


    def check_out
      puts "=" * 80
      puts "Do you want to continue? y || n"
      input = gets.chomp.to_s
      abort("Hope you found this helpful!") if input.downcase == "n"
    end


    def call
      puts "=" * 80
      puts " " * 80
      puts "Hello and welcome to the Fantasy Football Ranker!\n"
      puts "Here you can quickly find where your players rank\n"
      puts "& see how the pros feel about your players matchup\n"
      puts "We are in the process of loading all player data\n"
      puts "We thank you for your patience!"
      puts "=" * 80
      puts "=" * 80
      puts " " * 80
      puts "Please note the following when using this dashboard:\n"
      puts "-" * 80
      puts " - You can look at any positional ranking by selecting options 1-5\n"
      puts " - If you would like to import your personal fantasy team, please select 6\n"
      puts " - Please note, you must select 6 before using option 7 (look up a player on your team)\n"
      puts " "
      puts "We hope you find this helpful!"
      puts " "
      send_link


      while true
        run_loop
      end
    end


# CLI Class Method

    def self.player_description(current_list)
      puts "Select a players ranking to view more details or enter 0 to continue"
      begin
        selection = Integer(gets.chomp)
        raise if selection < 0 || selection > current_list.count
      rescue Exception => e
        puts "Try again, that selection does not exist!"
        retry
      end

      unless selection == 0
        player = current_list[selection-1]
        puts player.overview
      end
    end



  end #end of the Class
end #end of the Module
