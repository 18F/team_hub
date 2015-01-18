require 'bundler/gem_tasks'
require 'rake/testtask'
require 'test_temp_file_helper/rake'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*test.rb']
end

TestTempFileHelper::SetupTestEnvironmentTask.new do |t|
  t.base_dir = File.dirname __FILE__
  t.tmp_dir = File.join 'test', 'tmp'
end

desc "Run TeamHub tests"
task :default => :test
