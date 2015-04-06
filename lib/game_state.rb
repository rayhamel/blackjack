class GameState
  attr_accessor :turn, :hands, :current_hand, :special_state
  def initialize(turn = :player_bet, hands = 1, current_hand = 1, special_state = :start_screen)
    # show what state of the game to display and use logic for:
    @turn = turn
    # the number of hands the player currently has in play, usually 1 but could be from 2 to 4 after splits
    @hands = hands
    # the hand that is currently being played; 0: the dealer's hand, 1: the player's default hand, 2-4: additional player hands
    @current_hand = current_hand
    # indicates whether or not :advice or :save_game screens and class logic should be displayed/used
    @special_state = special_state
  end

  # player_bet: the player bets before the hand is dealt; initial state of each hand
  def invoke_player_bet
    @turn = :player_bet
    @hands = 1
    @current_hand = 1
  end

  # insurance: the dealer offers the player insurance against dealer blackjack, if applicable
  def invoke_insurance
    @turn = :insurance
  end

  # player_action: the player has the option to hit, stand pat, double, surrender or split
  def invoke_player_action
    @turn = :player_action
  end

  # dealer: the dealer draws to soft 17, if applicable
  def invoke_dealer
    @turn = :dealer
    @current_hand = 0
  end

  # add a new hand when the player splits
  def add_hand
    @hands += 1
  end

  # switch to playing the next hand
  def switch_hands
    @current_hand += 1
  end

  # bring up the advice screen
  def invoke_advice
    @special_state = :advice
  end

  # bring up the savegame screen
  def invoke_savegame
    @special_state = :savegame
  end

  # go back to the game from the savegame or advice screens
  def back_to_game
    @special_state = false
  end
end