# frozen_string_literal: true

require 'super_tiny_compiler/tokenizer'
require 'super_tiny_compiler/parser'

module SuperTinyCompiler
  class DummyParserContainer
    include Parser
  end

  describe 'Parser' do
    let!(:tokens) do
      [
        Token.new(Token::PAREN, '('),
        Token.new(Token::NAME, 'add'),
        Token.new(Token::NUMBER, '2'),
        Token.new(Token::PAREN,  '('),
        Token.new(Token::NAME, 'subtract'),
        Token.new(Token::NUMBER, '4'),
        Token.new(Token::NUMBER, '2'),
        Token.new(Token::PAREN, ')'),
        Token.new(Token::PAREN, ')')
      ]
    end
    let!(:ast) do
      program = SyntaxTree::Node.new(:program)

      add_expression = SyntaxTree::Node.new(:call_expression, 'add')
      add_expression.add_child(SyntaxTree::Node.new(:number_literal, '2'))
      subtract_expression = SyntaxTree::Node.new(:call_expression, 'subtract')
      subtract_expression.add_child(SyntaxTree::Node.new(:number_literal, '4'))
      subtract_expression.add_child(SyntaxTree::Node.new(:number_literal, '2'))
      add_expression.add_child(subtract_expression)

      program.add_child(add_expression)

      program
    end

    subject { DummyParserContainer.parse(tokens) }

    describe '.parse' do
      it 'returns the AST representation of tokens' do
        expect(subject).to eql(ast)
      end
    end
  end
end
