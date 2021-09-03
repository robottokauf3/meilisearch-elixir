defmodule Meilisearch.Dumps do
  @moduledoc """
  Collection of functions used to create and get status of database dumps.

  [MeiliSearch Documentation - Dumps](https://docs.meilisearch.com/references/dumps.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Create new database dump.

  ## Example

      iex> Meilisearch.Dumps.create()
      {
        :ok,
        %{
          "status" => "in_progress",
          "uid" => "20210130-215135357"
        }
      }
  """
  @spec create :: HTTP.response()
  def create do
    HTTP.post_request("dumps", %{})
  end

  @doc """
  Get status of a database dump via uid.

  ## Example

      iex> Meilisearch.Dumps.status()
      {
        :ok,
        %{
          "status" => "done",
          "uid" => "20210130-215135357"
        }
      }
  """
  @spec status(String.t()) :: HTTP.response()
  def status(uid) do
    HTTP.get_request("dumps/#{uid}/status")
  end
end
