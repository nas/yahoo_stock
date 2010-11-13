require 'rubygems'

require 'cucumber'
require 'cucumber/rake/task'

desc 'Run Cucumber features and generate an HTML summary'
Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = ["--no-color",
                     "--format html -o log/features.html",
                     "--format progress"]
end

