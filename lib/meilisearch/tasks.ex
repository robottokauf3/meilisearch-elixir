defmodule Meilisearch.Tasks do
  @moduledoc """
  Collection of functions used to get information about the progress of updates.

  [MeiliSearch Documentation - Tasks](https://docs.meilisearch.com/references/updates.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get the status of individual update for given index.

  ## Example
      iex> Meilisearch.Tasks.get("meilisearch_test", 1)
      {:ok,
        %{
          "duration" => 0.013233943,
          "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
          "processedAt" => "2020-05-30T03:27:57.478393007Z",
          "status" => "processed",
          "type" => %{"name" => "DocumentsAddition", "number" => 1},
          "uid" => 0
        }
      }
  """
  @spec get(String.t(), String.t() | integer) :: HTTP.response()
  def get(index_uid, uid) do
    HTTP.get_request("indexes/#{index_uid}/tasks/#{uid}")
  end

  @doc """
  Get the status of individual update.

  ## Example
      iex> Meilisearch.Tasks.get(1)
      {:ok,
        %{
          "duration" => 0.013233943,
          "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
          "processedAt" => "2020-05-30T03:27:57.478393007Z",
          "status" => "processed",
          "type" => %{"name" => "DocumentsAddition", "number" => 1},
          "uid" => 0
        }
      }
  """
  @spec get(String.t() | integer) :: HTTP.response()
  def get(uid) do
    HTTP.get_request("/tasks/#{uid}")
  end

  @doc """
  Get the status of all updates for given index.

  ## Example
      iex> Meilisearch.Tasks.list("meilisearch_test")
      {:ok,
      [
        %{
          "duration" => 0.013233943,
          "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
          "processedAt" => "2020-05-30T03:27:57.478393007Z",
          "status" => "processed",
          "type" => %{"name" => "DocumentsAddition", "number" => 1},
          "uid" => 0
        }
      ]}
  """
  @spec list(String.t()) :: HTTP.response()
  def list(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/tasks")
  end
end
