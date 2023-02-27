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
  @spec list(String.t() | Keyword.t()) :: HTTP.response()
  def list(index_uid, params \\ [])

  def list(params, []) when is_list(params) do
    HTTP.get_request("tasks", params)
  end

  def list(index_uid, params) when is_binary(index_uid) do
    HTTP.get_request("tasks", Keyword.put_new(params, :indexUids, index_uid))
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

  @doc """
  Cancel any number of enqueued or processing tasks based on their uid, status, type, indexUid, or
  the date at which they were enqueued, processed, or completed.
  Task cancelation is an atomic transaction: either all tasks are successfully canceled or none are.
  ([ref.](https://docs.meilisearch.com/reference/api/tasks.html#cancel-tasks))

  ## Example

      iex> Meilisearch.Tasks.cancel(1)
      {:ok, %{
        "taskUid" => 3,
        "indexUid" => null,
        "status" => "enqueued",
        "type" => "taskCancelation",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}

      iex> Meilisearch.Tasks.cancel(types: "documentDeletion,documentPartial")
      {:ok, %{
        "taskUid" => 3,
        "indexUid" => null,
        "status" => "enqueued",
        "type" => "taskCancelation",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}


  """
  @spec cancel(String.t() | Keyword.t()) :: HTTP.response()
  def cancel(task_uid, params \\ [])

  def cancel(params, []) when is_list(params) do
    HTTP.post_request("tasks/cancel", nil, params)
  end

  def cancel(task_uid, params) do
    HTTP.post_request("tasks/cancel", nil, Keyword.put_new(params, :uids, "#{task_uid}"))
  end

  @doc """
  Delete a finished (succeeded, failed, or canceled) task based on uid, status, type, indexUid, canceledBy,
  or date. Task deletion is an atomic transaction: either all tasks are successfully deleted, or none are.
  ([ref.](https://docs.meilisearch.com/reference/api/tasks.html#delete-tasks))

  ## Example

      iex> Meilisearch.Tasks.delete(1)
      {:ok, %{
        "taskUid" => 3,
        "indexUid" => null,
        "status" => "enqueued",
        "type" => "taskDeletion",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}

      iex> Meilisearch.Tasks.delete(status: "failed,canceled,succeeded")
      {:ok, %{
        "taskUid" => 3,
        "indexUid" => null,
        "status" => "enqueued",
        "type" => "taskDeletion",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}


  """
  @spec delete(String.t() | Keyword.t()) :: HTTP.response()
  def delete(task_uid, params \\ [])

  def delete(params, []) when is_list(params) do
    HTTP.delete_request("tasks", params)
  end

  def delete(task_uid, params) do
    HTTP.delete_request("tasks", Keyword.put_new(params, :uids, "#{task_uid}"))
  end
end
