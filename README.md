# SnowhiteTemplate

This template a fresh start to use the [Snowhite smart mirror](https://github.com/nicklayb/snowhite) project.

## Getting started

Clone it this template to get a fresh Snowhite template, this is the easiest way to get started.

### Rename

Default project is namespaced under `SnowhiteTemplate`. If you want to rename it, there is a handy mix task that can help you:

```elixir
mix rename MyNewModule
```

**Note**: Make sure to sure a module casing (pascal case) when specifying the new name. (**bad**: `some_new_name`, **good**: `SomeNewName`)

### Customizing

Start customizing by updating the default profile or creating new profiles. See [Snowhite's doc](https://hexdocs.pm/snowhite) for more info.

## Starting dev environment

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
