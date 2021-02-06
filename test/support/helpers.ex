defmodule Support.Helpers do
  @moduledoc false

  alias Meilisearch.{Indexes, Updates}

  def delete_all_indexes do
    {:ok, indexes} = Indexes.list()

    indexes
    |> Enum.map(fn %{"uid" => uid} -> uid end)
    |> Enum.map(&Indexes.delete/1)
  end

  def wait_for_update(index_uid, update_id) do
    case Updates.get(index_uid, update_id) do
      {:ok, %{"status" => "enqueued"}} ->
        :timer.sleep(500)
        wait_for_update(index_uid, update_id)

      _ ->
        :timer.sleep(500)
    end
  end
end
