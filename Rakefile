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
    ].map { |name| "spec/scuby/#{name}" }.join(' ')
    ENV['SPEC'] = "#{ENV['SPEC']} spec/scuby_spec.rb"
  end
rescue LoadError => ex
  puts ex.full_message
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:cop)
rescue LoadError => ex
  puts ex.full_message
end
