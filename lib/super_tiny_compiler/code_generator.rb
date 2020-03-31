# frozen_string_literal: true

require_relative 'ast_node'

module SuperTinyCompiler
  module CodeGenerator
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def generate_code(ast)
        dump_node(ast)
      end

      def dump_node(node)
        case node.type
        when AstNode::PROGRAM
          node.body.map { |child| dump_node(child) }.join('\n')
        when AstNode::EXPRESSION_STATEMENT
          "#{dump_node(node.expression)};"
        when AstNode::CALL_EXPRESSION
          "#{node.callee}(#{node.params.map { |child| dump_node(child) }.join(',')})"
        when AstNode::IDENTIFIER
          node.value
        when AstNode::NUMBER_LITERAL
          node.value
        when AstNode::STRING_LITERAL
          "\"#{node.value}\""
        else
          raise ArgumentError, "Unrecognized node in syntax tree: #{node[:type]}"
        end
      end
    end
  end
end
