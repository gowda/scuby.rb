# frozen_string_literal: true

require_relative 'token'
require_relative 'syntax_tree'

module SuperTinyCompiler
  module Transformer
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def transform(ast)
        LispToRubyTransformer.new.transform(ast)
      end
    end

    class LispToRubyTransformer < SyntaxTree::Transformer
      def transform_program(args)
        _, _, *statements = args

        transformed_statements = statements.map do |statement|
          transformed_statement = transform statement
          if call_expression?(transformed_statement)
            wrap_in_expression_statement(transformed_statement)
          end
        end

        SyntaxTree::Node.new(:program, nil, transformed_statements)
      end

      def transform_call_expression(args)
        _, callee, *params = args

        SyntaxTree::Node.new(
          :call_expression,
          callee,
          params.map { |param| transform param }
        )
      end

      private

      def call_expression?(node)
        node.type == :call_expression
      end

      def wrap_in_expression_statement(node)
        SyntaxTree::Node.new(:expression_statement, nil, [node])
      end
    end
  end
end
