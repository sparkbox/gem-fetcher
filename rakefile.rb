task :default => [:run]

task :run do
    ruby "bin/fetch-gems.rb"
end

