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
    chars = string.chars
    while chars.any?
      if chars[1] and VALUES[chars[0]] < VALUES[chars[1]]
        sum += VALUES[chars[1]] - VALUES[chars[0]]
        chars.shift(2)
      else
        sum += VALUES[chars[0]]
        chars.shift
      end
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

    def test_increasing_unit_size
      assert_equal "IV".to_i_from_roman, 4
      assert_equal "IX".to_i_from_roman, 9
      assert_equal "XIV".to_i_from_roman, 14
      assert_equal "CM".to_i_from_roman, 900
      assert_equal "MXL".to_i_from_roman, 1040
      assert_equal "CCXCI".to_i_from_roman, 291
    end
  end
end
