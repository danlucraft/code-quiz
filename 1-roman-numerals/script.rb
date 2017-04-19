class Integer
  def to_roman_numeral
    "I" * self
  end
end

class String
  def to_i_from_roman
    RomanNumerals.from_roman(self)
  end
end

class RomanNumerals
  VALUES = {
    "I" => 1,
    "V" => 5,
    "X" => 10,
    "L" => 50,
    "C" => 100,
    "D" => 500,
    "M" => 1000,
  }

  def self.from_roman(string)
    sum = 0
    string.each_char do |char|
      next unless VALUES[char]
      sum += VALUES[char]
    end
    sum
  end
end

if ARGV.include?("--test")
  ARGV.delete("--test")
  require 'test/unit'

  class FromRomanTestCase < Test::Unit::TestCase
    def test_one
      assert_equal "I".to_i_from_roman, 1
    end

    def test_three
      assert_equal "III".to_i_from_roman, 3
    end

    def test_decreasing_unit_size
      assert_equal "VI".to_i_from_roman, 6
      assert_equal "XVI".to_i_from_roman, 16
    end
  end
end
