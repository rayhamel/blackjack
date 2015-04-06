LOADSCREEN = '         _______  __       _______  _______  __   __
  /\    / ___  / / /      / ___  / / _____/ / /  / /
 /  \  / /  / / / /      / /  / / / /      / /  / /
 \  / / /__/ / / /      / /  / / / /      / /__/ /
  \/ /    __/ / /      / /__/ / / /      /    __/
    / ___ \  / /      / ___  / / /      / ___ \
   / /  / / / /      / /  / / / /      / /  / /
  / /__/ / / /____  / /  / / / /____  / /  / /
 /______/ /______/ /_/  /_/ /______/ /_/  /_/
   __  __     __  _______  _______  __   __
  __/ / /    / / / ___  / / _____/ / /  / / ___
 /_  /_/    / / / /  / / / /      / /  / / /   \
   _   __  / / / /  / / / /      / /__/ / (     )
   /  /_  / / / /__/ / / /      /    __/ __\   /__
 _/_ __/ / / / ___  / / /      / ___ \  /         \
        / / / /  / / / /      / /  / / (    ) (    )
  _____/ / / /  / / / /____  / /  / /   \__/( )\__/
 /______/ /_/  /_/ /______/ /_/  /_/        / \

 PRESS S TO START, L TO LOAD SAVEGAME, OR Q TO QUIT'

TABLE = ' Dealer:



 Bankroll:                               Cards left in deck:
       _    _  _                                   _      _
      / \  / \/ \    BLACKJACK PAYS 3 TO 2        / \    / \
     _\ /_ \    / /_  / __  _  /_   . __  _  /_  /   \  /   \
    /     \ \  / / / / __/ /  /\   / __/ /  /\  /     \ \   /
    \_/|\_/  \/ /_/ / /_/ /_ / / _/ /_/ /_ / /  \_/|\_/  \_/

          Dealer must draw to 16 and stand on all 17s.
 H: Hit            _________________________
 P: Stand          \                        \          S: Save
 D: Double         / INSURANCE PAYS 2 TO 1  /          A: Advice
 L: Split          \________________________\          Q: Quit'

ONE_HAND = " Player:   Bet:\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

TWO_HANDS = " Hand 1:    Bet:                 Hand 2:    Bet:
                                *
                                *
                                *
                                *
                                *
                                *\n\n\n\n\n\n\n\n"

THREE_HANDS = " Hand 1:              Hand 2:              Hand 3:
 Bet:                 Bet:                 Bet:
                     *                    *
                     *                    *
                     *                    *
                     *                    *
                     *                    *
                     *                    *
                     *                    *
                     *                    *
                     *                    *\n\n\n\n"

FOUR_HANDS = ' Hand 1:         Hand 2:         Hand 3:         Hand 4:
 Bet:            Bet:            Bet:            Bet:
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *
                *               *               *'

FACEDOWN = %w(|^\ ^| |\ ^\ | |^\ ^|)

# All the hard work of drawing the game.
class FancyGraffix
  attr_accessor :game_ui, :num_hands, :hands
  def initialize
    # start the curses module, 
    init_screen
    # allow colors other than black and white
    start_color
    # keys pressed by the user don't show up in the terminal window
    noecho
    # allows use of the enter key
    nonl
    # makes the terminal cursor invisible
    curs_set(0)
    # green text on black background
    init_pair(1, COLOR_GREEN, COLOR_BLACK)
    # 63 usable characters wide, 40 usable characters high.
    # 3rd and 4th params are y and x coordinates, counting from the top left.
    @game_ui = Window.new(42, 65, 0, 0)
    # bold text, more readable
    @game_ui.attrset(A_BOLD)
    # set the color scheme to the one previously defined
    @game_ui.color_set(1)
    # from 1 to 4 depending on splits; changes position cards are dealt to
    @num_hands = 1
    # tells program what screen location a new card should go in for each hand.
    # index 0: dealer, 1: player's initial hand, 2-4: additional player hands after splits
    # tells program what horizontal/vertical position to draw card graphics
    @hands = [1, 0, 0, 0, 0]
  end

  # reset the game with new background
  def paint_game(table)
    game_ui.clear
    game_ui.addstr(table)
  end

  # change lower background of game when the player splits a hand
  def paint_split(hand)
    # y-coordinate, x-coordinate to place string
    game_ui.setpos(16, 0)
    game_ui.addstr(hand)
  end

  # deal cards to the correct locations for a new turn
  def normalize_hand
    @hands = [1, 0, 0, 0, 0]
    @num_hands = 1
  end

  # reset the table and cards betweeen turns
  def new_hand(bankroll_funds = 5000, cards_remaining = 312)
    # deal cards to the correct locations for a new turn
    normalize_hand
    # clear off the graphics placed on the screen in the last turn
    paint_game(TABLE)
    paint_split(ONE_HAND)
    # show counters for player bankroll and the number of cards in the deck, defaults are values for a new game
    paint_bankroll(bankroll_funds)
    paint_cards_remaining(cards_remaining)
    # one facedown card to dealer
    paint_card(FACEDOWN, 0)
    # two facedown cards to player
    paint_card(FACEDOWN)
    paint_card(FACEDOWN)
    # necessary to deal faceup cards on top of facedown "cards," not next to them
    normalize_hand
  end

  # display a card on the screen. default values indicate it should be dealt to the player's hand with no splits
  def paint_card(card, hand_num = 1, num_hands = 1)
    # dealer
    if hand_num == 0
      # array of card graphics, y-coordinate, x-coordinate
      card_gfx(card, 1, hands[0])
      # deal next card to the next location in the dealer's hand
      @hands[0] += 5
    # player's hand with no splits
    elsif num_hands == 1
      card_gfx(card, 17, hands[1] * 5 + 1)
      # deal next card in the player's first hand to the player's hand
      @hands[1] += 1
    # player has two hands
    elsif num_hands == 2
      # array of card graphics, y-coordinate, x-coordinate
      card_gfx(
        card, 17 + hands[hand_num] / 6 * 3,
        hands[hand_num] % 6 * 5 + 32 * (hand_num - 1) + 1
      )
      # deal next card dealt to the current hand to the next location in that hand
      @hands[hand_num] += 1
    # three hands
    elsif num_hands == 3
      card_gfx(
        card, 18 + hands[hand_num] / 4 * 3,
        hands[hand_num] % 4 * 5 + 21 * (hand_num - 1) + 1
      )
      @hands[hand_num] += 1
    # four hands
    else
      card_gfx(
        card, 18 + hands[hand_num] / 3 * 3,
        hands[hand_num] % 3 * 5 + 16 * (hand_num - 1) + 1
      )
      @hands[hand_num] += 1
    end
  end

  # counter of player's bankroll
  def paint_bankroll(bankroll_funds)
    game_ui.setpos(4, 11)
    game_ui.addstr(bankroll_funds.to_s)
  end

  # counter of cards remaining in deck
  def paint_cards_remaining(cards_remaining)
    game_ui.setpos(4, 61)
    game_ui.addstr(cards_remaining.to_s)
  end

  # displays amount player has bet on each hand. default is on player's hand with no splits
  def paint_bet(bet, hand_num = 1, num_hands = 1)
    if num_hands == 1
      game_ui.setpos(16, 16)
      game_ui.addstr(bet.ljust(11))
    elsif num_hands == 2
      # show bet over the correct hand
      game_ui.setpos(16, 17 + 32 * (hand_num - 1))
      game_ui.addstr(bet.ljust(11))
    elsif num_hands == 3
      game_ui.setpos(17, 6 + 21 * (hand_num - 1))
      game_ui.addstr(bet.ljust(11))
    else
      game_ui.setpos(17, 6 + 16 * (hand_num - 1))
      game_ui.addstr(bet.ljust(11))
    end
  end

  private

  # card graphics are an array of 3 strings; this prints them out correctly, one underneath the other
  def card_gfx(arr, y, x)
    (0..2).each { |n| game_ui.setpos(y + n, x); game_ui.addstr(arr[n]) }
  end
end

# my_game = FancyGraffix.new
# my_game.paint_game(LOADSCREEN)

# while ch = my_game.game_ui.getch
#   case ch
#   when 's'
#     my_game.new_hand
#   when 'l'
#     my_game.paint_card(FACEDOWN)
#   when 't'
#     my_game.paint_card(Card.new('10', 'C').gfx, 0)
#     my_game.paint_card(Card.new('K', 'D').gfx)
#   when 'r'
#     my_game.paint_card(Card.new('10', 'C').gfx, 0)
#     my_game.paint_card(Card.new('K', 'D').gfx, 1, 2)
#     my_game.paint_card(Card.new('Q', 'H').gfx, 2, 2)
#   when 'e'
#     my_game.paint_card(Card.new('10', 'C').gfx, 0)
#     my_game.paint_card(Card.new('K', 'D').gfx, 1, 3)
#     my_game.paint_card(Card.new('Q', 'H').gfx, 2, 3)
#     my_game.paint_card(Card.new('A', 'S').gfx, 3, 3)
#   when 'w'
#     my_game.paint_card(Card.new('10', 'C').gfx, 0)
#     my_game.paint_card(Card.new('K', 'D').gfx, 1, 4)
#     my_game.paint_card(Card.new('Q', 'H').gfx, 2, 4)
#     my_game.paint_card(Card.new('A', 'S').gfx, 3, 4)
#     my_game.paint_card(Card.new('2', 'H').gfx, 4, 4)
#   when 'u'
#     my_game.paint_split(ONE_HAND)
#   when 'i'
#     my_game.paint_split(TWO_HANDS)
#   when 'o'
#     my_game.paint_split(THREE_HANDS)
#   when 'p'
#     my_game.paint_split(FOUR_HANDS)
#   when 'q'
#     exit
#   when 13
#     my_game.new_hand
#   end
# end

# my_game = FancyGraffix.new
# my_bankroll = Bankroll.new
# my_game.new_hand
# while bet = my_bankroll.get_bet(my_game)
#   break if bet.end_with?('A')
#   my_game.paint_bet(bet)
# end