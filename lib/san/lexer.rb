module San
  class Lexer
    WHITESPACE = [' ', "\r", "\t"].freeze
    ONE_CHAR_LEX = ['(', ')', ':', ',', '.', '-', '+', '/', '*'].freeze
    ONE_OR_TWO_CHAR_LEX = ['!', '=', '>', '<'].freeze
    KEYWORD = ['and', 'else', 'end', 'false', 'var', 'fun', 'if', 'nil', 'or', 'return', 'true', 'while'].freeze

    attr_reader :source, :tokens

    def initialize(source)
      @source = source
      @tokens = []
      @line = 0
      @next_p = 0
      @lexeme_start_p = 0
    end

    def start_tokenization
      while source_uncompleted?
        tokenize()
      end

      tokens
    end

    private

    attr_accessor :line, :next_p, :lexeme_start_p

    def tokenize
      # puts "source.length: #{@source.length}"
      # puts "lexeme_start_p: #{@lexeme_start_p}"
      # puts "next_p: #{@next_p}"
      # puts "line: #{@line}"

      self.lexeme_start_p = next_p
      token = nil

      c = consume()

      return if WHITESPACE.include?(c)
      return ignore_comment_line() if c == "#"

      if c == "\n"
        @line += 1
        tokens << token_from_one_char(c) if tokens.last&.type != :"\n"

        return
      end

      token =
        if ONE_CHAR_LEX.include?(c)
          token_from_one_char(c)
        elsif ONE_OR_TWO_CHAR_LEX.include?(c)
          token_from_one_or_two_char(c)
        elsif c == '"'
          string()
        elsif digit?(c)
          number()
        elsif alpha_numeric?(c)
          identifier()
        end

      if token
        self.tokens << token
      else
        raise("Unknown character \"#{c}\"")
      end
    end

    def consume
      c = lookahead()
      @next_p += 1
      c
    end

    def consume_digits
      while digit?(lookahead())
        consume()
      end
    end

    def lookahead(offset = 1)
      lookahead_p = (@next_p - 1) + offset
      return "\0" if lookahead_p >= source.length

      source[lookahead_p]
    end

    def token_from_one_char(key)
      Token.new(key.to_sym, key, nil, current_location())
    end

    def token_from_one_or_two_char(key)
      n = lookahead()
      if n == "="
        consume()
        Token.new((key + n).to_sym , key + n, nil, current_location())
      else
        token_from_one_char(key)
      end
    end

    def digit?(c)
      c >= "0" && c <= "9"
    end

    def string
      while lookahead() != '"' && source_uncompleted?()
        @line += 1 if lookahead() == "\n"
        consume()
      end
      raise "unterminated string error." if source_completed?()

      consume()
      value = source[(lexeme_start_p)..(next_p - 1)]
      literal = source[(lexeme_start_p)..(next_p - 2)]

      Token.new(:string, value, literal, current_location())
    end

    def number
      consume_digits()

      if lookahead == "." && digit?(lookahead(2))
        consume()
        consume_digits()
      end

      value = source[lexeme_start_p..(next_p - 1)]
      Token.new(:number, value, value.to_f, current_location())
    end

    def alpha_numeric?(c)
      alpha?(c) || digit?(c)
    end

    def identifier
      while alpha_numeric?(lookahead())
        consume()
      end

      identifier = source[lexeme_start_p..(next_p - 1)]
      type =
        if KEYWORD.include?(identifier)
          identifier.to_sym
        else
          :identifier
        end

      puts type

      Token.new(type, identifier, nil, current_location())
    end

    def alpha?(c)
      c >= "a" && c <= "z" ||
      c >= "A" && c <= "Z" ||
      c == "_"
    end

    def ignore_comment_line
      while lookahead() != "\n" && source_uncompleted?()
        consume()
      end
    end

    def current_location
      Location.new(@line, @lexeme_start_p, @next_p - @lexeme_start_p)
    end

    def after_source_end_location
      Location.new(line, next_p, 1)
    end

    def source_completed?
      @next_p >= source.length
    end

    def source_uncompleted?
      !source_completed?()
    end
  end
end
