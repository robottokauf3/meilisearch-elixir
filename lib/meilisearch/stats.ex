defmodule Meilisearch.Stats do
  @moduledoc """
  Collection of functions used to retrive index stats.

  [MeiliSearch Documentation - Stats](https://docs.meilisearch.com/references/stats.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get stats for given index

  ## Example

      iex> Meilisearch.Stats.get("meilisearch_test")
      {:ok, %{"fieldsFrequency" => %{}, "isIndexing" => false, "numberOfDocuments" => 0}}

  """
  @spec get(String.t()) :: HTTP.response()
  def get(uid) do
    HTTP.get_request("indexes/#{uid}/stats")
  end

  @doc """
  Get stats for all indexes

  ## Example

      iex> Meilisearch.Stats.list()
      {:ok,
        %{
          "databaseSize" => 143360,
          "indexes" => %{
            "meilisearch_test" => %{
              "fieldsFrequency" => %{},
              "isIndexing" => false,
              "numberOfDocuments" => 0
            }
          },
          "lastUpdate" => "2020-05-09T05:39:01.222761213Z"
        }
      }

  """
  @spec list :: HTTP.response()
  def list do
    HTTP.get_request("stats")
  end
end
