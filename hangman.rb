$file = File.open("words.txt","r").readlines
require "yaml"
require "psych"

class Game
    def initialize(new)
        @ended = false
        if new
            @guess = ""
            puts "How many wrong guesses should be allowed from 1 to 15?"

            @wrong_guesses = 0
            while @wrong_guesses < 1 || @wrong_guesses > 15
                @wrong_guesses = gets.chomp.to_i
            end


            @alphabet = []
            ("a".."z").map {|char| @alphabet.push(char)}

            @solution = []
            while @solution.length < 5 || solution.length > 12
                @solution = $file.sample.chomp.split("")
            end

            @guessed = Array.new(@solution.length, "_")
        elsif new == false
            savegame = YAML.load(File.open("savegame.yaml","r"))

            @alphabet = savegame[:alphabet]
            @solution = savegame[:solution]
            @guessed = savegame[:guessed]
            @wrong_guesses = savegame[:wrong]
        end
    end

    attr_accessor :alphabet, :solution, :guessed, :wrong_guesses, :ended

    def display_guessed
        i = 0
        while i < @guessed.length do
            print "#{@guessed[i]} "
            i += 1
        end
        puts
        puts
    end

    def save_game
        File.open("savegame.yaml","w") {|file| file.write(YAML.dump(self))}
        @ended = true
    end

    def make_guess
        puts "Please choose a letter, still #{@wrong_guesses} wrong guesses left. Type save to save the game."
        guess = gets.chomp.downcase

        if guess == "save"
            save_game
        elsif @alphabet.include?(guess)
            @guess = guess.downcase
        else 
            self.make_guess
        end
    end

    def compare_guess
        if @solution.any?(@guess)
            @solution.each_with_index do |char,idx|
                if @guess == char
                    @guessed[idx] = @guess
                end
            end
        else
            @wrong_guesses -= 1
        end

        @alphabet.delete(@guess)
    end

    def check_victory
        if @guessed == @solution
            self.display_guessed
            puts "Congratulations, you won!"
            @ended = true
        end
    end
end


puts "Welcome to Hangman!"
puts "You can start a new game by entering N or load the saved game with L"
new_game = ""
while new_game != "n" && new_game != "l"
    new_game = gets.chomp.downcase
end

if new_game == "n"
    game = Game.new(true)
elsif new_game == "l"
    game = Psych.unsafe_load(File.open("savegame.yaml","r"))
end

while game.ended == false && game.wrong_guesses > 0
    puts ""
    game.display_guessed
    game.make_guess
    game.compare_guess
    game.check_victory
end
if game.wrong_guesses == 0
    puts "Sorry, you didn't win, the word was \"#{game.solution.join}\"."
end
