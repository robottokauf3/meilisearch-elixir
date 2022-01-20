defmodule Meilisearch.Stats do
  @moduledoc """
  Collection of functions used to retrive index stats.

  [MeiliSearch Documentation - Stats](https://docs.meilisearch.com/references/stats.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get stats for given index
  ([ref.](https://docs.meilisearch.com/reference/api/stats.html#get-stats-of-an-index))

  ## Example

      iex> Meilisearch.Stats.get("movies")
      {:ok,
      %{
        "numberOfDocuments" => 19654,
        "isIndexing" => false,
        "fieldDistribution" => %{
          "poster" => 19654,
          "release_date" => 19654,
          "title" => 19654,
          "id" => 19654,
          "overview" => 19654
        }
      }}

  """
  @spec get(String.t()) :: HTTP.response()
  def get(uid) do
    HTTP.get_request("indexes/#{uid}/stats")
  end

  @doc """
  Get stats for all indexes
  ([ref.](https://docs.meilisearch.com/reference/api/stats.html#get-stats-of-all-indexes))

  ## Example

      iex> Meilisearch.Stats.list()
      {:ok,
      %{
        "databaseSize" => 447819776,
        "lastUpdate" => "2019-11-15T11:15:22.092896Z",
        "indexes" => %{
          "movies" => %{
            "numberOfDocuments" => 19654,
            "isIndexing" => false,
            "fieldDistribution" => {
              "poster" => 19654,
              "overview" => 19654,
              "title" => 19654,
              "id" => 19654,
              "release_date" => 19654
            }
          },
          "rangemovies" => %{
            "numberOfDocuments" => 19654,
            "isIndexing" => false,
            "fieldDistribution" => %{
              "overview" => 19654,
              "id" => 19654,
              "title" => 19654
            }
          }
        }
      }}

  """
  @spec list :: HTTP.response()
  def list do
    HTTP.get_request("stats")
  end
end
