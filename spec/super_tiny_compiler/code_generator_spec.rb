# frozen_string_literal: true

require 'super_tiny_compiler/code_generator'

module SuperTinyCompiler
  class DummyCodeGeneratorContainer
    include CodeGenerator
  end

  describe 'CodeGenerator' do
    let!(:ast) do
      program = SyntaxTree::Node.new(SyntaxTree::Node::PROGRAM)

      expression_statement = SyntaxTree::Node.new(SyntaxTree::Node::EXPRESSION_STATEMENT)
      add_expression = SyntaxTree::Node.new(SyntaxTree::Node::CALL_EXPRESSION, 'add')
      add_expression.add_child(SyntaxTree::Node.new(SyntaxTree::Node::NUMBER_LITERAL, '2'))
      subtract_expression = SyntaxTree::Node.new(SyntaxTree::Node::CALL_EXPRESSION, 'subtract')
      subtract_expression.add_child(SyntaxTree::Node.new(SyntaxTree::Node::NUMBER_LITERAL, '4'))
      subtract_expression.add_child(SyntaxTree::Node.new(SyntaxTree::Node::NUMBER_LITERAL, '2'))
      add_expression.add_child(subtract_expression)
      expression_statement.add_child(add_expression)

      program.add_child(expression_statement)

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
