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
      
      def self.find_by_position(lpos)
        if lpos == "flex"
          @@all.select {|player| player.position.downcase != "qb"}
        else
          @@all.select {|player| player.position.downcase == lpos}
        end

      end

      def self.all
        @@all
      end

end #end of the Class
