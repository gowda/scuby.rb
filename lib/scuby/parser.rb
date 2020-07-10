# frozen_string_literal: true

require_relative 'token'
require_relative 'syntax_tree'

module Scuby
  module Parser
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def parse(tokens)
        LispParser.new(tokens).parse
      end
    end

    class LispParser
      attr_reader :tokens, :current_position

      def initialize(tokens)
        @tokens = tokens
        @current_position = 0
      end

      def parse
        ast = SyntaxTree::Node.new(:program)
        ast.add_child(current_node) while token?
        ast
      end

      private

      def token?
        @current_position < @tokens.length
      end

      def current_token
        @tokens[current_position]
      end

      def current_token_and_inc_pointer
        inc_pointer
        @tokens[current_position - 1]
      end

      def inc_pointer
        @current_position += 1
      end

      def current_node
        process_next_node
      end

      def process_next_node
        msg = "process_next_node_from_#{current_token.type}"

        # https://ruby-doc.org/core-2.6.3/Object.html#method-i-respond_to-3F
        unless respond_to?(msg, true)
          raise "Unrecognized token #{current_token.value}"
        end

        send(msg)
      end

      def process_next_node_from_number
        token = current_token_and_inc_pointer
        SyntaxTree::Node.new(:number_literal, token.value)
      end

      def process_next_node_from_string
        token = current_token_and_inc_pointer
        SyntaxTree::Node.new(:string_literal, token.value)
      end

      def not_closing_paren?(token)
        (token.type != :paren) ||
          (token.type == :paren && token.value != ')')
      end

      def process_next_node_from_paren
        inc_pointer
        node = SyntaxTree::Node.new(:call_expression, current_token.value)
        inc_pointer

        while token? && not_closing_paren?(current_token)
          node.add_child(process_next_node)
        end

        inc_pointer

        node
      end
    end
  end
end
