require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball
  class CLI
    @@POSITIONS = ["rb", "qb", "wr","te","flex","k"]

    attr_reader :selected, :ranker

    def select_position
      puts "MENU"
      puts "=" * 80
      @@POSITIONS.each_with_index do |pos, index|
        puts "#{index} #{pos}"
      end
      puts "#{@@POSITIONS.count} import your team"

      puts "#{@@POSITIONS.count+1} look up player"
      puts "=" * 80
      puts "Select a position to view the rankings of: "
      begin
        @selected = Integer(gets.chomp)
        raise if @selected < 0 || @selected > 7
      rescue Exception => e
        puts "Try again: "
        retry
      end

      if @selected == @@POSITIONS.count
        FantasyFootball::Team.new
        return false
      elsif @selected == @@POSITIONS.count + 1
        Team.look_up_player
        return false
      end

      @link = "https://www.fantasypros.com/nfl/rankings/#{@@POSITIONS[@selected]}.php"
      return true
    end



    def run_loop #runs through all the positions that we have
      pos = select_position
      Scraper.player_ranker(@link) if pos
      Scraper.player_description(@link) if pos
      check_out
    end


    def check_out
      puts "=" * 80
      puts "Do you want to continue? y || n"
      input = gets.chomp.to_s
      abort("Hope you found this helpful!") if input.downcase == "n"
    end


    def call
      puts "Hello and welcome to the fantasy football ranker!"
      puts "Here you can quickly find where your players rank"
      puts "& how the pros feel about your players matchup"

      while true
        run_loop
      end
    end



  end #end of the Class
end #end of the Module
