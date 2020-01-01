class Porta
  attr_reader :message

  def initialize(message)
    @message = message.downcase
  end

  def encrypt(key_string)
    encrypted_word = ""
    key_string = key_string.is_a?(Array) ? key_string.join : key_string
    p key_string
    message.each_char.with_index do |char, i|
      index = key_string[i % key_string.length]
      shifted_alpha = tableau_row(index)
      encrypted_word << shifted_alpha[alphabet.index(char)]
    end
    encrypted_word
  end

  def decrypt(key_string)
    encrypted_word = ""

    if key_string.is_a?(Array)
      key_string = convert_index_array_to_keyword(key_string)
    end
    if key_string == 'fort'
      p "keystring3: #{key_string.inspect}"
    end
    message.each_char.with_index do |char, i|
      if char == " "
        encrypted_word << char
        next
      end

      index = key_string[i % key_string.length]
      shifted_alpha = tableau_row(index)
      encrypted_word << shifted_alpha[alphabet.index(char)]
    end
    encrypted_word
  end

  private

  def tableau
    @tableau ||= begin
      table = {}
      front = alphabet[0..12]
      back = alphabet[13..-1]


      (0..12).each do |rot|
        shifted_back = back[rot..-1] + back[0...rot]

        offset = 13 - rot
        shifted_front = front[offset..-1] + front[0...offset]

        alpha = shifted_back + shifted_front
        table[rot] = alpha
      end
      table
    end
  end

  def tableau_row(char)
    tableau[(alphabet.index(char) / 2.0).floor]
  end

  def convert_index_array_to_keyword(array)
    array.map{|char| alphabet[char] }.join
  end

  def alphabet
    @alphabet ||= %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  end
end
