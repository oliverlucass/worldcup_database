#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo $($PSQL "select sum(winner_goals) + sum(opponent_goals) as Total_Goals from games;")

echo -e "\nAverage number of goals in all games from the winning teams:"
echo $($PSQL "select AVG(winner_goals) as Average_Winner_goals from games;")

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo $($PSQL "select ROUND(AVG(winner_goals), 2) from games;")

echo -e "\nAverage number of goals in all games from both teams:"
echo $($PSQL "select AVG((winner_goals+opponent_goals)) from games")

echo -e "\nMost goals scored in a single game by one team:"
echo $($PSQL "select MAX(x1.goals) from (select winner_goals as goals from games union all select opponent_goals as goals from games) x1")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo $($PSQL "select count(game_id) from games where winner_goals > 2;")

echo -e "\nWinner of the 2018 tournament team name:"
echo $($PSQL "select name from teams t, games g where t.team_id = g.winner_id and g.year = 2018 and g.round = 'Final'")

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo $($PSQL "select x1.name from (select name from teams t inner join games g on g.winner_id = t.team_id and year = 2014 and round = 'Eighth-Final' union all select name from teams t inner join games g on g.opponent_id = t.team_id and year = 2014 and round = 'Eighth-Final') x1 order by name asc")

echo -e "\nList of unique winning team names in the whole data set:"
echo  $($PSQL "select distinct name from teams t inner join games g on t.team_id = g.winner_id order by name asc")

echo -e "\nYear and team name of all the champions:"
echo $($PSQL "select g.year,t.name from teams t inner join games g on t.team_id = g.winner_id and g.round = 'Final' order by g.year asc")

echo -e "\nList of teams that start with 'Co':"
echo $($PSQL "select name from teams where name like 'Co%';")
