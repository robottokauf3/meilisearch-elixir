defmodule Meilisearch.Updates do
  @moduledoc """
  Collection of functions used to get information about the progress of updates.

  [MeiliSearch Documentation - Updates](https://docs.meilisearch.com/references/updates.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get the status of individual update for given index.

  ## Example
      iex> Meilisearch.Updates.get("meilisearch_test", 1)
      {:ok,
        %{
          "duration" => 0.013233943,
          "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
          "processedAt" => "2020-05-30T03:27:57.478393007Z",
          "status" => "processed",
          "type" => %{"name" => "DocumentsAddition", "number" => 1},
          "updateId" => 0
        }
      }
  """
  @spec get(String.t(), String.t() | integer) :: HTTP.response()
  def get(index_uid, update_id) do
    HTTP.get_request("indexes/#{index_uid}/updates/#{update_id}")
  end

  @doc """
  Get the status of all updates for given index.

  ## Example
      iex> Meilisearch.Updates.list("meilisearch_test")
      {:ok,
      [
        %{
          "duration" => 0.013233943,
          "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
          "processedAt" => "2020-05-30T03:27:57.478393007Z",
          "status" => "processed",
          "type" => %{"name" => "DocumentsAddition", "number" => 1},
          "updateId" => 0
        }
      ]}
  """
  @spec list(String.t()) :: HTTP.response()
  def list(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/updates")
  end
end
