defmodule Meilisearch.Indexes do
  @moduledoc """
  Collection of functions used to manage indexes.

  [MeiliSearch Documentation - Indexes](https://docs.meilisearch.com/references/indexes.html)
  """

  alias Meilisearch.HTTP

  @doc """
  List all indexes.
  ([ref.](https://docs.meilisearch.com/reference/api/indexes.html#list-all-indexes))

  ## Example

      iex> Meilisearch.Indexes.list()
      {:ok, %{
        "limit" => 20,
        "offset" => 0,
        "results" => [
          %{
            "uid" => "movies",
            "primaryKey" => "movie_id",
            "createdAt" => "2019-11-20T09:40:33.711324Z",
            "updatedAt" => "2019-11-20T10:16:42.761858Z"
          },
          %{
            "uid" => "movie_reviews",
            "primaryKey" => nil,
            "createdAt" => "2019-11-20T09:40:33.711324Z",
            "updatedAt" => "2019-11-20T10:16:42.761858Z"
          }
        ],
        "total" => 2
      }}

  """
  @spec list :: HTTP.response()
  def list do
    HTTP.get_request("indexes")
  end

  @doc """
  Get information about an index.
  ([ref.](https://docs.meilisearch.com/reference/api/indexes.html#get-one-index))

  ## Example

      iex> Meilisearch.Indexes.get("meilisearch_test")
      {:ok, %{
        "uid" => "movies",
        "primaryKey" => "movie_id",
        "createdAt" => "2019-11-20T09:40:33.711324Z",
        "updatedAt" => "2019-11-20T10:16:42.761858Z"
      }}

  """
  @spec get(String.t()) :: HTTP.response()
  def get(uid) do
    HTTP.get_request("indexes/#{uid}")
  end

  @doc """
  Create an index.
  ([ref.](https://docs.meilisearch.com/reference/api/indexes.html#create-an-index))

  `primary_key` can be passed as an option.

  ## Examples

      iex> Meilisearch.Indexes.create("movies")
      {:ok, %{
        "taskUid" => 0,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "indexCreation",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}

      iex> Meilisearch.create("movies", primary_key: "movie_id")
      {:ok, %{
        "taskUid" => 0,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "indexCreation",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}
  """
  @spec create(String.t(), Keyword.t()) :: HTTP.response()
  def create(uid, opts \\ []) do
    body = %{
      uid: uid,
      primaryKey: Keyword.get(opts, :primary_key)
    }

    HTTP.post_request("indexes", body)
  end

  @doc """
  Update an index with new primary key.
  ([ref.](https://docs.meilisearch.com/reference/api/indexes.html#update-an-index))

  Will fail if primary key has already been set and index already contains documents.

  `primary_key` option is required.

  ## Examples

      iex> Meilisearch.Indexes.update("movie_review", primary_key: "movie_review_id")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movie_review",
        "status" => "enqueued",
        "type" => "indexUpdate",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}
  """
  @spec update(String.t(), primary_key: String.t()) :: HTTP.response()
  def update(uid, opts \\ []) do
    with {:ok, primary_key} <- Keyword.fetch(opts, :primary_key),
         body <- %{primaryKey: primary_key} do
      HTTP.patch_request("indexes/#{uid}", body)
    else
      _ -> {:error, 400, "primary_key is required"}
    end
  end

  @doc """
  Delete an index.
  ([ref.](https://docs.meilisearch.com/reference/api/indexes.html#delete-an-index))

  ## Examples

      iex> Meilisearch.Indexes.delete("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "indexDeletion",
        "enqueuedAt" => "2021-08-12T10:00:00.000000Z"
      }}

      iex> Meilisearch.delete("nonexistent_index")
      {:error, 404, Index meilisearch_test not found"}
  """
  @spec delete(String.t()) :: HTTP.response()
  def delete(uid) do
    HTTP.delete_request("indexes/#{uid}")
  end

  @doc """
  Check if index exists

  ## Examples

      iex> Meilisearch.Indexes.exists?("movies")
      {:ok, true}

      iex> Meilisearch.Indexes.exists?("movies_index_that_does_not_exists")
      {:ok, false}
  """
  @spec exists?(String.t()) :: {:ok, true | false} | {:error, String.t()}
  def exists?(uid) do
    case get(uid) do
      {:ok, _} -> {:ok, true}
      {:error, 404, _} -> {:ok, false}
      _ -> {:error, "Unknown error has occured"}
    end
  end
end
