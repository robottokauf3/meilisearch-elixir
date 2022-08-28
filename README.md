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

### Async Tasks

Meilisearch enqueues most of the commands you execute. 

Because of this, it might at times be necessary to "wait" until Meilisearch 
has finished processing the given task before you can perform further operations.

For example, when adding `Documents`, the return object is:
```elixir
{:ok, %{
    "taskUid" => 1,
    "indexUid" => "movies",
    "status" => "enqueued",
    "type" => "documentAdditionOrUpdate",
    "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
}}
```

In order to block your program while you wait for the resolution of this enqueued
task, you can use the `Tasks.await_result/2` method, which will continue to execute
`get` requests to the `Tasks` endpoint until the `status` of the response is 
either `succeeded` or `failed`.

### Migrating from 0.20.0

Most if not all endpoints in Meilisearch now return the status of an enqueued task.

Whereas before methods like `Indexes.create` would immediately return information on the
created index, now it is necessary to wait for the task to be resolved before accessing
or further modifying a given entity - for this, use the `Tasks.await_result/2` function.

Because of this, some functions do not return errors as expected - notably, `Indexes.create` when
creating indexes with duplicate uid's, as well as `Indexes.delete` and `Indexes.update` in some cases. 

Make sure to check the finalized task for errors that might have been caused by these
methods (using `Task.await_result/2`).

As well - the `Settings` API has changed. Whereas before one could access `facetableAttributes`,
now this setting has been renamed `filterableAttributes`. In turn, `facets` in the `Settings`
endpoint simply refers to the `maxValuesPerFacet` setting.

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

The 0.30.X versions of this client have been teseted against the following versions of Meilisearch:
  - v0.28.0

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
