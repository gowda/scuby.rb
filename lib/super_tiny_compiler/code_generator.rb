# frozen_string_literal: true

require_relative 'syntax_tree'

module SuperTinyCompiler
  module CodeGenerator
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def generate_code(ast)
        RubyCodeGeneratorTransformer.new.transform(ast)
      end
    end

    class RubyCodeGeneratorTransformer < SyntaxTree::Transformer
      def transform_program(args)
        _, _, *statements = args
        statements.map { |statement| transform statement }.join('\n')
      end

      def transform_expression_statement(args)
        _, _, expression = args
        "#{transform expression};"
      end

      def transform_call_expression(args)
        _, callee, *params = args
        "#{callee}(#{params.map { |param| transform param }.join(',')})"
      end

      def transform_number_literal(args)
        _, value, = args
        value
      end

      def transform_string_literal(args)
        _, value, = args
        "\"#{value}\""
      end
    end
  end
end
