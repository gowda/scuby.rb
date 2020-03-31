# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |_task|
    ENV['SPEC'] = %w[
      tokenizer_spec.rb
      parser_spec.rb
      transformer_spec.rb
      code_generator_spec.rb
    ].map { |name| "spec/super_tiny_compiler/#{name}" }.join(' ')
    ENV['SPEC'] = "#{ENV['SPEC']} spec/super_tiny_compiler_spec.rb"
  end
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:cop)
rescue LoadError
end
