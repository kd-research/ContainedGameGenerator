# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[test rubocop]

task :protoc do
  sh "grpc_tools_ruby_protoc --ruby_out=lib --grpc_out=lib proto/*.proto"
  generated_files = Dir.glob("lib/proto/*_pb.rb")
  unless generated_files.empty?
    system("bundle exec rubocop -A --fail-level=E #{generated_files.join(' ')}", exception: true)
  end
end

task docker_build: :protoc do
  sh "docker build -t grpc-ruby-server ."
end
