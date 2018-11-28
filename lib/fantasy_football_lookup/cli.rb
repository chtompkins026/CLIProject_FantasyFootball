require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball
  class CLI
    POSITIONS = ["rb", "qb", "wr","te","flex","k"]   #this is a constant
    #our menu is flexible because it is tied to the  array. If we wanted to add something in, then we just add it in
    #Everything with the CLI deals with input and output. Jumps to other classes for everything else

    attr_reader :selected, :ranker

    def select_position
      menu
      puts "Select a position to view the rankings of: "
      begin
        @selected = Integer(gets.chomp)
        raise if @selected < 0 || @selected > 8
      rescue Exception => e
        puts "Try again: "
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

      @link = "https://www.fantasypros.com/nfl/rankings/#{POSITIONS[@selected]}.php"
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
      puts "=" * 80
    end


    def run_loop #runs through all the positions that we have
      pos = select_position
      Scraper.player_ranker(@link) if pos
      Scraper.player_description(@link) if pos   #nil on this line because we are looking at all the players. Don't know who to look up yet
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
      puts "Hello and welcome to the Fantasy Football Ranker!\n"
      puts "Here you can quickly find where your players rank\n"
      puts "& see how the pros feel about your players matchup\n"
      puts "=" * 80
      puts "=" * 80
      puts "Please note the following when using this dashboard:\n"
      puts "You can look at any positional ranking by selecting options 1-5\n"
      puts "Note, when you select any of the options 1-5, the player is saved to our database\n"
      puts "Once saved, you can lookup that player again using option 8! All you have to do is type the player's name\n"
      puts "If you would like to import your personal fantasy team, please select 6\n"
      puts "Please note, you must select 6 before using option 7 (look up a player on your team)\n"
      puts "You can use option 8, once you have imported a positional ranking when using 1-5"
      puts "We hope you find this helpful!"
      
      while true
        run_loop
      end
    end



  end #end of the Class
end #end of the Module
