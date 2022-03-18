defmodule Support.Helpers do
  @moduledoc false

  alias Meilisearch.{Indexes, Wait}

  def delete_all_indexes do
    {:ok, indexes} = Indexes.list()

    indexes
    |> Enum.map(fn %{"uid" => uid} -> uid end)
    |> Enum.map(&Indexes.delete/1)
    |> Enum.map(&Wait.wait/1)
  end
end
