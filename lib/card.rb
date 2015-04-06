# Behavior of a single card. I kept it simple so that the other classes would
# have few dependencies on it and it could be reused for other card games.
class Card
  attr_reader :rank, :suit, :gfx
  def initialize(rank, suit)
    # the value of the card: A, 2-10, J, Q, K
    @rank = rank
    # the suit of the card: C, D, H, S
    @suit = suit
    # a visual representation of the card. each string in the array is displayed underneath the last by FancyGraffix
    @gfx = ["|#{rank.ljust(3)}|", '|   |', "|  #{suit}|"]
  end
end
