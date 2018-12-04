
module FantasyFootball

  class Team
      @@players = [] #class variable
      @@score
      #Team stores an array of players. It also prevents from duplicate players from being added

      def self.read_file
        doc = Nokogiri::HTML(open("./lib/site/roster.html"))
        players = doc.css('.players')
        table_body = players.css("tbody td")
        table_body.each_slice(3) do |slice|
          link = "https://www.fantasypros.com/nfl/players/" + slice[0].text.strip.downcase+ "-" + slice[1].text.strip.downcase + ".php"
          name = slice[0].text.strip + " " + slice[1].text.strip
          player = Player.all.detect { |person| person.name == name}
          Scraper.add_description(player)
          @@players << player unless @@players.include?(player)
        end

        puts "Your team has been imported! You can now use option 7 to view team data"
      end

      def self.score
        score = 0
        @@players.each do |player|
          unless player.nil?
            score += player.score.to_f
          end
        end

        puts "Your team is projected to score #{score.to_f} points"
      end

      def initialize()
        Team.read_file
      end

      def self.players
        @@players
      end

  end #end of the Class
end #end of the Module
