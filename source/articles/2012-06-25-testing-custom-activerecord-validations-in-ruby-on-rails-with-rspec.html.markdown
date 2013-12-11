---
title: Testing Custom Validations in Ruby on Rails with RSpec
date: 2012-06-25
tags: Ruby on Rails, ActiveRecord, RSpec, Testing
author: Vance Lucas
---

Often on a project, you will have some custom business logic that
requires custom validations to be created. Rails has a great built-in
way to create custom validations with ease, but doesn't fully
document how to test the custom validators that you add so you can
ensure they are working properly. We recently did this on a client
project, and outlined the steps we took to do it.

This post will cover how to add a custom validation, how to translate
error message strings (including translating custom error message
strings), and how to test for the existence of your custom validation
error message with RSpec.

Add Your Custom Validator
-------------------------

This is the easy part. Add your custom validator like normal to the
model you want to put it on using the `validate` method.

<div class="code-title">models/booking.rb</div>
~~~ ruby
class Booking < ActiveRecord::Base
  belongs_to :listing

  validates_date :check_in, before: :check_out
  validate :listing_available?, if: :listing

  def listing_available?
    # Our actual logic in this case is on the related listing model
    if !listing.available?(check_in..check_out)
      # Add to :base when no specific single :field is applicable
      errors.add(:base, :not_available)
    end
  end
end
~~~

Note we are using the symbol `:not_available` instead of an actual error
message string. This is because the text of this error message will be
in the Rails locale file instead of hard-coded in the model. We are also
using the excellent
[validates_timeliness](https://github.com/adzap/validates_timeliness)
gem to get the `validates_date` method.

Add your Validation Message to the Locale File
----------------------------------------------

Your custom validation should be added to the locale file so that it can
be translated and is more resilient to wording changes (i.e. updating
the wording of the error message won't break your tests). If you're
just getting started with locales, this is located in
`config/locales/en.yml` by default (or you can create a new one for
your target language in the same location like `de.yml`).

Full locale example with YAML indentation for both errors above:

<div class="code-title">config/locales/en.yml</div>
~~~ yml
en:
  activerecord:
    errors:
      models:
        booking:
          attributes:
            base:
              not_available:  'Listing is not available for specified date range'
            check_in:
              before: 'must be before check out'
~~~

Accessing the Translation Strings in Your App
---------------------------------------------

To access the translation strings in your app and in your tests, use the
translate library provided by Rails: `I18n.t` (see the [Rails
Guide](http://guides.rubyonrails.org/i18n.html) for more info).

Expected locale error format:
`activerecord.errors.models.<MODEL>.attributes.<FIELD_OR_BASE>.<ERROR_KEY>`

Take note of the model name, field name, and key name where you are
adding your custom validators, because you will need all of them when
accessing your error message string for testing.

### Examples

Booking model error on `base` (validates multiple fields):
`I18n.t('activerecord.errors.models.booking.attributes.base.not_available')`

Booking model error on `check_in` (one specific field):
`I18n.t('activerecord.errors.models.booking.attributes.check_in.before')`


Ensure the Validation Exists with RSpec
---------------------------------------

Now we need to make a test to ensure that our new custom validation is
working properly. We use [RSpec](https://github.com/rspec/rspec-rails) for writing & running tests, and
[FactoryGirl](https://github.com/thoughtbot/factory_girl) for creating our test objects, which are both available as gems.

<div class="code-title">sepc/models/booking_spec.rb</div>
~~~ ruby
describe "my custom validation"
  it "will not create a booking that overlaps another accepted booking in date range" do
    # We have previously setup a booking in this date range in our test fixtures, so this will error
    booking = FactoryGirl.build(:booking)
    booking.check_in  = Date.today - 2
    booking.check_out = Date.today

    booking.valid? # trigger validation to run (without saving)
    booking.errors[:base].should include I18n.t('activerecord.errors.models.booking.attributes.base.not_available')
  end
end
~~~

Run Your RSpec Tests
--------------------

Now we can run the tests to ensure everything is working and that our
validator is doing its job (or not). In practice, you will want to
ensure the test fails by writing it first and verifying a failing test
run result. You then write the code the makes the test pass, and re-run
the tests to ensure it passes.

We use [Guard](https://github.com/guard/guard) on all our Rails projects
so that our tests are automatically run after any filesystem changes. It
can be easily integrated into your Rails project by adding it to your
Gemfile. Check out the [Guard
RailsCast](http://railscasts.com/episodes/264-guard) by [Ryan Bates](http://twitter.com/rbates) if you want to learn
more about how to use Guard with RSpec and Rails.


