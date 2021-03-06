# frozen_string_literal: true

require 'scuby'

describe Scuby do
  let!(:input) { file_fixture('input_source.lisp').read.strip }
  let!(:output) { file_fixture('output_source.c').read.strip }

  describe '.compile' do
    it 'returns compiled code' do
      expect(described_class.compile(input)).to eql(output)
    end
  end
end
