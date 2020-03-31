# frozen_string_literal: true

# frozen_string_literal

require_relative 'super_tiny_compiler/tokenizer'
require_relative 'super_tiny_compiler/parser'
require_relative 'super_tiny_compiler/transformer'
require_relative 'super_tiny_compiler/code_generator'

module SuperTinyCompiler
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
