# frozen_string_literal: true

require_relative '../../lib/super_tiny_compiler/code_generator'

module SuperTinyCompiler
  class DummyCodeGeneratorContainer
    include CodeGenerator
  end

  describe 'CodeGenerator' do
    let!(:ast) do
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
    let!(:output) { 'add(2,subtract(4,2));' }

    subject { DummyCodeGeneratorContainer.generate_code(ast) }

    describe '.generate_code' do
      it 'returns the C code' do
        expect(subject).to eql(output)
      end
    end
  end
end
