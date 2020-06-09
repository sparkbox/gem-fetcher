require './bin/fetch-gems'
require 'rack/rewrite'

use Rack::Rewrite do
  r301 %r{.*}, 'https://localhost:9292', :scheme => 'http'
end

use Rack::Static,
  :urls => ["/images", "/js", "/css", "/data"],
  :root => "public"

run lambda { |env|
  GemGetter.fetch
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('public/index.html', File::RDONLY)
  ]
}
