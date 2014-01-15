require 'redcarpet'
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true
activate :syntax, :line_numbers => true

Time.zone = "UTC"

page "/feed.xml", :layout => false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

require "lib/inline_svg"
helpers InlineSVG

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :cache_buster
  # activate :relative_assets
end



# Multiple Blogs
activate :blog do |blog|
  blog.name              = "blog"
  blog.layout            = "post"
  blog.permalink         = ":year/:month/:day/:title"
  blog.prefix            = "blog"
  #blog.tag_template      = "tag.html"
  #blog.taglink           = "tags/:tag.html"
  blog.summary_separator = /(READMORE)/
  # blog.summary_length    = 250
  # blog.per_page          = 5
  # blog.page_link         = "page/:num"
end

activate :blog do |blog|
  blog.name              = "work"
  blog.layout            = "post"
  blog.permalink         = ":title"
  blog.prefix            = "work"
  #blog.tag_template      = "tag.html"
end

activate :blog do |blog|
  blog.name              = "jobs"
  blog.layout            = "jobs"
  blog.permalink         = ":title"
  blog.prefix            = "jobs"
  #blog.tag_template      = "tag.html"
end

activate :directory_indexes
activate :gzip
