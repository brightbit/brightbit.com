require 'redcarpet'
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true
activate :syntax, :line_numbers => true

Time.zone = "UTC"

page "/feed.xml", :layout => false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :directory_indexes

require "lib/inline_svg"
helpers InlineSVG

configure :build do
  # activate :minify_css
  # activate :minify_javascript
  activate :cache_buster
  # activate :relative_assets
  require "middleman-smusher"
  activate :smusher
end



# Multiple Blogs
activate :blog do |blog|
  blog.name              = "news"
  blog.layout            = "post"
  blog.permalink         = ":year-:month-:day-:title.html"
  blog.prefix            = "news"
  blog.tag_template      = "tag.html"
  blog.taglink           = "tags/:tag.html"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length    = 250
  # blog.per_page          = 5
  # blog.page_link         = "page/:num"
end

activate :blog do |blog|
  blog.name              = "articles"
  blog.layout            = "post"
  blog.permalink         = ":year-:month-:day-:title.html"
  blog.prefix            = "articles"
  blog.tag_template      = "tag.html"
end
