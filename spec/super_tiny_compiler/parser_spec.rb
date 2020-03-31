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
      program = AstNode.new(AstNode::PROGRAM)

      add_expression = AstNode.new(AstNode::CALL_EXPRESSION)
      add_expression.callee = 'add'
      add_expression.add_param(AstNode.new(AstNode::NUMBER_LITERAL, '2'))
      subtract_expression = AstNode.new(AstNode::CALL_EXPRESSION)
      subtract_expression.callee = 'subtract'
      subtract_expression.add_param(AstNode.new(AstNode::NUMBER_LITERAL, '4'))
      subtract_expression.add_param(AstNode.new(AstNode::NUMBER_LITERAL, '2'))
      add_expression.add_param(subtract_expression)

      program.add_to_body(add_expression)

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
