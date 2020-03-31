# frozen_string_literal: true

require 'super_tiny_compiler/transformer'

module SuperTinyCompiler
  class DummyTransformerContainer
    include Transformer
  end

  describe 'Transformer' do
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
    let!(:new_ast) do
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

    subject { DummyTransformerContainer.transform(ast) }

    describe '.transform' do
      it 'returns the AST representation of tokens' do
        expect(subject).to eql(new_ast)
      end
    end
  end
end
