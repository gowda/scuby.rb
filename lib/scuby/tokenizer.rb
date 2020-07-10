# frozen_string_literal: true

require_relative 'token'

module Scuby
  module Tokenizer
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def tokenize(source)
        TokenList.new(source).to_a
      end
    end

    class TokenList
      include Enumerable

      attr_reader :source
      attr_reader :current_position

      def initialize(source)
        @source = source
        @current_position = 0
      end

      def each
        to_enum(:each) unless block_given?

        yield current_token while @current_position < @source.length
      end

      private

      def current_token
        process_next_token
      end

      def current_char
        @source[current_position]
      end

      def current_char_and_inc_pointer
        inc_pointer
        @source[current_position - 1]
      end

      def inc_pointer
        @current_position += 1
      end

      def process_next_token
        # skip all whitespaces
        inc_pointer while Token.whitespace?(current_char)

        process_next_token_as_string ||
          process_next_token_as_number ||
          process_next_token_as_name ||
          process_next_token_as_paren
      end

      def process_next_token_as_string
        return nil unless Token.double_quote?(current_char)

        value = String.new
        inc_pointer

        while Token.double_quote?(current_char)
          value << current_char
          inc_pointer
        end

        inc_pointer

        Token.new(Token::STRING, value)
      end

      def process_next_token_as_number
        return nil unless Token.number?(current_char)

        value = String.new

        while Token.number?(current_char)
          value << current_char
          inc_pointer
        end

        Token.new(Token::NUMBER, value)
      end

      def process_next_token_as_name
        return nil unless Token.letter?(current_char)

        value = String.new

        while Token.letter?(current_char)
          value << current_char
          inc_pointer
        end

        Token.new(Token::NAME, value)
      end

      def process_next_token_as_paren
        return nil unless Token.paren?(current_char)

        Token.new(Token::PAREN, current_char_and_inc_pointer)
      end
    end
  end
end
