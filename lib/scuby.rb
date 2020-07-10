# frozen_string_literal: true

module Scuby
  require 'scuby/tokenizer'
  require 'scuby/parser'
  require 'scuby/transformer'
  require 'scuby/code_generator'

  include Tokenizer
  include Parser
  include Transformer
  include CodeGenerator

  def self.compile(source)
    tokenize(source)
      .then { |tokens| parse(tokens) }
      .then { |ast| transform(ast) }
      .then { |ast| generate_code(ast) }
  end
end
