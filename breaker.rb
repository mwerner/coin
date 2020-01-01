class Breaker
  attr_reader :scheme

  def initialize(scheme)
    @scheme = scheme
  end

  def run
    decryptions = {}
    result = brute_force(scheme)
  end

  def brute_force(scheme)
    key_length = 4
    results = {}

    matched_results = []
    results = build_permutations(scheme, key_length) # Static set to four alphabets
    results[:ranges].each_pair do |key_count, decryptions|
      matches = decryptions.keys & words
      matches.each do |match|
        puts "[#{decryptions[match].join(', ')}] #{match}"
      end
      matched_results += matches
    end
    nil
  end

  def build_permutations(scheme, key_count)
    results = {ranges: {1 => {}, 2 => {}, 3 => {}, 4 => {}, 5 => {} }}

    26.times do |a|
      result = scheme.decrypt([a])
      results[:ranges][1][result] = [a]
      if key_count >= 1
        26.times do |b|
          result = scheme.decrypt([a, b])
          results[:ranges][2][result] = [a, b]
          if key_count >= 2
            26.times do |c|
              result = scheme.decrypt([a, b, c])
              results[:ranges][3][result] = [a, b, c]
              if key_count >= 4
                26.times do |d|
                  result = scheme.decrypt([a, b, c, d])
                  results[:ranges][4][result] = [a, b, c, d]
                  if key_count >= 5
                    26.times do |e|
                      result = scheme.decrypt([a, b, c, d, e])
                      results[:ranges][5][result] = [a, b, c, d, e]
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    results
  end

  private

  def words
    @words ||= File.readlines("/usr/share/dict/words").map { |w| w.chomp.downcase }.uniq
  end
end
