# MeiliSearch Elixir

![Tests](https://github.com/robottokauf3/meilisearch-elixir/workflows/Tests/badge.svg)

A lightweight [Meilisearch](https://docs.meilisearch.com/) client for Elixir.

**Note: This is a work in progress and has not been published to hex.pm.  You probably shouldn't use it for production at this point.**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `meilisearch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:meilisearch, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
# Create Index
Meilisearch.Index.create("index_name")

# Create Index and set primary key
Meilisearch.Index.create("index_name", primary_key: "key_name")

# Insert documents
documents = [
  %{
    "id" => 1,
    "tagline" => "In space no one can hear you scream",
    "title" => "Alien"
  },
  %{
    "id" => 2,
    "tagline" => "You'll never go in the water again",
    "title" => "Jaws"
  },
  %{
    "id" => 3,
    "tagline" => "Be Afraid. Be very afraid.",
    "title" => "The Fly"
  }
]
Meilisearch.Document.add_or_replace("index_name", documents)

# Search
Meilisearch.Search.search("water")
```

### Available Modules

- [X] Index
- [X] Health
- [X] Stats
- [X] Version
- [X] Documents
- [X] Search
- [X] Updates
- [X] Keys
- [X] Settings
- [X] System Information

## Config

Setting endpoint and API key used by the library:

```elixir
config :meilisearch,
  endpoint: "http://127.0.0.1:7700",
  api_key: "test_api_key"
```

## Development

You will need  Meilisearch running locally for development and testing.  You can do this via Docker:

```
$ docker run -it --rm -p 7700:7700 getmeili/meilisearch:latest ./meilisearch --master-key=test_api_key
```

## License

meilisearch-elixir is released under the MIT license. Please refer to [LICENSE](LICENSE) for details.