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
      puts "lexeme_start_p: #{@lexeme_start_p}"
      puts "next_p: #{@next_p}"

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

    def lookahead(offset = 1)
      lookahead_p = (@next_p - 1) + offset
      return "\0" if lookahead_p >= source.length

      source[lookahead_p]
    end

    def token_from_one_char(key)
      key
    end

    def token_from_one_or_two_char(key)
      key
    end

    def ignore_comment_line
      while lookahead() != "\n" && source_uncompleted?
        consume()
      end
    end

    def source_completed?
      @next_p >= self.source.length
    end

    def source_uncompleted?
      !source_completed?
    end
  end
end
