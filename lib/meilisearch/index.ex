defmodule Meilisearch.Index do
  @moduledoc """
  Collection of functions used to manage indexes.

  [MeiliSearch Documentation - Indexes](https://docs.meilisearch.com/references/indexes.html)
  """
  def list(url) do
    HTTPoison.get!("#{url}/indexes")
  end

  def get(url, uid) do
    HTTPoison.get!("#{url}/indexes/#{uid}")
  end

  def create(url, uid, opts \\ []) do
    body =
      %{uid: uid}
      |> Jason.encode!()

    HTTPoison.post!("#{url}/indexes", body)
  end

  def update(url, uid, opts \\ []) do
  end

  def delete(url, uid) do
    HTTPoison.delete!("#{url}/indexes/#{uid}")
  end
end
