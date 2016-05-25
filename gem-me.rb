require 'json'
file = File.read('gems.json')
data = JSON.parse(file)

random_max = data.count

prng = Random.new
puts data[prng.rand(random_max)]
