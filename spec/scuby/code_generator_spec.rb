# frozen_string_literal: true

require 'scuby/code_generator'

module Scuby
  class DummyCodeGeneratorContainer
    include CodeGenerator
  end

  describe 'CodeGenerator' do
    let!(:ast) do
      program = SyntaxTree::Node.new(:program)

      expression_statement = SyntaxTree::Node.new(:expression_statement)
      add_expression = SyntaxTree::Node.new(:call_expression, 'add')
      add_expression.add_child(SyntaxTree::Node.new(:number_literal, '2'))
      subtract_expression = SyntaxTree::Node.new(:call_expression, 'subtract')
      subtract_expression.add_child(SyntaxTree::Node.new(:number_literal, '4'))
      subtract_expression.add_child(SyntaxTree::Node.new(:number_literal, '2'))
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
