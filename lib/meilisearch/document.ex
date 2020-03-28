defmodule Meilisearch.Document do
  @moduledoc """
  Collection of functions used to manage documents.

  [MeiliSearch Documentation - Documents](https://docs.meilisearch.com/references/documents.html)
  """
  def get(addr, index_uid, document_id) do
    HTTPoison.get!("#{addr}/indexes/#{index_uid}/documents/#{document_id}")
  end

  def list(addr, index_uid, opts \\ []) do
    HTTPoison.get!("#{addr}/indexes/#{index_uid}/documents")
  end

  def add_or_replace(addr, index_uid, docs, opts \\ []) do
    body = docs |> Jason.encode!()

    HTTPoison.post!("#{addr}/indexes/#{index_uid}/documents", body)
  end

  def add_or_update(addr, index_uid, docs, opts \\ []) do
    body = docs |> Jason.encode!()

    HTTPoison.put!("#{addr}/indexes/#{index_uid}/documents", body)
  end

  def delete(addr, index_uid, document_ids) when is_list(document_ids) do
    body = document_ids |> Jason.encode!()
    HTTPoison.post!("#{addr}/indexes/#{index_uid}/documents/delete-batch", body)
  end

  def delete(addr, index_uid, document_id) do
    HTTPoison.delete!("#{addr}/indexes/#{index_uid}/documents/#{document_id}")
  end

  def delete_all(addr, index_uid) do
    HTTPoison.delete!("#{addr}/indexes/#{index_uid}/documents")
  end
end
