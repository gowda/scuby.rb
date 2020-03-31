# frozen_string_literal: true

module SuperTinyCompiler
  class Token
    WHITESPACE = /\s/.freeze
    NUMBERS = /[0-9]/.freeze
    LETTERS = /[a-z]/i.freeze
    PARENS = ['(', ')'].freeze

    PAREN = 'SuperTinyCompiler::Token::PAREN'
    NAME = 'SuperTinyCompiler::Token::NAME'
    NUMBER = 'SuperTinyCompiler::Token::NUMBER'
    STRING = 'SuperTinyCompiler::Token::STRING'

    attr_reader :type, :value

    def initialize(type, value)
      @type = type
      @value = value
    end

    def eql?(other)
      type == other.type && value == other.value
    end

    def ==(other)
      eql?(other)
    end
  end
end
