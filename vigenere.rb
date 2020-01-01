# load './vigenere.rb'
# client = Vigenere.new('erudite')
# encrypted = client.encrypt([13, 2, 22, 4, 1])
# p encrypted
# client = Vigenere.new(encrypted)
# decrypted = client.decrypt([13, 2, 22, 4, 1])
# p decrypted

class Vigenere
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def encrypt(keys)
    alpha = alphabet.reverse
    encrypted_word = ""

    if keys.is_a?(String)
      keys = convert_keyword_into_index_array(keys)
    end

    message.each_char.with_index do |char, i|
      key = keys[i % keys.length]
      shifted_alpha = alpha[key..-1] + alpha[0...key]
      encrypted_word << shifted_alpha[alpha.index(char)]
    end
    encrypted_word
  end

  def decrypt(keys)
    decrypted_word = ""

    message.each_char.with_index do |char, i|
      key = keys[i % keys.length]
      shifted_alpha = alphabet[key..-1] + alphabet[0...key]
      decrypted = shifted_alpha[alphabet.index(char)] rescue char
      decrypted_word << decrypted
    end
    decrypted_word
  end

  private

  def convert_keyword_into_index_array(keyword)
    keyword.split('').map{|char| alphabet.index(char) }
  end

  def alphabet
    @alphabet ||= %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  end
end

