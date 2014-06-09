dl-api ruby client
===

Getting started:

```ruby
# Gemfile
gem 'dl-api'
```

Basic usage:

```ruby
client = DL::Client(:app_id => 1, :key => "something", :endpoint => "https://dl-api.heroku.com")
client.collection(:posts).create(:title => "Getting Started", :description => "Getting started with dl-api-ruby.")
puts client.collection(:posts).where(:title => "Getting Started").count
```

For more examples, please see [our tests](spec).

Using it with Rails
===

Set-up with your credentials:

```ruby
DL::Client.configure(
  :app_id => 1,
  :key => "1f143fde82d14643099ae45e6c98c8e1",
  :endpoint => "https://dl-api.heroku.com"u
)
```

Define your models:

```ruby
class Post
  include DL::Model

  field :title
  field :description

  validates_presence_of :title
end
```

DL::Model's uses almost the same syntax as ActiveRecord, which you're already
familiar with.

You will be able to use any
[ActiveModel](https://github.com/rails/rails/tree/master/activemodel) goodies,
such as validation, serialization and dirty methods.
