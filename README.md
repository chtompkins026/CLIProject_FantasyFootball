# FantasyFootballLookup

Welcome to the fantasy football tracker. In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fantasy_football_lookup`.

## Installation

Run `bundle install` first.

```ruby
gem 'fantasy_football_lookup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fantasy_football_lookup

## How to use the CLI

Once you are all set with bundle install, run bin/ff_start.rb to execute the program. From there, you will see a menu that prompts you to select the following: 0 rb, 1 qb, 2 wr, 3 te, 4 flex, 5 k, 6 import your team, 7 look up player.

I. Part One - Looking up traditional positions

To look up a traditional positions (ex. rb, qb etc.) simply select the integer next to the position you want to look up. For example, if you want to see this week's rankings for rb's, just select the integer 0. From there, the CLI  will show you a list of all rbs ranked, along with their position, official rank, team name, and opponent for the week.

Next, the CLI will prompt you to "Pick a name to get a description: ". If you would like to get a fantasy pro expert analysis for a specific player, simply type in the player's name in the description. For example, if I wanted to check out the write-up for Todd Gurley, I would type in 'Todd Gurley'. One note here, please make sure the name is exactly the same as what is shown in the rankings, otherwise the CLI will prompt you to try again!

Once you type in a player, you should see:
1) Player Name
2) Official Ranking and Projected Points for the Week
3) Official Expert Note for the week
4) Matchup and Matchup Time

Lastly, the CLI will ask you if you would like to continue. You have the option of looking up more players and rankings, or you can exit out of the program.

II. Part Two - Importing your actual Fantasy Football Team & Getting Custom Stats for Each Player

When you run bin/ff_start.rb to execute the program, you will see the last two options are 6 import your team, and 7 look up player. If this is your first time running the program, you MUST import your team before you can use the look up feature (option 7). To import your team, select option 6. You will see the CLI run a loop through the site/roster.html file. This is the HTML code for a site I built that stores your roster. If you would like to add players to the team or remove, you can edit this in the table. For example, if I wanted to change my QB, I would go down to the table body. You should see players organized in the following way:

<tr>
  <td> Alex</td>
  <td> Smith</td>
  <td> QB</td>
</tr>

To change a player, just remove the first and last name between the <td> and add in a new player's name.

<tr>
  <td> Patrick </td>
  <td> Mahomes </td>
  <td> QB</td>
</tr>

Next hit save and then rerun option 6. This will import your new player added to the roster. Note, if you did NOT exit the program, Alex Smith will still be stored, so you WILL be able to access him when you run option 7.

The last two features are really where you get to the see the power of OOP. Option 6 runs through the roster and creates a new instance of a Player that is stored in the player class. The neat thing is, the program is set up to recognize if the player already exists! So when you rerun the import for the second time in the example above, it will just add Patrick Mahomes!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# ClI Class
  - Where all the code you SEE lives. The class includes the following methods: select_position, run_loop, check_out, call.

# Scraper Class
 - This class is responsible for scraping all the data you see displayed in the CLI and responsible for storing the data which is later used in the Team and Player class to import and create stored players that can be called later on by the user. The class includes several class methods responsible for all the data that comes from fantasypros.com. The class methods include: player_ranker, show_all, player_description, ranker, setPlayerScoreRank, display_ranking.

 # Team Class
 - This class is responsible for going through the roster.html file that lives within the site folder. Upon initialization, it runs through the file and pulls in each player listed in the table. The Team Class is designed to run through the table and store each player in the Player array. This array will then be used by the Player class to create Player objects, which the CLI user can use later (option 7) to see specific information for a player on his/her team. The class includes the following methods: self.read_file, self.look_up_player(), and initialize().

 #Player Class
 - This class is responsible for actually taking in the Player array in Team class to create actual player objects who can then be called on when users want to see specific information for one of the players on his/her roster. The class includes the following methods: initialize, ==(obj), and to_s.


 # Roster.html
 - This is obviously not a class, but an HTML page that stores the players on the users team. The Team class interacts with this page to scrape the data provided in the table to create and store the users roster. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fantasy_football_lookup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FantasyFootballLookup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fantasy_football_lookup/blob/master/CODE_OF_CONDUCT.md).
