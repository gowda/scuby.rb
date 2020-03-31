# frozen_string_literal: true

require_relative 'token'

module SuperTinyCompiler
  module Tokenizer
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def tokenize(source)
        TokenizerWorker.new(source).tokens
      end
    end

    class TokenizerWorker
      def initialize(source)
        @source = source
        @tokens = nil
      end

      def tokens
        process! if @tokens.nil?
        @tokens
      end

      private

      def whitespace?(char)
        Token::WHITESPACE.match?(char)
      end

      def number?(char)
        Token::NUMBERS.match?(char)
      end

      def double_quote?(char)
        char == '"'
      end

      def paren?(char)
        Token::PARENS.include?(char)
      end

      def letter?(char)
        Token::LETTERS.match?(char)
      end

      def process!
        @tokens = []
        current = 0

        while current < @source.length
          char = @source[current]

          if paren?(char)
            @tokens << Token.new(Token::PAREN, char)
            current += 1
            next
          end

          if whitespace?(char)
            current += 1
            next
          end

          if number?(char)
            value = String.new

            while number?(char)
              value << char
              current += 1
              char = @source[current]
            end

            @tokens << Token.new(Token::NUMBER, value)
            next
          end

          if double_quote?(char)
            value = String.new
            current += 1
            char = @source[current]

            while double_quote?(char)
              value << char
              current += 1
              char = @source[current]
            end

            current += 1
            char = @source[current]

            @tokens << Token.new(Token::STRING, value)
            next
          end

          if letter?(char)
            value = String.new

            while letter?(char)
              value << char
              current += 1
              char = @source[current]
            end

            @tokens << Token.new(Token::NAME, value)
            next
          end

          raise ArgumentError, "Unrecognized token in input: #{char}"
        end
      end
    end
  end
end
