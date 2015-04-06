# The player's funds and betting.
class Bankroll
  attr_accessor :funds, :bet
  def initialize(funds = 5000, bet = 0)
    # the amount of money the human player has available to bet
    @funds = funds
    # the numerical value of the bet
    @bet = bet
    # the string that's actually being displayed on the screen
    @bet_str = ''
  end

  # set the user's initial bet, prepare it to be displayed on the screen by the FancyGraffix class
  def get_bet(window)
    while ch = window.game_ui.getch
      # keep it so that bets are not too large to display on screen
      break if @bet_str.size >= 10
      case ch
      # return
      when 13
        # set final bet amount
        @bet = @bet_str.to_i
        break
      # delete/backspace
      when 127 || 8
        return @bet_str.chop!
      # number
      when /\d/
        return @bet_str << ch
      end
    end
    return @bet_str
  end
end