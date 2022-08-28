defmodule Meilisearch.Tasks do
  @moduledoc """
  Collection of functions used to get information about the progress of enqueued tasks.

  [MeiliSearch Documentation - Updates](https://docs.meilisearch.com/references/tasks.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get the status of individual task.

  ## Example
      iex> Meilisearch.Tasks.get(1)
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
  def get(task_id) do
    HTTP.get_request("tasks/#{task_id}")
  end

  @doc """
  Get the status of all tasks.

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
      {:ok, %{ "results" => tasks }} -> {:ok, tasks}
      error -> error
    end
  end

  @doc """
  Get the status of all tasks for a given index.

  ## Example
      iex> Meilisearch.Tasks.list(index_uid)
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
      {:ok, %{ "results" => tasks }} -> {:ok, tasks}
      error -> error
    end
  end

  @doc """
  Await the resolution of an async task. Keeps trying in `for_milli` intervals (default is 250ms).

  # Example

    iex> Meilisearch.Tasks.await_result(1)
    {:ok,
      %{ 
        "uid" => 4,
        "indexUid"  =>"movie",
        "status" => "failed",
        "type" => "indexDeletion",
        "details" => %{
          "deletedDocuments" => 0
        },
        "error" => %{
          "message" => "Index `movie` not found.",
          "code" => "index_not_found",
          "type" => "invalid_request",
          "link" => "https://docs.meilisearch.com/errors#index_not_found"
        },
        "duration" => "PT0.001192S",
        "enqueuedAt" => "2022-08-04T12:28:15.159167Z",
        "startedAt" => "2022-08-04T12:28:15.161996Z",
        "finishedAt" => "2022-08-04T12:28:15.163188Z"
      }
    }
  """
  @spec await_result(String.t) :: HTTP.response()
  def await_result(task_uid, for_milli \\ 250) do
    case get(task_uid) do
      {:ok, %{"status" => status}} when status in ["enqueued", "processing"] -> 
        :timer.sleep(for_milli)
        await_result(task_uid, for_milli)

      message ->
        message
    end
  end

end
