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
    "CD" => 400,

    "C"  => 100,
    "XC" => 90,

    "L"  => 50,
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
  while line = gets
    string = line.chomp
    if string =~ /\A\d+\Z/
      puts string.to_i.to_roman
    else
      puts string.to_i_from_roman
    end
  end
end