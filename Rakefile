begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fabulator-grammar"
    gem.summary = %Q{Grammar extension to Fabulator.}
    gem.description = %Q{The grammar Fabulator extension provides regular expression support.}
    gem.email = "jgsmith@tamu.edu"
    gem.homepage = "http://github.com/jgsmith/ruby-fabulator-grammar"
    gem.authors = ["James Smith"]
    gem.add_dependency(%q<fabulator>, [">= 0.0.1"]) 
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. This is only required if you plan to package fabulator-exhibit as a gem."
end

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'

require 'cucumber'
require 'cucumber/rake/task'

task :features => 'spec:integration'

namespace :spec do
  
  desc "Run the Cucumber features"
  Cucumber::Rake::Task.new(:integration) do |t|
    t.fork = true
    t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]
    # t.feature_pattern = "#{extension_root}/features/**/*.feature"
    t.profile = "default"
  end

end

namespace :update do
  desc "update the manifest"
  task :manifest do
    system %q[touch Manifest.txt; rake check_manifest | grep -v "(in " | patch]
  end
end

desc 'Generate documentation for the fabulator exhibit extension.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Fabulator'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# For extensions that are in transition
desc 'Test the fabulator exhibit extension.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

# Load any custom rakefiles for extension
Dir[File.dirname(__FILE__) + '/tasks/*.rake'].sort.each { |f| require f }
