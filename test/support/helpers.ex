defmodule Support.Helpers do
  @moduledoc false

  alias Meilisearch.{Indexes, Tasks}

  def delete_all_indexes do
    {:ok, indexes} = Indexes.list()

    indexes
    |> Enum.map(fn %{"uid" => uid} -> uid end)
    |> Enum.map(&Indexes.delete/1)
  end

  def wait_for_task_success(task), do: wait_for_task_status(task, "succeeded")
  def wait_for_task_failure(task), do: wait_for_task_status(task, "failed")

  def wait_for_task_status({:ok, task}, status), do: wait_for_task_status(task, status)
  def wait_for_task_status({:error, _, _}, _), do: false

  def wait_for_task_status(task = %{"uid" => uid}, status) do
    case Tasks.get(uid) do
      {:ok, %{"status" => "enqueued"}} ->
        :timer.sleep(500)
        wait_for_task_status(task, status)

      {:ok, %{"status" => ^status}} ->
        :timer.sleep(100)
        true

      _ ->
        :timer.sleep(100)
        false
    end
  end

  def wait_for_task({:ok, task}), do: wait_for_task(task)
  def wait_for_task({:error, _, _}), do: false

  def wait_for_task(task = %{"uid" => uid}) do
    case Tasks.get(uid) do
      {:ok, %{"status" => "enqueued"}} ->
        :timer.sleep(500)
        wait_for_task(task)

      _ ->
        :timer.sleep(100)
        true
    end
  end
end
