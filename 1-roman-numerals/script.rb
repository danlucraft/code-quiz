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
    "M"  => 1000,
    "CM" => 900,

    "D"  => 500,
    "LD" => 450,
    "CD" => 400,

    "C"  => 100,
    "XC" => 90,

    "L"  => 50,
    "VL" => 45,
    "XL" => 40,

    "X"  => 10,
    "IX" => 9,

    "V"  => 5,
    "IV" => 4,

    "I"  => 1,
  }

  def self.to_roman(i)
    result = ""
    while i > 0
      VALUES.to_a.each do |string, value|
        if i >= value
          result << string
          i -= value
          break
        end
      end
    end
    result
  end

  def self.from_roman(roman_string)
    sum = 0
    s = roman_string.dup
    while s.length > 0
      VALUES.to_a.each do |string, value|
        if s.start_with?(string)
          sum += value
          s = s[string.length..-1]
          break
        end
      end
    end
    sum
  end
end

if $0 == __FILE__
  if ARGV.include?("--test")
    ARGV.delete("--test")
    require 'test/unit'

    class ToRomanTestCase < Test::Unit::TestCase
      def test_ones
        assert_equal "I", 1.to_roman
        assert_equal "III", 3.to_roman
      end

      def test_decreasing_values
        assert_equal "VI", 6.to_roman
        assert_equal "XVI", 16.to_roman
      end

      def test_increasing_unit_size
        assert_equal "IV", 4.to_roman
        assert_equal "IX", 9.to_roman
        assert_equal "XIV", 14.to_roman
        assert_equal "CM", 900.to_roman
        assert_equal "MXL", 1040.to_roman
        assert_equal "CCXCI", 291.to_roman
        assert_equal "XCIV", 94.to_roman
        assert_equal "MCMXCIX", 1999.to_roman
        assert_equal "XXXVIII", 38.to_roman
      end
    end

    class FromRomanTestCase < Test::Unit::TestCase
      def test_one
        assert_equal 1, "I".to_i_from_roman
      end

      def test_three
        assert_equal 3, "III".to_i_from_roman
      end

      def test_decreasing_unit_size
        assert_equal 6, "VI".to_i_from_roman
        assert_equal 16, "XVI".to_i_from_roman
      end

      def test_increasing_unit_size
        assert_equal 4, "IV".to_i_from_roman
        assert_equal 9, "IX".to_i_from_roman
        assert_equal 14, "XIV".to_i_from_roman
        assert_equal 900, "CM".to_i_from_roman
        assert_equal 1040, "MXL".to_i_from_roman
        assert_equal 291, "CCXCI".to_i_from_roman
        assert_equal 94, "XCIV".to_i_from_roman
      end
    end
  else
    while line = gets
      string = line.chomp
      if string =~ /\A\d+\Z/
        puts string.to_i.to_roman
      else
        puts string.to_i_from_roman
      end
    end
  end
end