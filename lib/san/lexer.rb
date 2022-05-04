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
      tokenize()

      tokens
    end

    private

    attr_accessor :line, :next_p, :lexeme_start_p

    def tokenize
    end
  end
end
