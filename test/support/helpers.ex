defmodule Support.Helpers do
  @moduledoc false

  alias Meilisearch.{Indexes, Tasks}

  def delete_all_indexes do
    {:ok, indexes} = Indexes.list()

    indexes
    |> Enum.map(fn %{"uid" => uid} -> uid end)
    |> Enum.map(&Indexes.delete/1)
  end

  def wait_for_update(update_id) do
    case Tasks.get(update_id) do
      {:ok, %{"status" => "enqueued"}} ->
        :timer.sleep(500)
        wait_for_update(update_id)

      message ->
        :timer.sleep(200)
        message
    end
  end

  def create_index(uid, opts \\ []) do
    {:ok, %{"taskUid" => update_id}} = Indexes.create(uid, opts)
    wait_for_update(update_id)
  end
end
