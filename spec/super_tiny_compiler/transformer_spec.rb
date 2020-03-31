# frozen_string_literal: true

require_relative '../../lib/super_tiny_compiler/transformer'

module SuperTinyCompiler
  class DummyTransformerContainer
    include Transformer
  end

  describe 'Transformer' do
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
    let!(:new_ast) do
      program = AstNode.new(AstNode::PROGRAM)

      expression_statement = AstNode.new(AstNode::EXPRESSION_STATEMENT)
      add_expression = AstNode.new(AstNode::CALL_EXPRESSION)
      add_expression.callee = 'add'
      add_expression.add_param(AstNode.new(AstNode::NUMBER_LITERAL, '2'))
      subtract_expression = AstNode.new(AstNode::CALL_EXPRESSION)
      subtract_expression.callee = 'subtract'
      subtract_expression.add_param(AstNode.new(AstNode::NUMBER_LITERAL, '4'))
      subtract_expression.add_param(AstNode.new(AstNode::NUMBER_LITERAL, '2'))
      add_expression.add_param(subtract_expression)
      expression_statement.expression = add_expression

      program.add_to_body(expression_statement)

      program
    end

    subject { DummyTransformerContainer.transform(ast) }

    describe '.transform' do
      it 'returns the AST representation of tokens' do
        expect(subject).to eql(new_ast)
      end
    end
  end
end
