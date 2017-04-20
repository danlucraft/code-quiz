require './roman_numerals'
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