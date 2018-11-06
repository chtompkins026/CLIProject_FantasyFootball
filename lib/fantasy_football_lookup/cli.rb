require "open-uri"
require "nokogiri"
require 'byebug'

module FantasyFootball
  class CLI
    @@POSITIONS = ["rb", "qb", "wr","te","flex","k"]
    @@IDS = ["data-name","data-position","data-team","data-opp"]
    @@ALL = [["|Name|","|Pos|","|Team|", "|Opp|"],[" ", " ", " "," "]]

    attr_reader :selected, :ranker

    def initialize()
    end

    def select_position
      puts "MENU"
      puts "=" * 80
      @@POSITIONS.each_with_index do |pos, index|
              puts "#{index} #{pos}"
      end
      puts "#{@@POSITIONS.count} import your team"
      puts "=" * 80
      puts "Select a position to view the rankings of: "
      begin
              @selected = Integer(gets.chomp)
              raise if @selected < 0 || @selected > @@POSITIONS.count
      rescue Exception => e
              puts "Try again: "
              retry
      end

      if @selected == @@POSITIONS.count
        FantasyFootball::Team.new
        return false
      end

      @link = "https://www.fantasypros.com/nfl/rankings/#{@@POSITIONS[@selected]}.php"
      return true
    end

    def run_loop #runs through all the positions that we have
      pos = select_position
      player_ranker if pos
      player_description if pos
      check_out
    end


    def check_out
      puts "=" * 80
      puts "Do you want to continue? y || n"
      input = gets.chomp.to_s

      if input.downcase == "n"
        abort("Hope you found this helpful!")
      else
        CLI.new
      end
    end


    def player_ranker #pulls in the rankings of each player
      doc = Nokogiri::HTML(open(@link))

      players = doc.css('.player-row')

        players.each_with_index do |player, index|
          @@ALL << []
          @@IDS.each do |id|
            @@ALL[index + 2] << player.css("input").attribute("#{id}").text
          end
        end

        show_all
    end

    def show_all
      @@ALL.each_index do |idx|
        var = @@ALL[idx].join(" - ")
          if idx < 2
            puts var
          else
            puts  "#{idx - 1}. #{var}"
          end
      end
    end


    def player_description(name = nil) #returns the player description
      if name.nil?

        doc = Nokogiri::HTML(open(@link))
        players = doc.css('.player-row')

        puts "Pick a name to get a description: "
        name = gets.chomp
        player_link = players.detect do |p|
          p.css("a").attribute("href").value.include? name.downcase.gsub(" ","-")
        end
        doc = Nokogiri::HTML(open("https://www.fantasypros.com/nfl/players/" + player_link.css("a").attribute("href")))
      else
        name = name.gsub(" ", "-").downcase
        doc = Nokogiri::HTML(open("https://www.fantasypros.com/nfl/players/#{name}.php"))
      end

      return display_ranking(doc)
    end

    def display_ranking(doc)
      ranking = ranker(doc)

      notes = doc.css('.content').first.css("p").text
      game = doc.css('.next-game').text.strip.split.join(" ")

      puts " "
      puts ranking.join(" | ")
      puts " "
      puts notes
      puts " "
      puts game

      return ranking[1].gsub(/[a-zA-Z]*/,"").strip.to_f
    end

    def ranker(doc)
      answer = []
      doc.search('.pull-right').each_with_index do |word, idx|
        if idx == 8 || idx == 9
          answer.push("#{word.text} ")
        end
      end
      answer
    end



    def call
      puts "Hello and welcome to the fantasy football ranker!"
      puts "Here you can quickly find where your players rank"
      puts "& how the pros feel about your players matchup"

      while true
        run_loop
      end
    end


    def self.all
      @@ALL
    end


  end #end of the Class
end #end of the Module
