use Mix.Config

config :meilisearch,
  # Latest version from docker-compose.yml
  endpoint: "http://localhost:7700",
  api_key: "test_api_key",
  test_index: "meilisearch_test_index"
