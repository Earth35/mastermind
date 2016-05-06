class Mastermind
  Colors = ["R", "G", "B", "W", "O", "Y"]
  def initialize
    @codemaker = Player.new("Codemaker")
    @codebreaker = Player.new("Codebreaker")
    @board = Board.new
    @code = []
    @turn = 0
    puts "\n-=*=- Mastermind -=*=-"
  end
  
  public
  
  def start
    puts "\nPlaying as Codebreaker."
    puts "Codemaker is setting up the code..."
    @code = @codemaker.set_code(Colors)
    puts "Done. Codebreaker attempts to guess the code."
    codebreaker_won = code_guessing(@code)
    unless codebreaker_won
      victory(@codemaker)
      puts "Code: #{@code}"
    end
  end
  
  private
  
  def code_guessing (code)
    while @turn < 12
      puts "Colors: 'R'ed, 'G'reen, 'B'lue, 'W'hite, 'O'range, 'Y'ellow."
      puts "Feedback: X - exact match, O - partial match."
      puts "Turn #{@turn + 1}. Enter your code (a sequence of 4 letters, don't use separators):"
      guess = @codebreaker.guess_code
      answer = code.dup
      result = analyze_guess(guess, answer) # returns an array, result[0] contains number of exact matches, while result[1] contains number of partial matches
      if result[0] == 4
        victory(@codebreaker)
        return true
      end
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
    result = [] # By index: 0 - exact matches, 1 - partial matches
    i = 0
    while i < guess.length
      if guess[i] == code[i]
        exact_matches += 1
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
    return result.push(exact_matches, partial_matches)
  end
  
  def result_to_feedback (result) # result is an array which contains number of exact maches (result[0]) and number of partial matches (result[1])
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
    
    public
    
    def set_code (superset)
      i = 1
      code = []
      while i < 5
        index = rand(6).to_i
        code << superset[index]
        i += 1
      end
      return code
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
end

game = Mastermind.new
game.start