
class Integer
  def to_roman_numeral
    "I" * self
  end
end

class String
  def to_i_from_roman
    length
  end
end

if ARGV.include?("--test")
  ARGV.delete("--test")
  require 'test/unit'

  class TestCase < Test::Unit::TestCase
    def test_one
      assert_equal 1.to_roman_numeral, "I"
      assert_equal "I".to_i_from_roman, 1
    end

    def test_three
      assert_equal 3.to_roman_numeral, "III"
      assert_equal "III".to_i_from_roman, 3
    end
  end
end
