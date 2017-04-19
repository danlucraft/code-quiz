
class Integer
  def to_roman_numeral
    "I"
  end
end

class String
  def to_i_from_roman
    1
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
  end
end
