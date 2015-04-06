# initialize a new game
class NewGame
  attr_accessor :live_window, :live_game_state, :live_deck, :live_bankroll,
                :live_dealer_hand, :live_player_hand_1, :live_player_hand_2,
                :live_player_hand_3, :live_player_hand_4
  def initialize
    @live_window = FancyGraffix.new
    @live_game_state = GameState.new
    @live_deck = Deck.new
    @live_bankroll = Bankroll.new
    @live_dealer_hand = Hand.new
    @live_player_hand_1 = Hand.new
    @live_player_hand_2 = Hand.new
    @live_player_hand_3 = Hand.new
    @live_player_hand_4 = Hand.new
  end

  def back_to_game
    live_game_state.back_to_game
  end

  def bet
    live_bankroll.bet
  end

  def get_bet
    live_bankroll.get_bet(live_window)
  end

  def input_ch
    live_window.game_ui.getch
  end

  def invoke_player_bet
    live_game_state.invoke_player_bet
  end

  def live_logic
    if live_game_state.special_state
      live_game_state.special_state
    else
      live_game_state.turn
    end
  end

  def new_hand
    live_window.new_hand
  end

  def paint_bet(bet)
    live_window.paint_bet(bet)
  end

  def paint_game(table)
    live_window.paint_game(table)
  end
end
