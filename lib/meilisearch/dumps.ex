defmodule Meilisearch.Dumps do
  @moduledoc """
  Collection of functions used to create and get status of database dumps.

  [MeiliSearch Documentation - Dumps](https://docs.meilisearch.com/references/dumps.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Create new database dump.
  ([ref.](https://docs.meilisearch.com/reference/api/dump.html#create-a-dump))

  ## Example

      iex> Meilisearch.Dumps.create()
      {:ok, %{
        "uid" => "20200929-114144097",
        "status" => "in_progress",
        "startedAt" => "2020-09-29T11:41:44.392327Z"
      }}
  """
  @spec create :: HTTP.response()
  def create do
    HTTP.post_request("dumps", %{})
  end

  @doc """
  Get status of a database dump via uid.
  ([ref.](https://docs.meilisearch.com/reference/api/dump.html#get-dump-status))

  `status` field could be one of these:
  - `in_progress` Dump creation is in progress
  - `failed` An error occurred during dump process, and the task was aborted
  - `done` Dump creation is finished and was successful

  ## Example

      iex> Meilisearch.Dumps.status()
      {:ok, %{
        "uid" => "20200929-114144097",
        "status" => "done",
        "startedAt" => "2020-09-29T11:41:44.392327Z",
        "finishedAt" => "2020-09-29T11:41:50.792147Z"
      }}
  """
  @spec status(String.t()) :: HTTP.response()
  def status(uid) do
    HTTP.get_request("dumps/#{uid}/status")
  end
end
