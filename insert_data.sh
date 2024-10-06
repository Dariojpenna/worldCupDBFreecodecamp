#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $( $PSQL " TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != 'year' ]]
  then
    #Search for winner teams
    WINNER_TEAM=$($PSQL "SELECT COUNT(team_id) FROM teams WHERE name='$WINNER'");
    if [[ $WINNER_TEAM -eq 0 ]]
    then
      $PSQL "INSERT INTO teams (name) VALUES ('$WINNER')"
      echo Agregado $WINNER
    fi
    #Search for opponent teams
    OPPONENT_TEAM=$($PSQL "SELECT COUNT(team_id) FROM teams WHERE name='$OPPONENT'");
    if [[ $OPPONENT_TEAM -eq 0 ]]
    then
      $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')"
      echo Agregado $OPPONENT
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

     $PSQL "INSERT INTO games ( year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ( $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)" 
  fi
done
