import random, time


class RockPaperScissors:
    def newgame(self):

        rpsList = ["rock", "paper", "scissors"]
        z = random.choice(rpsList)
        computer1 = z
        player1 = None

        while player1 not in rpsList:
            player1 = input("Rock, Paper, or Scissors? ").lower()

        if player1 == computer1:
            print("Tie! Play again.")

        elif player1 == "rock":
            if computer1 == "paper":
                print("Computer: Paper")
                print("Player: Rock")
                print("You lose!")
            if computer1 == "scissors":
                print("Computer: Scissors")
                print("Player: Rock")
                print("You win!")

        elif player1 == "paper":
            if computer1 == "scissors":
                print("Computer: Scissors")
                print("Player: Paper")
                print("You lose!")
            if computer1 == "rock":
                print("Computer: Rock")
                print("Player: Paper")
                print("You win!")

        elif player1 == "scissors":
            if computer1 == "rock":
                print("Computer: Rock")
                print("Player: Scissor")
                print("You lose!")
            if computer1 == "paper":
                print("Computer: Paper")
                print("Player: Scissor")
                print("You win!")

        x = input("Do you want to play again? (yes)/(no)?")
        if x != "yes":
            return "Thanks for playing!"
        else:
            RockPaperScissors().newgame()


RockPaperScissors().newgame()
