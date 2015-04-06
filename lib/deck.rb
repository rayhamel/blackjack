RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
SUITS = %w(C D H S)

# Dealing out the cards used in play.
class Deck
  attr_accessor :cards
  def initialize
    # an array of cards in the game deck
    @cards = []
    # add 6 decks of 52 cards to the game deck
    6.times do
      RANKS.each { |rank| SUITS.each { |suit| @cards << Card.new(rank, suit) } }
    end
    # shuffle the game deck at creation
    @cards.shuffle!
  end

  # the number of cards in the game deck
  def size
    @cards.length
  end

  # when there are 2 or fewer decks left in play
  def add_decks
    # add 4 decks of 52 cards to the game deck
    4.times do
      RANKS.each { |rank| SUITS.each { |suit| @cards << Card.new(rank, suit) } }
    end
    # and shuffle the whole deck
    @cards.shuffle!
  end
end
