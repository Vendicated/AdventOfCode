enum HandType
  HighCard
  OnePair
  TwoPair
  ThreeOfAKind
  FullHouse
  FourOfAKind
  FiveOfAKind
end

class Hand
  @card_set = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

  getter :cards, :bid, :rank

  def initialize(cards : String, bid : Int32, rank : HandType)
    @cards = cards
    @bid = bid
    @rank = rank
  end

  def self.from(line : String)
    cards, bid = line.split " "

    self.new cards, bid.to_i, self.calc_rank(cards)
  end

  def <=>(other : self) : Int32
    return -1 if other.rank > @rank
    return 1 if @rank > other.rank

    @cards.each_char_with_index do |c, i|
      if c != other.cards[i]
        idx, other_idx = @card_set.index!(c), @card_set.index!(other.cards[i])
        return idx > other_idx ? -1 : 1
      end
    end

    return 0
  end

  def self.calc_rank(cards : String) : HandType
    frequencies = cards.chars.tally.values

    has_pair = frequencies.includes? 2
    has_triple = frequencies.includes? 3
    has_quadruple = frequencies.includes? 4
    has_quintuple = frequencies.includes? 5

    return HandType::FiveOfAKind if has_quintuple
    return HandType::FourOfAKind if has_quadruple
    return HandType::FullHouse if has_pair && has_triple
    return HandType::ThreeOfAKind if has_triple
    return HandType::HighCard unless has_pair

    return frequencies.count(2) == 2 ? HandType::TwoPair : HandType::OnePair
  end
end

class Hand2 < Hand
  @card_set = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']

  def self.calc_rank(cards : String) : HandType
    return super cards unless cards.includes? 'J'

    frequency_map = cards.chars.tally
    jokers = frequency_map['J']

    frequencies = frequency_map.values

    has_pair = frequencies.any? { |n| n >= 2 - jokers }
    has_triple = frequencies.any? { |n| n >= 3 - jokers }
    has_quadruple = frequencies.any? { |n| n >= 4 - jokers }
    has_quintuple = frequencies.any? { |n| n >= 5 - jokers }

    return HandType::FiveOfAKind if has_quintuple
    return HandType::FourOfAKind if has_quadruple
    return HandType::FullHouse if has_pair && has_triple
    return HandType::ThreeOfAKind if has_triple
    return HandType::HighCard unless has_pair

    return frequencies.count { |n| n >= 2 - jokers } == 2 ? HandType::TwoPair : HandType::OnePair
  end
end

def solve(file)
  hands = File.read_lines(file).map do |line|
    Hand.from line
  end
  handsPart2 = File.read_lines(file).map do |line|
    Hand2.from line
  end

  puts file,
    hands.sort!.map_with_index { |h, i| h.bid * (i + 1) }.sum,
    handsPart2.sort!.map_with_index { |h, i| h.bid * (i + 1) }.sum
end

solve "example.txt"
puts
solve "input.txt"
