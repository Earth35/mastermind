class Mastermind
  Colors = ["R", "G", "B", "W", "O", "Y"]
  attr_writer :codemaker, :codebreaker
  def initialize
    @codemaker = nil
    @codebreaker = nil
    @board = Board.new
    @code = []
    @turn = 0
    puts "\n-=*=- Mastermind -=*=-"
  end
  
  public
  
  def choose_mode
    puts "Would you like to play as Codebreaker (B) or Codemaker (M)?"
    mode = mode_selection
    if mode == "B"
      start_as_codebreaker
    elsif mode == "M"
      start_as_codemaker
    end
  end
  
  def play_again?
    once_more = false
    puts "Play again? (Y/N)"
    usr_input = gets.chomp.upcase
    until usr_input =~ /^[YN]$/
      puts "Invalid input, Y/N only:"
      usr_input = gets.chomp.upcase
    end
    once_more = true if usr_input == "Y"
    return once_more
  end
  
  private
  
  def start_as_codebreaker
    puts "\nPlaying as Codebreaker."
    self.codemaker = Computer.new("Codemaker")
    self.codebreaker = Human.new("Codebreaker")
    game_flow("human")
  end
  
  def start_as_codemaker
    puts "\nPlaying as Codemaker."
    self.codemaker = Human.new("Codemaker")
    self.codebreaker = Computer.new("Codebreaker")
    game_flow("computer")
    # modify Human's and Computer's methods to override current behavior
  end
  
  def game_flow (codebreaker)
    puts "Codemaker is setting up the code..."
    @code = @codemaker.set_code
    puts "Done. Codebreaker attempts to guess the code."
    codebreaker_won = code_guessing(@code, codebreaker)
    unless codebreaker_won
      victory(@codemaker)
      puts "Code: #{@code}"
    end
  end
  
  def mode_selection
    game_mode = gets.chomp.upcase
    until game_mode =~ /^[BM]$/
      puts "Incorrect input, B/M only:"
      game_mode = gets.chomp.upcase
    end
    return game_mode
  end
  
  def code_guessing (code, codebreaker)
    last_feedback = nil
    while @turn < 12
      puts "Colors: 'R'ed, 'G'reen, 'B'lue, 'W'hite, 'O'range, 'Y'ellow."
      puts "Feedback: X - exact match, O - partial match."
      puts "Turn #{@turn + 1}. Code:"
      guess = codebreaker == "human" ? @codebreaker.guess_code : @codebreaker.guess_code(last_feedback) # different guess_code methods for Human and Computer codebreakers
      answer = code.dup
      if codebreaker == "computer"
        puts guess
      end
      result = analyze_guess(guess, answer) # returns an array, result[0] contains number of exact matches, result[1] contains number of partial matches
      if result[0] == 4
        victory(@codebreaker)
        return true
      end
      last_feedback = result[2]
      @board.guesses << guess
      feedback = result_to_feedback(result)
      @board.feedback << feedback
      @board.draw_current_state
      @turn += 1
    end
    return false
  end
  
  def analyze_guess (guess, code)
    guess = guess.split(//) # convert strings into arrays
    exact_matches = 0
    partial_matches = 0
    mask = []
    result = [] # By index: 0 - exact matches, 1 - partial matches
    i = 0
    while i < guess.length
      if guess[i] == code[i]
        exact_matches += 1
        mask[i] = code[i]
        code[i] = nil
        guess[i] = nil
      end
      i += 1
    end
    i = 0
    while i < guess.length
      if code.include?(guess[i]) && guess[i] != nil
        partial_matches += 1
        position = code.index(guess[i])
        code[position] = nil
        guess[i] = nil
      end
      i += 1
    end
    return result.push(exact_matches, partial_matches, mask)
  end
  
  def result_to_feedback (result) # result - an array which contains number of exact maches (result[0]) and number of partial matches (result[1])
    feedback = "X" * result[0] + "O" * result[1]
    return feedback
  end
  
  def victory (winner)
    puts "Game over."
    puts "#{winner.role} has won!"
  end
  
  class Board
    attr_accessor :guesses, :feedback
    def initialize
      @guesses = []
      @feedback = []
    end
    
    public
    
    def draw_current_state
      full_table = ["=" * 50]
      i = 0
      while i < @guesses.length
        full_table << "Your guess: #{@guesses[i]} Feedback: #{@feedback[i]}"
        i += 1
      end
      full_table << "=" * 50
      full_table.each do |row|
        puts row
      end
    end
  end
  
  class Player
    attr_reader :role
    def initialize (role)
      @role = role
    end
  end
  
  class Human < Player
    def set_code
      code = []
      input = self.guess_code
      code = input.split(//)
    end
    
    def guess_code
      guess = gets.chomp.upcase
      until guess =~ /^[RGBWOY]{4}$/
        puts "Incorrect input. Enter a sequence of 4 letters without separators. Colors: R, G, B, W, O, Y."
        puts "Example: RGBW"
        guess = gets.chomp.upcase
      end
      return guess
    end
  end
  
  class Computer < Player
    def set_code
      i = 1
      code = []
      while i < 5
        index = rand(6).to_i
        code << Colors[index]
        i += 1
      end
      return code
    end
  
    def guess_code (last_feedback = nil)
      guess = ""
      if !last_feedback
        guess = set_code.join
      else
        guess = [nil, nil, nil, nil]
        i = 0
        while i < last_feedback.length
          if last_feedback[i]
            guess[i] = last_feedback[i]
          end
          i += 1
        end
        i = 0
        while i < 4
          if !guess[i]
            guess[i] = pick_random_color
          end
          i += 1
        end
        guess = guess.join
      end
      return guess
    end
    
    private
    
    def pick_random_color
      index = rand(6).to_i
      return Colors[index]
    end
  end
end

start_game = true
while start_game
  game = Mastermind.new
  game.choose_mode
  start_game = game.play_again?
end