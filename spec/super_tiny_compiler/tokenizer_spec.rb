# frozen_string_literal: true

require_relative '../../lib/super_tiny_compiler/tokenizer'

module SuperTinyCompiler
  class DummyTokenizerContainer
    include Tokenizer
  end

  describe 'Tokenizer' do
    let!(:input) { '(add 2 (subtract 4 2))' }
    let!(:tokens) do
      [
        Token.new(Token::PAREN, '('),
        Token.new(Token::NAME, 'add'),
        Token.new(Token::NUMBER, '2'),
        Token.new(Token::PAREN,  '('),
        Token.new(Token::NAME, 'subtract'),
        Token.new(Token::NUMBER, '4'),
        Token.new(Token::NUMBER, '2'),
        Token.new(Token::PAREN, ')'),
        Token.new(Token::PAREN, ')')
      ]
    end

    subject { DummyTokenizerContainer.tokenize(input) }

    describe '.tokenize' do
      it 'returns the list of tokens' do
        expect(subject).to eql(tokens)
      end
    end
  end
end
