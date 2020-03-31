# frozen_string_literal: true

module SuperTinyCompiler
  module SyntaxTree
    class Node
      attr_accessor :type, :value, :children

      def initialize(type, value = nil, children = [])
        @type = type
        @value = value
        @children = children
      end

      def add_child(child)
        @children << child
      end

      def to_tuple
        [@type, @value, *@children]
      end

      def eql?(other)
        type == other.type &&
          @children.eql?(other.children)
      end
    end

    class Transformer
      def initialize
      end

      def transform(node)
        msg = "transform_#{node.type}"
        if respond_to?(msg)
          send(msg, node.to_tuple)
        else
          node
        end
      end
    end
  end
end
