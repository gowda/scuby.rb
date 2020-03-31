# frozen_string_literal: true

module SuperTinyCompiler
  class AstNode
    PROGRAM = 'SuperTinyCompiler::AstNode::PROGRAM'
    CALL_EXPRESSION = 'SuperTinyCompiler::AstNode::CALL_EXPRESSION'
    NUMBER_LITERAL = 'SuperTinyCompiler::AstNode::NUMBER_LITERAL'
    STRING_LITERAL = 'SuperTinyCompiler::AstNode::STRING_LITERAL'
    NAME = 'SuperTinyCompiler::AstNode::NAME'
    EXPRESSION_STATEMENT = 'SuperTinyCompiler::AstNode::EXPRESSION_STATEMENT'
    IDENTIFIER = 'SuperTinyCompiler::AstNode::IDENTIFIER'

    attr_reader :type, :value, :params, :body

    def initialize(type, value = nil)
      @type = type
      @value = value
    end

    def params
      @params ||= []
    end

    def add_param(param)
      params << param
    end

    def body
      @body ||= []
    end

    def add_to_body(expression)
      body << expression
    end

    def eql?(other)
      type == other.type &&
        value.eql?(other.value) &&
        params.eql?(other.params) &&
        body.eql?(other.body)
    end

    attr_reader :expression

    attr_writer :expression

    attr_writer :context

    def context
      @context ||= []
    end

    def add_to_context(arg)
      context << arg
    end

    attr_reader :callee

    attr_writer :callee
  end
end
