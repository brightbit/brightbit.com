Time.zone = "UTC"

activate :blog do |blog|
  blog.layout = "layouts/blog"
  blog.permalink = "blog-:year-:month-:day-:title.html"
  blog.taglink = "tags/:tag.html"
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.paginate = true
  # blog.per_page = 5
  # blog.page_link = "page/:num"
end

page "/feed.xml", :layout => false
page "blog/*", :layout => :blog

# page "/path/to/file.html", :layout => false
# page "/path/to/file.html", :layout => :otherlayout
# with_layout :admin do
#   page "/admin/*"
# end

# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :directory_indexes

configure :build do
  # activate :minify_css
  # activate :minify_javascript
  activate :cache_buster
  # activate :relative_assets
  require "middleman-smusher"
  activate :smusher
end
