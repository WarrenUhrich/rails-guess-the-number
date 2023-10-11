class GamesController < ApplicationController

    def index
        @messages = {heading: "Welcome to \"Guess the Number!\""}

        # Initialize game session values
        session[:score] = 0 unless session.has_key? :score
        session[:attempts] = 5 unless session.has_key? :attempts
        session[:random_number] = rand 1..100 unless session.has_key? :random_number # Random number between 1 and 100 (100-inclusive)

        # Check if a new game is starting
        if params.has_key? :new_game
            # Reset values
            session[:score] = 0
            session[:attempts] = 5
            session[:random_number] = rand 1..100
        end

        # Check if a guess was submitted
        guess = nil
        if params.has_key? :guess
            guess = params[:guess].to_i
        end

        # Handle round of game
        if session[:attempts] > 0 # If we still have attempt, continue...
            
            # Process round only if a guess was submitted
            if guess
                match_won = guess == session[:random_number] # Check if this round was won

                # If the round was won, add to the score and pick a new number!
                if match_won
                    session[:score] += 1

                    session[:random_number] = rand 1..100

                    @messages[:alert] = "You guessed correctly (#{guess})! Your score has been updated and there is a new number to guess."
                
                # If the round was last, remove an attempt!
                else 
                    session[:attempts] -= 1
                    
                    hint = "too high" if guess > session[:random_number]
                    hint = "too low" if guess < session[:random_number]

                    @messages[:alert] = "Oh no! You guessed #{hint} (#{guess})! Your have lost an attempt."
                end
            end
        end

        # End game scenario
        if session[:attempts] <= 0
            @messages[:heading] = "Game over! Thank you for playing! The last random number was: #{session[:random_number]}"
            @messages[:alert] = "Please use the \"New Game\" button to start a new game."
        end

        # Prepare messages for template
        @messages[:score] = session[:score]
        @messages[:attempts] = session[:attempts]
        @messages[:alert] = nil unless @messages.has_key? :alert
    end

end
