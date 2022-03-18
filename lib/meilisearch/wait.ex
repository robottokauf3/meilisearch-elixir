defmodule Meilisearch.Wait do
  @moduledoc """
  Utils functions to handle async api.
  """

  alias Meilisearch.Tasks

  @doc """
  Wait for meilisearch to handle async operation.

  ### Examples
      iex> Meilisearch.Indexes.create("meilisearch_test") |> Mailisearch.Wait.wait()
      {:ok,
        %{
          "createdAt" => "2020-05-23T06:20:18.394281328Z",
          "name" => "meilisearch_test",
          "primaryKey" => nil,
          "uid" => "meilisearch_test",
          "updatedAt" => "2020-05-23T06:20:18.394292399Z"
        }
      }
  """
  def wait({:ok, %{"uid" => uid}}) do
    wait(uid)
  end

  def wait(uid) do
    case Tasks.get(uid) do
      {:ok, %{"status" => "enqueued"}} ->
        :timer.sleep(500)
        wait(uid)

      _ ->
        :timer.sleep(500)
    end
  end
end
