# frozen_string_literal: true

# frozen_string_literal

module SuperTinyCompiler
  require 'super_tiny_compiler/tokenizer'
  require 'super_tiny_compiler/parser'
  require 'super_tiny_compiler/transformer'
  require 'super_tiny_compiler/code_generator'

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
