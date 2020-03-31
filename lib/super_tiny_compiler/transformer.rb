# frozen_string_literal: true

require_relative 'token'
require_relative 'ast_node'

module SuperTinyCompiler
  module Visitor
    def self.enter(node, parent)
      case node.type
      when AstNode::NUMBER_LITERAL
        parent.add_to_context AstNode.new(AstNode::NUMBER_LITERAL, node.value)
      when AstNode::STRING_LITERAL
        parent.add_to_context AstNode.new(AstNode::STRING_LITERAL, node.value)
      when AstNode::CALL_EXPRESSION
        expression = AstNode.new(AstNode::CALL_EXPRESSION)
        expression.callee = node.callee
        node.context = expression.params

        if parent.type != AstNode::CALL_EXPRESSION
          expression_statement = AstNode.new(AstNode::EXPRESSION_STATEMENT)
          expression_statement.expression = expression

          expression = expression_statement
        end

        parent.add_to_context expression
      end
    end

    def self.exit(node, parent); end
  end

  module Transformer
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def transform(ast)
        TransformerTree.new(ast).ast
      end
    end

    class TransformerTree
      attr_reader :input

      def initialize(input)
        @input = input
        @ast = nil
      end

      def ast
        process! if @ast.nil?
        @ast
      end

      private

      def process!
        new_ast = AstNode.new(AstNode::PROGRAM)

        input.context = new_ast.body

        traverse

        @ast = new_ast
      end

      def traverse
        traverse_node(input, nil)
      end

      def traverse_array(array, parent)
        array.each do |node|
          traverse_node(node, parent)
        end
      end

      def traverse_node(node, parent)
        Visitor.enter(node, parent)

        case node.type
        when AstNode::PROGRAM
          traverse_array(node.body, node)
        when AstNode::CALL_EXPRESSION
          traverse_array(node.params, node)
        when AstNode::NUMBER_LITERAL, AstNode::STRING_LITERAL # rubocop:disable Lint/EmptyWhen
          # no-op: do nothing
        else
          raise ArgumentError, "Unrecognized syntax node #{node.type}"
        end

        Visitor.exit(node, parent)
      end
    end
  end
end
