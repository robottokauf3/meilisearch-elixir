defmodule Meilisearch.Updates do
  @moduledoc """
  Collection of functions used to get information about the progress of updates.

  [MeiliSearch Documentation - Updates](https://docs.meilisearch.com/references/updates.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get the status of individual update.

  ## Example
      iex> Meilisearch.Updates.get(1)
      {:ok,
        %{
          "uid" => 1,
          "indexUid" => "test_index",
          "status" => "succeeded",
          "type" => "documentAdditionOrUpdate",
          "details" => %{
            "receivedDocuments: 6748,
            "indexedDocuments: 6743
          },
          "duration" => 0.013233943,
          "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
          "startedAt" => "2020-05-30T03:27:57.478393007Z",
          "finishedAt" => "2020-05-30T03:27:57.578393007Z",
        }
      }
  """
  @spec get(String.t() | integer) :: HTTP.response()
  def get(update_id) do
    HTTP.get_request("tasks/#{update_id}")
  end

  @doc """
  Get the status of all updates.

  ## Example
      iex> Meilisearch.Updates.list()
      {:ok,
        [
          %{
            "uid" => 2,
            "indexUid" => "test_index",
            "status" => "succeeded",
            "type" => "documentAdditionOrUpdate",
            "details" => %{
              "receivedDocuments: 6748,
              "indexedDocuments: 6743
            },
            "duration" => 0.013233943,
            "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
            "startedAt" => "2020-05-30T03:27:57.478393007Z",
            "finishedAt" => "2020-05-30T03:27:57.578393007Z",
          },
          %{
            "uid" => 1,
            "indexUid" => "test_index",
            "status" => "succeeded",
            "type" => "documentAdditionOrUpdate",
            "details" => %{
              "receivedDocuments: 6748,
              "indexedDocuments: 6743
            },
            "duration" => 0.013233943,
            "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
            "startedAt" => "2020-05-30T03:27:57.478393007Z",
            "finishedAt" => "2020-05-30T03:27:57.578393007Z",
          },
      ]}
  """
  @spec list() :: HTTP.response()
  def list() do
    case HTTP.get_request("tasks") do
      {:ok, %{ "results" => updates }} -> {:ok, updates}
      error -> error
    end
  end

  @doc """
  Get the status of all updates for a given index.

  ## Example
      iex> Meilisearch.Updates.list(index_uid)
      {:ok,
        [
          %{
            "uid" => 2,
            "indexUid" => "test_index",
            "status" => "succeeded",
            "type" => "documentAdditionOrUpdate",
            "details" => %{
              "receivedDocuments: 6748,
              "indexedDocuments: 6743
            },
            "duration" => 0.013233943,
            "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
            "startedAt" => "2020-05-30T03:27:57.478393007Z",
            "finishedAt" => "2020-05-30T03:27:57.578393007Z",
          },
          %{
            "uid" => 1,
            "indexUid" => "test_index",
            "status" => "succeeded",
            "type" => "documentAdditionOrUpdate",
            "details" => %{
              "receivedDocuments: 6748,
              "indexedDocuments: 6743
            },
            "duration" => 0.013233943,
            "enqueuedAt" => "2020-05-30T03:27:57.462943453Z",
            "startedAt" => "2020-05-30T03:27:57.478393007Z",
            "finishedAt" => "2020-05-30T03:27:57.578393007Z",
          },
      ]}
  """
  @spec list(String.t) :: HTTP.response()
  def list(index_uid) do
    case HTTP.get_request("tasks?indexUid=#{index_uid}") do
      {:ok, %{ "results" => updates }} -> {:ok, updates}
      error -> error
    end
  end

end
