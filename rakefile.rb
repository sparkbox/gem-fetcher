task :default => [:run]

require './bin/fetch-gems'

task :run do
  puts "running fetch"
  GemGetter.fetch
end

