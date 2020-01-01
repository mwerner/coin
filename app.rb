require_relative 'vigenere'
require_relative 'porta'
require_relative 'breaker'

class Crypt
  def self.encrypt(scheme, message, keyword)
    client = build_scheme(scheme, message)
    client.encrypt(keyword)
  end

  def self.decrypt(scheme, message, keyword = nil)
    client = build_scheme(scheme, message)

    if keyword
      client.decrypt(keyword)
    else
      breaker = Breaker.new(client)
      results = breaker.run
    end
  end

  def self.build_scheme(approach, message)
    case approach.to_sym
    when :vigenere
      Vigenere.new(message)
    when :porta
      Porta.new(message)
    end
  end
end
