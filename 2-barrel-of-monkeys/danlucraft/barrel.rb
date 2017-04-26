require "rexml/document"

def force_ascii(letter)
  case letter
  when "É", "é", "ê"
    "e"
  when "ó"
    "o"
  when "ü"
    "u"
  else
    letter
  end
end

class Song < Struct.new(:name, :duration)
  def safe_name; name.gsub(/[^[[:alpha:]]]/, ""); end
  def first;     force_ascii safe_name[0].downcase;           end
  def last;      force_ascii safe_name[-1].downcase;          end
end

class Songfile
  def initialize(filename)
    @doc = REXML::Document.new(File.read(filename))
  end

  def songs
    r = []
    @doc.elements.each("Library/Artist/Song") do |el|
      r << Song.new(el.attributes["name"], el.attributes["duration"].to_i)
    end
    r.reject {|song| song.safe_name == ""}
  end
end

class Barrel
  attr_reader :connectors

  class Impossible < StandardError
  end

  def initialize(songs)
    if File.exist?("cache")
      puts "Loading from cache"
      puts
      @connectors = Marshal.load(File.read("cache"))
    else
      @connectors = Hash.new { |h, k|
        h[k] = {min_count: nil, min_duration: nil}
      }

      songs.each do |song|
        connector = {duration: song.duration, song: song, count: 1}
        @connectors[[song.first, song.last]][:min_count]    = connector
        @connectors[[song.first, song.last]][:min_duration] = connector
      end

      print "Precalculating #{25*26} connections..."; $stdout.flush
      prev = nil

      while @connectors.length < 25*26 && # nothing ends with q 
            prev != @connectors.length
        prev = @connectors.length

        songs.each do |song|
          @connectors.keys.each do |(a, b)|
            d = @connectors[[a, b]]
            
            if song.last == a
              new_connector_min_count = {
                song:     song, 
                duration: d[:min_count][:duration] + song.duration, 
                count:    d[:min_count][:count]    + 1,
              }
              new_connector_min_duration = {
                song:     song, 
                duration: d[:min_duration][:duration] + song.duration, 
                count:    d[:min_duration][:count]    + 1,
              }
              if @connectors.key?([song.first, b])
                existing = @connectors[[song.first, b]]
                if existing[:min_duration][:duration] > d[:min_duration][:duration] + song.duration
                  existing[:min_duration] = new_connector_min_duration
                end
                if existing[:min_count][:count] > d[:min_count][:count] + 1
                  existing[:min_count] = new_connector_min_count
                end
              else
                @connectors[[song.first, b]][:min_count] = new_connector_min_count
                @connectors[[song.first, b]][:min_duration] = new_connector_min_duration
              end
            end
          end

          if @connectors.length >= 25*26
            puts "done"
            @connectors.default = nil
            File.open("cache", "w") {|f| f.puts Marshal.dump(@connectors)}
            return
          end
        end
      end
    end
  end

  def connect(a, b, strategy: :min_count)
    puts "From #{a.name.inspect} (#{a.last}) to #{b.name.inspect} (#{b.first})"
    connect1(a.last, b.first, strategy: strategy)
  end

  def connect1(a_last, b_first, strategy:)
    raise Impossible.new("No songs end with 'q'") if b_first == "q"

    song = @connectors[[a_last, b_first]][strategy]
    
    return [song[:song]] if song[:song].last == b_first
    [song[:song]] + connect1(song[:song].last, b_first, strategy: strategy)
  end
end

$songs = Songfile.new(ARGV[0]).songs

a = $songs[rand($songs.length)]
b = $songs[rand($songs.length)]

def check_playlist(first, last, playlist)
  err = "#{first}->#{last} error!"
  raise err unless playlist[0].first == first
  playlist.each_cons(2) do |x, y|
    raise err unless x.last == y.first
  end
  raise err unless playlist[-1].last == last
end

def self_test(barrel)
  puts "Self testing all combinations of start and end character"
  results = {}
  n = 0
  sum_count    = 0
  sum_duration = 0
  max_length_playlist = nil
  ('a'..'z').each do |first|
    ('a'..'z').each do |last|
      next if last == "q"

      playlist = barrel.connect1(first, last, strategy: :min_count)
      check_playlist(first, last, playlist)
      sum_count += playlist.length
      if !max_length_playlist || playlist.length > max_length_playlist.length
        max_length_playlist = playlist
      end

      playlist = barrel.connect1(first, last, strategy: :min_duration)
      check_playlist(first, last, playlist)
      sum_duration += playlist.map(&:duration).inject(0, &:+)

      n += 1
    end
  end
  puts "Av Count:            #{sum_count.to_f/n}"
  puts "Av Duration:         #{sum_duration.to_f/n}"
  puts "Max Count Playlist:  #{max_length_playlist.map(&:name).inspect}"
end

barrel = Barrel.new($songs)
puts

self_test(barrel)
puts

def rand_song
  $songs[rand($songs.length)]
end

10.times do
  puts barrel.connect(rand_song, rand_song, strategy: :min_duration).map(&:name)
  puts
end
