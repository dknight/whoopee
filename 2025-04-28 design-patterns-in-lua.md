<!-- Description: List of 22 classical design patterns implemented in Lua programming languages. Learn design patterns in Lua. -->

tags: lua design-patterns

# Design patterns in Lua

Design patterns are common ways to solve problems that come up often in software development.
They are like blueprints/guides you can adjust to fit specific challenges and common tasks in the code.

There are advocates of the design patterns and opponents of them. Here I wittingly skip the discussion
about the advantages and disadvantagesЛ of design patterns. But these patterns are really useful to solve
common problems in software development, especially when you are working in groups.

!!! tip
    Use design patterns to solve real-world problems, do not adapt your code to the problem.

Lua is not an exception language, and all 22 classic design patterns can be implemented in Lua with
the help of [classes and object-oriented programming](/post/object-oriented-programming-in-lua.html).
There might be, in some cases, classes are overkill, but they are a good way to organize the code and show better
examples of how to use object-oriented programming in Lua. Any pattern can be implemented in Lua, using functions,
tables, and metatables.

Usually there are three categories of design patterns:

- **Creational patterns** provide object creation mechanisms that increase the flexibility and
  reuse of existing code.
- **Structural patterns** explain how to assemble objects and classes into larger structures, while keeping these structures flexible and efficient.
- **Behavioral patterns** take care of effective communication and the assignment of responsibilities between objects.

## Creational design patterns

- [Factory Method](/post/design-pattern-factory-method.html)
- [Abstract factory](/post/design-pattern-abstract-factory.html)
- [Builder](/post/design-pattern-builder.html)
- [Prototype](/post/design-pattern-prototype.html)
- [Singleton](/post/design-pattern-singleton.html)

## Structural design patterns

- [Adapter](/post/design-pattern-adapter.html)
- [Bridge](/post/design-pattern-bridge.html)
- [Composite](/post/design-pattern-composite.html)
- [Decorator](/post/design-pattern-decorator.html)
- [Facade](/post/design-pattern-facade.html)
- [Flyweight](/post/design-pattern-flyweight.html)
- [Proxy](/post/design-pattern-proxy.html)

## Behavioral design patterns

- [Chain of responsibility](/post/design-pattern-chain-of-responsibility.html)
- [Command](/post/design-pattern-command.html)
- [Iterator](/post/design-pattern-iterator.html)
- [Mediator](/post/design-pattern-mediator.html)
- [Memento](/post/design-pattern-memento.html)
- [Observer](/post/design-pattern-observer.html)
- [State](/post/design-pattern-state.html)
- [Strategy](/post/design-pattern-strategy.html)
- [Template method](/post/design-pattern-template-method.html)
- [Visitor](/post/design-pattern-visitor.html)

## References

- [Refactoring Guru: Design patterns](https://refactoring.guru/design-patterns/)
