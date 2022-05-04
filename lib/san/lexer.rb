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

    def source_completed?
      @next_p >= self.source.length
    end

    def source_uncompleted?
      !source_completed?
    end
  end
end
