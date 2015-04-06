# How the cards dealt affect a hand in blackjack.
class Hand
  attr_reader :cards
  def initialize(cards = [], score = 0)
    # an array of Card objects
    @cards = cards
    # the value of the cards in the hand; Aces 1 or 11, number cards according to value, face cards are 10
    @score = score
  end

  # check the score of the hand
  def score
    @cards.each { |card| @score += card.rank.to_i }
    aces = @cards.select { |card| card.rank =~ /A/ }.length
    # set initial Ace value to 11
    @score += aces * 11
    @score += 10 * @cards.select { |card| card.rank =~ /[JQK]/ }.length
    # converts Aces to 1s until score is 21 or under
    while @score > 21 && aces > 0
      aces -= 1
      @score -= 10
    end
    @score
  end

  # number of cards in the hand
  def size
    @cards.length
  end

  # check if two cards are a blackjack
  def blackjack?
    score == 21 && size == 2
  end

  # draw a card from the deck and add it to the hand, add 4 new decks if fewer than 2 decks left in play
  def hit(deck)
    deck.add_decks if deck.size < 104
    @cards << deck.draw
  end
end
