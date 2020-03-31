# frozen_string_literal: true

require_relative 'token'
require_relative 'ast_node'

module SuperTinyCompiler
  module Parser
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def parse(tokens)
        ParseTree.new(tokens).ast
      end
    end

    class ParseTree
      def initialize(tokens)
        @tokens = tokens
        @ast = nil
      end

      def ast
        process! if @ast.nil?
        @ast
      end

      private

      def walk(start)
        current = start
        token = @tokens[current]

        case token.type
        when Token::NUMBER
          current += 1
          [AstNode.new(AstNode::NUMBER_LITERAL, token.value), current]
        when Token::STRING
          current += 1
          [AstNode.new(AstNode::STRING_LITERAL, token.value), current]
        when Token::PAREN
          if token.value == '('
            current += 1
            token = @tokens[current]

            node = AstNode.new(AstNode::CALL_EXPRESSION)
            node.callee = token.value

            current += 1
            token = @tokens[current]

            while (token.type != Token::PAREN) ||
                  (token.type == Token::PAREN && token.value != ')')
              param_node, current = walk(current)
              node.add_param(param_node)

              token = @tokens[current]
            end

            current += 1

            [node, current]
          else
            raise ArgumentError, "Unrecognized token: #{token[:type]}"
          end
        end
      end

      def process!
        @ast = AstNode.new(AstNode::PROGRAM)

        current = 0
        while current < @tokens.length
          node, current = walk(current)
          @ast.add_to_body(node)
        end
      end
    end
  end
end
