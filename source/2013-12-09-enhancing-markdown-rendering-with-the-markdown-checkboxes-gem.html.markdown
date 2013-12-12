---
title: Enhancing Markdown Rendering with the markdown_checkboxes Gem
date: 2013-12-09
tags: Ruby on Rails, RubyGems, Markdown, Checkbox
---

You might have heard of Markdown before; you know, the hip way
to parse plain text build fancy text complete with styled html elements.
You might even have implemented [Markdown](http://en.wikipedia.org/wiki/Markdown) rendering for some of your web applications,
and that's awesome if you have. But there's one wonderful feature
that's missing from the standard markdown rendering algorithm that can make it
so much more powerful: checkbox rendering.

How would you like to be able to easily build an html checkbox
through parsing markdown, merely by including `-[ ]` or `-[x]`
in your text content? A checkbox that will automatically update your server-side data field every time it's changed?
[Github](https://github.com/) does it in their issue bodies and comments, and now you can too with the
[markdown_checkboxes](http://rubygems.org/gems/markdown_checkboxes) gem.

Check it out:

Markdown 101
------------
Are you building a blog, social media outlet, or any other type of
collaborative tool where you want to allow your users to use rich media
when entering into a text field? Processes that come to mind here are making
posts, adding comments, creating issues or tickets of any kind, etc.

Sure, as a developer you can add functionality for the bulky suite of buttons for
bold, italics, underline, centering, justification,
bullets, numbered lists...you see where I'm going with this. Or you could consider
implementing [Markdown](http://en.wikipedia.org/wiki/Markdown), a very lightweight
text syntax that converts very simple plain text into fancy html code.
Your users don't have to know a bit of html to make their text look organized and beautiful.
There are so many markdown parsers out there already too, so you should hardly have
to code a thing!

Markdown is slick, but ordered and unordered lists can only get you so far if you need
a to-do list type field, or want to provide collaboration for something like an issue or service ticket.
That's why we saw the chance to add some sweet checkbox parsing capabilities into this already sweet text parser.

Adding Checkboxes to the Mix
-------------------------

*Prerequisuites*: Currently, this has only been tested and approved for ruby web applications
specifically using the Rails framework.

Before we begin detailing the implementation process, here's a screenshot of what your
markdown could look like after implementing markdown_checkboxes:

(enter picture here)

To get started, first install the gem:

```bash
gem install markdown_checkboxes
```

The gem comes with 2 dependencies (both of which are automatically installed):
* [Redcarpet](https://github.com/vmg/redcarpet) - The markdown parser we use and build upon
* [Actionpack](https://github.com/rails/rails/tree/master/actionpack) - Used to help build the html checkboxes

Now, let's open up a sample file and build our bare-bones renderer:

{% codeblock lib/markdown_test.rb %}
require 'markdown_checkboxes'

class MarkdownHelper
  MARKDOWN = CheckboxMarkdown.new(Redcarpet::Render::HTML.new())
end
{% endcodeblock %}

The CheckboxMarkdown class inherits directly from Redcarpet::Markdown, and therefore you can pass
in any of the options on Redcarpet's [readme](https://github.com/vmg/redcarpet) page. This is enough
to get us started though, so let's keep going.

Why don't we add some text that we want our markdown renderer to parse and display:

{% codeblock lib/markdown_test.rb %}
require 'markdown_checkboxes'

class MarkdownHelper
  MARKDOWN = CheckboxMarkdown.new(Redcarpet::Render::HTML.new())

  def sample_text
<<- SAMPLE_TEXT
  # This will be an h1
  ### Here's an h2
  *italicized text*
  `code block`
  - [ ] unchecked checkbox
  - [x] checked checkbox
SAMPLE_TEXT
end

  Markdown.render(sample_text).html_safe
end
{% endcodeblock %}

To build our sample text, we use a [ruby heredoc](http://rubyquicktips.com/post/4438542511/heredoc-and-indent) to
buid a clean multi-line string. This text will get fully rendered out as beautiful html in a web browser, but you'll
notice something...the checkboxes are there, but they don't work. You're right, you can click them all day long,
but your text isn't getting updated at all. Let's figure out why.

The Checkbox Dilemma
--------------------

Adding easy-to-build checkboxes is an awesome addition to your site for users to enjoy, but let's take
a moment to exam what has to happen for your checkboxes to work as expected. Your users are operating
on the client side, and as soon as they check a checkbox, a server request has to instantaneously be made
in order to update that data field, and in your request you have include exactly which checkbox to update
in your data field. In Rails, this hits the update action of your controller and follows through the whole
suite of building a response just as if your user had submitted a form for updating.
You might even go as far as to have some unobtrusive javascript execute after the update action fires.

But plain and simple, a lot more is going on than you probably think when you're clicking that checkbox
on your page. Markdown is simply meant to parse text; it doesn't need to get tangled up in a server/client
relationship, so that's where [markdown_checkboxes](http://rubygems.org/gems/markdown_checkboxes) come in.

Putting it All Together
-----------------------

In order to get those checkboxes above working properly, you need to pass in a little extra
data to the CheckboxMarkdown#render method:

{% codeblock lib/markdown_test.rb %}
require 'markdown_checkboxes'

class MarkdownHelper
  MARKDOWN = CheckboxMarkdown.new(Redcarpet::Render::HTML.new())

  def sample_text
<<- SAMPLE_TEXT
  # This will be an h1
  ### Here's an h2
  *italicized text*
  `code block`
  - [ ] unchecked checkbox
  - [x] checked checkbox
SAMPLE_TEXT
end

  Markdown.render(sample_text) do |data, updated_text|
    data.method = :put
    data.remote = true
    data.url    = post_path(@post, post: { body: updated_text })
  end.html_safe
end
{% endcodeblock %}


That doesn't look so bad, does it? The checkbox_markdown gem ships with its own DSL
to make including the necessary data super easy. You just have to add a block
onto the render method, and use the DSL to add whatever config you want. The `data`
parameter is a simple object that you can assign any value to. All values you set
on `data` will convert to "data-<value>" attributes in the html for each checkbox. For example:

```ruby
data.method = :put
```

will turn into a "data-method='put'" attribute on the checkbox.

Now let's examine what's going on here:

We're setting the method property to `:put` to signify that
we're sending a put request to the server, which will then hit the update action. We're also setting the
remote property to `true` to signify that we have some javascript that we want to fire after our
controller finishes (this is an optional value). And lastly, we're setting the url option to point
to a certain path. This path is the route for a Post object, and we're passing with it the hash of updated
attributes, and assigning our `updated_text` parameter to the `body` field.

Assigning `method` and `url` properties to the `data` parameter are the only required values,
since you want to tell Rails which controller to hit, as well as a url with the updated attributes.

Using a @post object with a body field is solely for this tutorial; you'll want to replace that with your
actual object and data field. Now these checkboxes are fully loaded, and will send a proper server-side
request to update the necessary field. Good work!

Now go forth and easily allow the building of simple and collaborative checkbox task-lists and other checkbox use-cases
in your Rails web applications!
