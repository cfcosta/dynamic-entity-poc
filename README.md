# Dynamic Entity Proof-of-Concept

This project is a proof of concept on rendering data dynamically, so that
different types of servers with hawkular agents can be seen on ManageIQ without
having to extend the codebase.

To do that, we have a hierarchy of views, and those views act on entities. We
are going to get deeper on what both entities and views behave.

## Entities

Entities are pure Ruby objects, that inherit from `Entity` and implement to
`.applicable?`. `.applicable?` is a method that defines a condition which
incoming data should match.

For this Proof of Concept, the only entity implemented is `WildFlyServer`,
which follows the following hyerarchy:

            * Entity
              * MiddlewareServer
                * WildFlyServer

`Entity` defines attribute methods, and keeps a registry of all entities in the
system. The registry can be used to get an entity from received metadata, like this:

```ruby
class Simple < Entity
  register self, weight: 10
  attribute :foo

  def self.applicable?(data)
    data[:foo] == :bar
  end
end

class Other < Entity
  register self, weight: 10
  attribute :foo

  def self.applicable?(data)
    data[:foo] == :baz
  end
end

class LowerPriority < Entity
  register self, weight: 0
  attribute :foo

  def self.applicable?(data)
    data[:foo] == :baz
  end
end

Entity.constantize(foo: :bar) #=> Simple.new(foo: :bar)
Entity.constantize(foo: :baz) #=> Other.new(foo: :baz)
```

`.register` takes two attributes, one of them is the class to be registered,
and a `weight` param, that defines how much priority an entity has on the
registry. This is meant so that more specialized entities will be tried first,
before less specialized ones.

Entities also define the `.attribute` method, which generates accessors.

## Views

Views receive an entity with the same name (`WildflyServer`'s view is
`WildflyServerView`, i.e.) and renders an arbritrary json defined by a DSL. It
can also generate schemas for the provided data, but that's not implemented
yet.

There are many examples of Views on `spec/lib/view_spec.rb`, with the generated
json data on the tests themselves.

Views can also be subclassed, and `View.for` searches for parent classes when
searching for the most applicable view for the entity. So, let's say we have an
entity `EAPServer`, which inherits from `MiddlewareServer`,  so doing
`View.for(eap_server)` will first try to find a `EAPServerView`, then
`MiddlewareServerView`.

While views are meant to be used with Entities, it does not depend in them in
any way, so normal objects can be used, as long as you instantiate the view
directly.

On Rails, views can also be rendered directly, like this:

```ruby
class MyController < ApplicationController
  def foo
    render json: View.constantize(Foo.new(foo: :bar))
  end
end
```

You can also send a list of entities, and it will be rendered recursively by Rails.
