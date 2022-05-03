module San
  class Lexer
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
