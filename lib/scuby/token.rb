# frozen_string_literal: true

module Scuby
  class Token
    WHITESPACE = /\s/.freeze
    NUMBERS = /[0-9]/.freeze
    LETTERS = /[a-z]/i.freeze
    PARENS = ['(', ')'].freeze

    PAREN = :paren
    NAME = :name
    NUMBER = :number
    STRING = :string

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

    def self.whitespace?(char)
      WHITESPACE.match?(char)
    end

    def self.letter?(char)
      LETTERS.match?(char)
    end

    def self.number?(char)
      NUMBERS.match?(char)
    end

    def self.double_quote?(char)
      char == '"'
    end

    def self.paren?(char)
      ['(', ')'].include?(char)
    end
  end
end
