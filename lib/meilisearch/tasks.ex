defmodule Meilisearch.Tasks do
  @moduledoc """
  Collection of functions used to get information about the progress of asynchronous operations.

  [MeiliSearch Documentation - Tasks](https://docs.meilisearch.com/reference/api/tasks.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get the status of all tasks.
  ([ref.](https://docs.meilisearch.com/reference/api/tasks.html#get-all-tasks))

  ## Example
      iex> Meilisearch.Tasks.list()
      {:ok,
        %{
          "results" => [
            %{
              "uid" => 1,
              "indexUid" => "movies",
              "status" => "enqueued",
              "type" => "documentAddition",
              "duration" => nil,
              "enqueuedAt" => "2021-08-12T10:00:00.000000Z",
              "startedAt" => nil,
              "finishedAt" => nil
            },
            %{
              {
                "uid" => 0,
                "indexUid" => "movies",
                "status" => "succeeded",
                "type" => "documentAddition",
                "details" => %{
                  "receivedDocuments" => 100,
                  "indexedDocuments" => 100
                },
                "duration" => "PT16S",
                "enqueuedAt" => "2021-08-11T09:25:53.000000Z",
                "startedAt" => "2021-08-11T10:03:00.000000Z",
                "finishedAt" => "2021-08-11T10:03:16.000000Z"
            }
            }
          ]
        }
      }
  """
  @spec list :: HTTP.response()
  def list, do: HTTP.get_request("tasks")

  @doc """
  Get the status of all tasks for given index.
  ([ref.](https://docs.meilisearch.com/reference/api/tasks.html#get-all-tasks-by-index))

  ## Example
      iex> Meilisearch.Tasks.list("movies")
      {:ok,
        %{
          "results" => [
            %{
              "uid" => 1,
              "indexUid" => "movies",
              "status" => "enqueued",
              "type" => "documentAddition",
              "duration" => nil,
              "enqueuedAt" => "2021-08-12T10:00:00.000000Z",
              "startedAt" => nil,
              "finishedAt" => nil
            },
            %{
              {
                "uid" => 0,
                "indexUid" => "movies",
                "status" => "succeeded",
                "type" => "documentAddition",
                "details" => %{
                  "receivedDocuments" => 100,
                  "indexedDocuments" => 100
                },
                "duration" => "PT16S",
                "enqueuedAt" => "2021-08-11T09:25:53.000000Z",
                "startedAt" => "2021-08-11T10:03:00.000000Z",
                "finishedAt" => "2021-08-11T10:03:16.000000Z"
            }
            }
          ]
        }
      }
  """
  @spec list(String.t() | [String.t()]) :: HTTP.response()
  def list(index_uid) when is_list(index_uid) do
    HTTP.get_request("tasks", [], indexUids: Enum.join(index_uid, ","))
  end

  def list(index_uid) do
    HTTP.get_request("tasks", [], indexUids: index_uid)
  end

  @doc """
  Get the status of individual task.
  ([ref.](https://docs.meilisearch.com/reference/api/tasks.html#get-task))

  ## Example
      iex> Meilisearch.Tasks.get(1)
      {:ok,
        %{
          "uid" => 1,
          "indexUid" => "movies",
          "status" => "succeeded",
          "type" => "settingsUpdate",
          "details" => %{
            "rankingRules" => [
              "typo",
              "ranking:desc",
              "words",
              "proximity",
              "attribute",
              "exactness"
            ]
          },
          "duration" => "PT1S",
          "enqueuedAt" => "2021-08-10T14:29:17.000000Z",
          "startedAt" => "2021-08-10T14:29:18.000000Z",
          "finishedAt" => "2021-08-10T14:29:19.000000Z"
        }
      }
  """
  @spec get(String.t() | integer) :: HTTP.response()
  def get(task_uid) do
    HTTP.get_request("tasks/#{task_uid}")
  end
end
