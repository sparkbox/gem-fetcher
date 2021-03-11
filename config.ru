require './bin/fetch-gems'
require 'rack/rewrite'

use Rack::Rewrite do

  def is_a_review_app?(rack_env)
    rack_env['SERVER_NAME'].end_with? 'herokuapp.com'
  end

  def is_local?(rack_env)
    rack_env['SERVER_NAME'].end_with? 'localhost'
  end

  r301 %r{.*}, 'https://gems.sparkbox.com/', :scheme => 'http'

  r301 %r{.*}, 'https://gems.sparkbox.com$&', :if => Proc.new {|rack_env|
    rack_env['SERVER_NAME'] != 'gems.sparkbox.com' &&
      !is_a_review_app?(rack_env) &&
      !is_local?(rack_env)
  }
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
