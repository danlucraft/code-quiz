class Integer
  def to_roman
    
    RomanNumerals.to_roman(self)
  end
end

class String
  def to_i_from_roman
    RomanNumerals.from_roman(self)
  end
end

class RomanNumerals
  VALUES = {
    "M" => 1000,
    "D" => 500,
    "C" => 100,
    "L" => 50,
    "X" => 10,
    "V" => 5,
    "I" => 1,
  }

  def self.to_roman(i)
    result = ""
    while i > 0
      VALUES.each do |char, value|
        if value <= i
          i -= value
          result << char
        end
      end
    end
    result
  end

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

  class ToRomanTestCase < Test::Unit::TestCase
    def test_ones
      assert_equal 1.to_roman, "I"
      assert_equal 3.to_roman, "III"
    end

    def test_decreasing_values
      assert_equal 6.to_roman, "VI"
      assert_equal 16.to_roman, "XVI"
    end
  end

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
