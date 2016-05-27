task :default => [:run]

require './bin/fetch-gems'

task :run do
  GemGetter.fetch
end

