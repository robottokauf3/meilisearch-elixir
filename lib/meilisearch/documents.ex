defmodule Meilisearch.Documents do
  @moduledoc """
  Collection of functions used to manage documents.

  [MeiliSearch Documentation - Documents](https://docs.meilisearch.com/references/documents.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get one document by id.
  ([ref.](https://docs.meilisearch.com/reference/api/documents.html#get-one-document))

  ## Example

      iex> Meilisearch.Documents.get("movies", 1)
      {:ok, %{
        "id" => 25684,
        "title" => "American Ninja 5",
        "poster" => "https://image.tmdb.org/t/p/w1280/iuAQVI4mvjI83wnirpD8GVNRVuY.jpg",
        "overview" => "When a scientists daughter is kidnapped, American Ninja, attempts to find her, but this time he teams up with a youngster he has trained in the ways of the ninja.",
        "release_date" => "1993-01-01"
      }}

      iex> Meilisearch.Documents.get("movies", 404)
      {:error, 404, "Document `404` not found."}
  """
  @spec get(String.t(), String.t()) :: HTTP.response()
  def get(index_uid, document_id) do
    HTTP.get_request("indexes/#{index_uid}/documents/#{document_id}")
  end

  @doc """
  List documents in given index.
  ([ref.](https://docs.meilisearch.com/reference/api/documents.html#get-documents))

  ## Options

    * `offset` 	Number of documents to skip.  Defaults to `0`
    * `limit` 	Maximum number of documents returned.  Defaults to `20`
    * `attributesToRetrieve` 	Document attributes to show.

  ## Examples

      iex> Meilisearch.Documents.list("movies")
      {:ok, %{
        "limit" => 20,
        "offset" => 0,
        "results" => [
          %{
            "id" => 1,
            "release_date" => "1993-01-01",
            "poster" => "https://image.tmdb.org/t/p/w1280/iuAQVI4mvjI83wnirpD8GVNRVuY.jpg",
            "title" => "American Ninja 5",
            "overview" => "When a scientists daughter is kidnapped, American Ninja, attempts to find her, but this time he teams up with a youngster he has trained in the ways of the ninja."
          },
          %{
            "id" => 2,
            "title" => "Dead in a Week (Or Your Money Back)",
            "release_date" => "2018-09-12",
            "poster" => "https://image.tmdb.org/t/p/w1280/f4ANVEuEaGy2oP5M0Y2P1dwxUNn.jpg",
            "overview" => "William has failed to kill himself so many times that he outsources his suicide to aging assassin Leslie. But with the contract signed and death assured within a week (or his money back), William suddenly discovers reasons to live... However Leslie is under pressure from his boss to make sure the contract is completed."
          }
        ],
        "total" => 2
      }}

      iex> Meilisearch.Documents.get("movies", limit: 2, offset: 4)
      {:ok, %{
        "limit" => 20,
        "offset" => 0,
        "results" => [
          %{
            "id" => 5,
            "release_date" => "1993-01-01",
            "poster" => "https://image.tmdb.org/t/p/w1280/iuAQVI4mvjI83wnirpD8GVNRVuY.jpg",
            "title" => "American Ninja 5",
            "overview" => "When a scientists daughter is kidnapped, American Ninja, attempts to find her, but this time he teams up with a youngster he has trained in the ways of the ninja."
          },
          %{
            "id" => 6,
            "title" => "Dead in a Week (Or Your Money Back)",
            "release_date" => "2018-09-12",
            "poster" => "https://image.tmdb.org/t/p/w1280/f4ANVEuEaGy2oP5M0Y2P1dwxUNn.jpg",
            "overview" => "William has failed to kill himself so many times that he outsources his suicide to aging assassin Leslie. But with the contract signed and death assured within a week (or his money back), William suddenly discovers reasons to live... However Leslie is under pressure from his boss to make sure the contract is completed."
          }
        ],
        "total" => 6
      }}
  """
  @spec list(String.t(), Keyword.t()) :: HTTP.response()
  def list(index_uid, params \\ []) do
    HTTP.get_request("indexes/#{index_uid}/documents", params)
  end

  @doc """
  Add document(s) to given index.
  ([ref.](https://docs.meilisearch.com/reference/api/documents.html#add-or-replace-documents))

  If an exisiting document (based on primary key) is given it will be replaced.

  ## Examples

      iex> Meilisearch.Documents.add_or_replace("movies", %{
        "id" => 2,
        "tagline" => "You'll never go in the water again",
        "title" => "Jaws"
      })
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentAddition",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}

      iex> Meilisearch.Documents.add_or_replace(
        "movies",
        [
          %{
            "id" => 6,
            "tagline" => "Who ya gonna call?",
            "title" => "Ghostbusters"
          },
          %{
            "id" => 5,
            "tagline" => "Be Afraid. Be very afraid.",
            "title" => "The Fly"
          }
        ]
      )
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentAddition",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """

  @spec add_or_replace(String.t(), list(any), Keyword.t()) :: HTTP.response()
  def add_or_replace(index_uid, docs, params \\ [])

  def add_or_replace(index_uid, doc, params) when not is_list(doc) do
    add_or_replace(index_uid, [doc], params)
  end

  def add_or_replace(index_uid, docs, params) do
    HTTP.post_request("indexes/#{index_uid}/documents", docs, params)
  end

  @doc """
  Add document(s) to given index.
  ([ref.](https://docs.meilisearch.com/reference/api/documents.html#add-or-update-documents))

  If an exisiting document (based on primary key) is given it will be updated with provided values.

  ## Examples

      iex> Meilisearch.Documents.add_or_update("movies", %{
        "id" => 2,
        "tagline" => "You'll never go in the water again",
        "title" => "Jaws"
      })
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentPartial",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}

      iex> Meilisearch.Documents.add_or_update(
        "movies",
        [
          %{
            "id" => 6,
            "tagline" => "Who ya gonna call?",
            "title" => "Ghostbusters"
          },
          %{
            "id" => 5,
            "tagline" => "Be Afraid. Be very afraid.",
            "title" => "The Fly"
          }
        ]
      )
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentPartial",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec add_or_update(String.t(), list(any), Keyword.t()) :: {:ok, any} | {:error, String.t()}
  def add_or_update(index_uid, docs, params \\ [])

  def add_or_update(index_uid, doc, params) when not is_list(doc) do
    add_or_update(index_uid, [doc], params)
  end

  def add_or_update(index_uid, docs, params) do
    HTTP.put_request("indexes/#{index_uid}/documents", docs, params)
  end

  @doc """
  Delete one or more documents based on id in a given index.
  ([ref. one](https://docs.meilisearch.com/reference/api/documents.html#delete-one-document))
  ([ref. batch](https://docs.meilisearch.com/reference/api/documents.html#delete-documents))

  ## Example

      iex> Meilisearch.Documents.delete("movies", 1)
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentDeletion",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}

      iex> Meilisearch.Documents.delete("movies", [1,2,3,4])
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentDeletion",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """

  @spec delete(String.t(), String.t() | list(String.t())) :: {:ok, any} | {:error, String.t()}
  def delete(index_uid, document_ids) when is_list(document_ids) do
    HTTP.post_request("indexes/#{index_uid}/documents/delete-batch", document_ids)
  end

  def delete(index_uid, document_id) do
    HTTP.delete_request("indexes/#{index_uid}/documents/#{document_id}")
  end

  @doc """
  Delete all documents in given index.
  ([ref.](https://docs.meilisearch.com/reference/api/documents.html#delete-all-documents))

  ## Example

      iex> Meilisearch.Documents.delete_all("meilisearch_test")
      {:ok, %{
        "uid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "documentDeletion",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}

  """
  @spec delete_all(String.t()) :: {:ok, any} | {:error, binary}
  def delete_all(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/documents")
  end
end
