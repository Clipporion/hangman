$file = File.open("words.txt","r").readlines

class Game
    def initialize

        @ended = false
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

    def make_guess
        puts "Please choose a letter, still #{@wrong_guesses} wrong guesses left"
        guess = gets.chomp.downcase

        if @alphabet.include?(guess)
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

game = Game.new
while game.ended == false && game.wrong_guesses > 0
    game.display_guessed
    game.make_guess
    game.compare_guess
    game.check_victory
end
if game.wrong_guesses == 0
    puts "Sorry, you didn't win, the word was \"#{game.solution.join}\"."
end
