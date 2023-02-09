#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

    echo "Enter your username:"
    read USERNAME

    #if valid input
    if [[ $USERNAME =~ ^[a-zA-Z]{0,22}$ ]]
    then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    #echo $USER_ID

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
        # add new user to database
        INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
        USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
        
        #print welcome to new user
        echo "Welcome, $USERNAME! It looks like this is your first time here."
        
        echo Guess the secret number between 1 and 1000:
        read GUESS
        
        # insert new game
        INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")

        # this is the guessing game
        SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
        COUNT=0
        
        # if not a number
        if [[ $GUESS =~ ^[0-9]+$ ]]
        then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID
        else
        echo That is not an integer, guess again:
        fi

    # if user exists
    else
        # get number of games played
        GAMES_PLAYED=$($PSQL "SELECT games_played FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")
        echo numbers of games played: $GAMES_PLAYED
        # get best game of the user
        BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")
        echo best game: $BEST_GAME
        #print welcome to new user
        echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.

        echo Guess the secret number between 1 and 1000:
        read GUESS

        # insert new game
        INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")

        # this is the guessing game
        SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
        COUNT=0
        
        # if not a number
        if [[ $GUESS =~ ^[0-9]+$ ]]
        then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID
        else
        echo That is not an integer, guess again:
        fi
    fi

    # not a valid input
    else
    echo "Please enter a valid username. Just 22 characters."
    fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    echo "Guess #$COUNT"
    if [[ $GUESS > $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      read GUESS
    elif [[ $GUESS < $SECRET_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      read GUESS
    else [[ $GUESS = $SECRET_NUMBER ]]
      echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
    fi
    COUNT=$(($COUNT+1))
  done

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    INSERT_GAMES_PLAYED=$($PSQL "INSERT INTO games (games_played) VALUES (1)")
  else
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "INSERT INTO games (games_played) VALUES ($GAMES_PLAYED)")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (number_of_guesses) VALUES ($COUNT)")
}

MAIN_MENU

#=========================================================================================

    # elif [[ -z $GAMES_PLAYED ]]
    # then
    #   # add new user to database
    #   INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
    #   USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
      
    #   #print welcome to new user
    #   echo "Welcome, $USERNAME! It looks like this is your first time here."
      
    #   # this is the guessing game
    #   SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

    #   echo Guess the secret number between 1 and 1000:
    #   read GUESS
      
    #   # insert new game
    #   INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
    #   GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

    #   COUNT=1
      
    #   # if not a number
    #   if [[ $GUESS =~ ^[0-9]+$ ]]
    #   then
    #     GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
    #   else
    #     echo That is not an integer, guess again:
    #   fi








    # HALA=NULL
    # BALA=NULL
    # echo $HALA
    # if [[ -z $HALA ]]
    # then
    #  echo it works
    # fi

    # ONE=$(if [[ -z $HALA ]])
    # TWO=$(if [[ -z $BALA ]])
    # echo This is one: $ONE 
    # if [[ ONE ]] && [[ TWO ]]
    # then
    #   echo hala
    # fi

    # if user_id does not exits (user_id is empty)
    #if [[ [[ -z $USER_ID ]] -a [[ -z $GAMES_PLAYED ]] ]]



    #=========================================================================================
    #version 3?

    #!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  #if valid input
  if [[ $USERNAME =~ ^[a-zA-Z]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    
    # get number of games played
    GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
      
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

      echo Guess the secret number between 1 and 1000:
      read GUESS
      
      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo That is not an integer, guess again:
      fi

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

      echo Guess the secret number between 1 and 1000:
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo That is not an integer, guess again:
      fi
    fi

  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    echo "Guess #$COUNT"
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS > $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
      elif [[ $GUESS < $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
      fi
      COUNT=$(($COUNT+1))
    else
      echo That is not an integer, guess again:
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU



#===================================================================================================================================
#version 4?

#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  #if valid input
  if [[ $USERNAME =~ ^[a-zA-Z]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    
    # get number of games played
    GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
      
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

      echo Guess the secret number between 1 and 1000:
      read GUESS
      
      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo That is not an integer, guess again:
      fi

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

      echo Guess the secret number between 1 and 1000:
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo That is not an integer, guess again:
      fi
    fi

  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    echo "Guess #$COUNT"
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS > $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
      elif [[ $GUESS < $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
      fi
      COUNT=$(($COUNT+1))
    else
      echo That is not an integer, guess again:
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU






#===================================================================================================================================
#version 5

#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  #if valid input
  if [[ $USERNAME =~ ^[a-zA-Z]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

      echo "Guess the secret number between 1 and 1000:"
      read GUESS
      
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo That is not an integer, guess again:
      fi

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))

      echo "Guess the secret number between 1 and 1000:"
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo That is not an integer, guess again:
      fi
    fi

  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    echo "Guess #$COUNT"
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS > $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
      elif [[ $GUESS < $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
      fi
      COUNT=$(($COUNT+1))
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU





#==========================================================================================================================================
# VERSION 6 - FIXED VALIDATIONS???


#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  # if username is null
  if [[ -z $USERNAME ]]
  then
    echo "Empty input is not accepted. Please enter your username"
    MAIN_MENU
  # valid input
  elif [[ $USERNAME =~ ^[a-zA-Z]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS
      
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo "That is not an integer, guess again:"
        read GUESS
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      fi

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo "That is not an integer, guess again:"
        read GUESS
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      fi
    fi
  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
    MAIN_MENU
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        if [[ $GUESS -gt 1000 ]]
        then
          echo "Guess can't be higher than 1000"
          read GUESS
        else
          echo "It's lower than that, guess again:"
          read GUESS
          COUNT=$(($COUNT+1))
        fi
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        if [[ $GUESS -lt 1 ]]
        then 
          echo "Guess can't be lower than 1"
          read GUESS    
        else
          echo "It's higher than that, guess again:"
          read GUESS
          COUNT=$(($COUNT+1))
        fi
      else
        echo -e "how did I get here?\n"
        read GUESS
      fi
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU




#==========================================================================================================================================
# VERSION 7 - FIXED VALIDATIONS/WITHOUT COMMENTS???

#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  #if valid input
  if [[ $USERNAME =~ ^[a-zA-Z]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS
      
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo "That is not an integer, guess again:"
        read GUESS
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      fi

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      # if not a number
      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      else
        echo "That is not an integer, guess again:"
        read GUESS
        GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      fi
    fi

  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
    MAIN_MENU
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        if [[ $GUESS -gt 1000 ]]
        then
          echo "Guess can't be higher than 1000"
          read GUESS
        else
          echo "It's lower than that, guess again:"
          read GUESS
          COUNT=$(($COUNT+1))
        fi
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        if [[ $GUESS -lt 1 ]]
        then 
          echo "Guess can't be lower than 1"
          read GUESS    
        else
          echo "It's higher than that, guess again:"
          read GUESS
          COUNT=$(($COUNT+1))
        fi
      else
        echo -e "how did I get here?\n"
        read GUESS
      fi
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU


#==========================================================================================================================================
# VERSION 7 - WITH ENTER USERNAME READY
# NEEDED TO ACCEPT NUMBERS AS USERNAMES TOO



#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  # if username is null
  if [[ -z $USERNAME ]]
  then
    #echo "Empty input is not accepted. Please enter your username"
    MAIN_MENU
  valid input
  elif [[ $USERNAME =~ ^[a-zA-Z0-9]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS
      
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID

      # # if not a number
      # if [[ $GUESS =~ ^[0-9]+$ ]]
      # then
      #   GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      # else
      #   echo "That is not an integer, guess again:"
      #   read GUESS
      #   GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      # fi

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID

      # # if not a number
      # if [[ $GUESS =~ ^[0-9]+$ ]]
      # then
      #   GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      # else
      #   echo "That is not an integer, guess again:"
      #   read GUESS
      #   GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
      # fi
    fi
  # not a valid input
  else
    #echo "Please enter a valid username. Just 22 characters."
    MAIN_MENU
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        if [[ $GUESS -gt 1000 ]]
        then
          #echo "Guess can't be higher than 1000"
          read GUESS
        else
          echo "It's lower than that, guess again:"
          read GUESS
          COUNT=$(($COUNT+1))
        fi
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        if [[ $GUESS -lt 1 ]]
        then 
          #echo "Guess can't be lower than 1"
          read GUESS    
        else
          echo "It's higher than that, guess again:"
          read GUESS
          COUNT=$(($COUNT+1))
        fi
      fi
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU


#==========================================================================================================================================
# VERSION 8 - WITHOUT 1000 AND 0 VALIDATIONS... AND WITHOUT INTEGER VALIDATION BEFORE GUESS FUNCTION

#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  # if username is null
  if [[ -z $USERNAME ]]
  then
    echo "Empty input is not accepted. Please enter your username"
    MAIN_MENU
  valid input
  elif [[ $USERNAME =~ ^[a-zA-Z0-9]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS
      
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
    fi
  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
    MAIN_MENU
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
        COUNT=$(($COUNT+1))
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
        COUNT=$(($COUNT+1))
      fi
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU



#====================================================================================================================
#ANOTHER VERSION

#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  # if username is null
  if [[ -z $USERNAME ]]
  then
    echo "Empty input is not accepted. Please enter your username"
    MAIN_MENU
  valid input
  elif [[ $USERNAME =~ ^[a-zA-Z0-9]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      #USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      if [[ $INSERT_NEW_USER = "INSERT 0 1" ]]
      then 
        echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
      else
        echo -e "\nSomething went wrong while registering a new user!"
      fi
        # Get user id from db
        USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      #print welcome to new user
      #echo "Welcome, $USERNAME! It looks like this is your first time here."

      GUESS_NUMBER $USER_ID

    # if user exists
    else
      # get number of games played and best game
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      GUESS_NUMBER $USER_ID
    fi
  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
    MAIN_MENU
  fi
}

GUESS_NUMBER(){
  USER_ID=$1

  # this is the guessing game
  SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
  #echo $SECRET_NUMBER
  echo "Guess the secret number between 1 and 1000:"
  read GUESS

  # insert new game
  INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
  GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

  COUNT=1

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
      read GUESS
    else
      # echo "That is not an integer, guess again:"
      # read GUESS
      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
        COUNT=$(($COUNT+1))
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
        COUNT=$(($COUNT+1))
      fi
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  RECORD_GAME $COUNT $USER_ID $GAME_ID
}

RECORD_GAME(){
  COUNT=$1
  USER_ID=$2
  GAME_ID=$3

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU



#====================================================================================================================
#FINAL VERSION

#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU(){

  echo "Enter your username:"
  read USERNAME

  # if username is null
  if [[ -z $USERNAME ]]
  then
    echo "Empty input is not accepted. Please enter your username"
    MAIN_MENU
  valid input
  elif [[ $USERNAME =~ ^[a-zA-Z0-9_]{0,22}$ ]]
  then
    # get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    # if user_id does not exits (user_id is empty)
    if [[ -z $USER_ID ]]
    then
      #print welcome to new user
      echo "Welcome, $USERNAME! It looks like this is your first time here."
      
      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS
      
      # add new user to database
      INSERT_NEW_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID

    # if user exists
    else
      # get number of games played
      GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games INNER JOIN users USING (user_id) WHERE user_id=$USER_ID")

      # get best game of the user
      BEST_GAME=$($PSQL "SELECT MIN(gd.number_of_guesses) FROM game_description gd INNER JOIN games g USING (game_id) INNER JOIN users u USING (user_id) WHERE u.user_id=$USER_ID")

      # print welcome to user
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

      # this is the guessing game
      SECRET_NUMBER=$(echo $(( $RANDOM % 1000 + 1 )))
      #echo $SECRET_NUMBER
      echo "Guess the secret number between 1 and 1000:"
      read GUESS

      # insert new game
      INSERT_NEW_GAME=$($PSQL "INSERT INTO games (user_id) VALUES ($USER_ID)")
      GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games;")

      COUNT=1
      
      GUESS_NUMBER $SECRET_NUMBER $GUESS $COUNT $USER_ID $GAME_ID
    fi
  # not a valid input
  else
    echo "Please enter a valid username. Just 22 characters."
    MAIN_MENU
  fi
}

GUESS_NUMBER(){
  SECRET_NUMBER=$1
  GUESS=$2
  COUNT=$3
  USER_ID=$4
  GAME_ID=$5

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
        COUNT=$(($COUNT+1))
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
        COUNT=$(($COUNT+1))
      fi
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"

  #get amount of games played
  GAMES_PLAYED=$($PSQL "SELECT MAX(games_played) FROM games WHERE user_id=$USER_ID")
  
  # if no games played
  if [[ -z $GAMES_PLAYED ]]
  then
    # insert first game
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=1 WHERE game_id=$GAME_ID AND user_id=$USER_ID")
  else
    # insert the new game
    GAMES_PLAYED=$(($GAMES_PLAYED+1))
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE games SET games_played=$GAMES_PLAYED WHERE user_id=$USER_ID AND game_id=$GAME_ID")
  fi

  # insert number of guesses
  INSERT_NUMBER_OF_GUESSES=$($PSQL "INSERT INTO game_description (game_id, number_of_guesses) VALUES ($GAME_ID, $COUNT)")
}

MAIN_MENU