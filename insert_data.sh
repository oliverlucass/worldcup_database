#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# INSERT TEAMS 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    #get teams_id
    GET_WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    GET_OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    
    #if not null 
    if [[ -z $GET_WINNER_ID ]]
    then
      #insert winner team
      INSERT_TEAM_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      echo $INSERT_TEAM_WINNER_RESULT 
    elif [[ -z $GET_OPPONENT_ID ]]
    then
      #insert opponent team
      INSERT_TEAM_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      echo $INSERT_TEAM_OPPONENT_RESULT
    fi
  fi
done 

#INSERT GAMES 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  echo $($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
  values($YEAR, '$ROUND', (select team_id from teams where name = '$WINNER'), (select team_id from teams where name = '$OPPONENT'), $WINNER_GOALS, $OPPONENT_GOALS)")
done
