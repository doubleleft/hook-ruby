hook-ruby client
===

ruby client for [hook](github.com/doubleleft/hook/). [API Reference](doubleleft.github.io/hook-ruby).

Getting started:
---

```ruby
# Gemfile
gem 'hook-client'
```

Basic usage:

```ruby
require 'hook-client'
client = Hook::Client(:app_id => 1, :key => "something", :endpoint => "https://dl-api.heroku.com")
client.collection(:posts).create(:title => "Getting Started", :description => "Getting started with dl-api-ruby.")
puts client.collection(:posts).where(:title => "Getting Started").count
```

For more examples, please see [our tests](spec).

Using it with Rails
===

Set-up with your credentials:

```ruby
Hook::Client.configure(
  :app_id => 1,
  :key => "1f143fde82d14643099ae45e6c98c8e1",
  :endpoint => "https://dl-api.heroku.com"
)
```

Define your models:

```ruby
class Post
  include Hook::Model

  field :title
  field :description

  validates_presence_of :title
end
```

Hook::Model's uses almost the same syntax as ActiveRecord, which you're already
familiar with.

You will be able to use any
[ActiveModel](https://github.com/rails/rails/tree/master/activemodel) goodies,
such as validation, serialization and dirty methods.

License
---

MIT
