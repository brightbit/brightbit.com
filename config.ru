# require 'rack/contrib'
# encoding: utf-8

require File.expand_path("../rack_try_static", __FILE__)

use Rack::ContentType

use Rack::Deflater

# use Rack::StaticCache, urls: ["/images", "/stylesheets", "/javascripts", "/fonts"], root: "build"

use ::Rack::TryStatic,
  :root => "build",
  :urls => ["/"],
  :try  => [".html", "index.html", "/index.html"]

run lambda { [404, {"Content-Type" => "text/plain"}, ["File not found!"]] }
