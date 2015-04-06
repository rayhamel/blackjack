#!/usr/bin/env ruby

require 'pry'
require 'csv'
require 'curses'
include Curses

require_relative 'lib/advice'
require_relative 'lib/bankroll'
require_relative 'lib/card'
require_relative 'lib/deck'
require_relative 'lib/fancygraffix'
require_relative 'lib/game_state'
require_relative 'lib/hand'
require_relative 'lib/new_game'
require_relative 'lib/savegame'

blackjack = NewGame.new
blackjack.paint_game(LOADSCREEN)
# blackjack.new_hand
loop do
  case blackjack.live_logic
  when :start_screen
    ch = blackjack.input_ch
    case ch
    when 's'
      blackjack.new_hand
      blackjack.invoke_player_bet
      blackjack.back_to_game
    when 'q'
      break
    end
  when :player_bet
    player_bet = blackjack.get_bet
    blackjack.paint_bet(player_bet)
    break if blackjack.bet > 0
  end
end