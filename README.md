# MeiliSearch Elixir

![Tests](https://github.com/robottokauf3/meilisearch-elixir/workflows/Tests/badge.svg)

A lightweight [Meilisearch](https://docs.meilisearch.com/) client for Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `meilisearch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:meilisearch, "~> 0.20.0"}
  ]
end
```

## Usage

```elixir
# Create Index
Meilisearch.Indexes.create("index_name")

# Create Index and set primary key
Meilisearch.Indexes.create("index_name", primary_key: "key_name")

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
Meilisearch.Documents.add_or_replace("index_name", documents)

# Search
Meilisearch.Searches.search("water")
```

### Available Modules

- [X] Index
- [X] Health
- [X] Stats
- [X] Version
- [X] Documents
- [X] Search
- [X] Tasks
- [X] Keys
- [X] Settings
- [X] System Information

## Config

Client settings can be configured in your application config or with environment variables.

*Note: environment variables will override values in the application config.*

### Application Config

```elixir
config :meilisearch,
  endpoint: "http://127.0.0.1:7700",
  api_key: "test_api_key"
```

### Environment Variables

```shell
MEILISEARCH_ENDPOINT=http://localhost:7700 mix test
MEILISEARCH_API_KEY=test_api_key mix test
```

## Compatibility

The 0.20.X versions of this client have been tested against the following versions of Meilisearch:
  - v0.20.0
  - v0.19.0
  - v0.18.1
  - v0.17.0

## Development

You will need  Meilisearch running locally for development and testing.  You can do this via Docker:

```
$ docker run -it --rm -p 7700:7700 getmeili/meilisearch:latest ./meilisearch --master-key=test_api_key
```

## License

meilisearch-elixir is released under the MIT license. Please refer to [LICENSE](LICENSE) for details.
