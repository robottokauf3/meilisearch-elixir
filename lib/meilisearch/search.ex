defmodule Meilisearch.Search do
  @moduledoc """
  Collection of functions used to search for documents matching given query.

  [MeiliSearch Documentation - Search](https://docs.meilisearch.com/references/search.html)
  """
  alias Meilisearch.HTTP

  @doc """
  Search for documents matching a specific query in the given index.
  ([ref.](https://docs.meilisearch.com/reference/api/search.html#search-in-an-index-with-post-route))

  A `search_query` value of `nil` will send a placeholder query.

  ## Options

    * `offset` 	Number of documents to skip.  Defaults to `0`
    * `limit` 	Maximum number of documents returned.  Defaults to `20`
    * `filter` 	Filter queries by an attribute value.  Defaults to `nil`
    * `facetsDistribution` 	Facets for which to retrieve the matching count.  Defaults to `nil`
    * `attributesToRetrieve` 	Attributes to display in the returned documents.  Defaults to `["*"]`
    * `attributesToCrop` 	Attributes whose values have to be cropped.  Defaults to `nil`
    * `cropLength` 	Length used to crop field values.  Defaults to `200`
    * `attributesToHighlight` 	Attributes whose values will contain highlighted matching terms.  Defaults to `nil`
    * `matches` 	Defines whether an object that contains information about the matches should be returned or not.  Defaults to `false`
    * `sort` 	Sort search results according to the attributes and sorting order (asc or desc) specified.  Defaults to `nil`

  ## Examples

      iex> Meilisearch.Search.search("movies", "where art thou")
      {:ok, %{
        "hits" => [
          %{
            "id" => 2,
            "tagline" => "They have a plan but not a clue",
            "title" => "O' Brother Where Art Thou"
          }
        ],
        "offset" => 0,
        "limit" => 20,
        "nbHits" => 1,
        "exhaustiveNbHits" => false,
        "processingTimeMs" => 17,
        "query" => "where art thou"
      }}

      iex> Meilisearch.Search.search("movies", nil, filter: "id = 2")
      {:ok, %{
        "hits" => [
          %{
            "id" => 2,
            "tagline" => "They have a plan but not a clue",
            "title" => "O' Brother Where Art Thou"
          }
        ],
        "offset" => 0,
        "limit" => 20,
        "nbHits" => 1,
        "exhaustiveNbHits" => false,
        "processingTimeMs" => 17,
        "query" => "where art thou"
      }}

      iex> Meilisearch.Search.search("movies", "nothing will match")
      {:ok, %{
        "hits" => [],
        "offset" => 0,
        "limit" => 20,
        "nbHits" => 0,
        "exhaustiveNbHits" => false,
        "processingTimeMs" => 27,
        "query" => "nothing will match"
      }}
  """
  @spec search(String.t(), String.t() | nil, Keyword.t()) :: HTTP.response()
  def search(uid, search_query, opts \\ []) do
    params =
      case search_query do
        nil -> opts
        q -> [{:q, q} | opts]
      end

    HTTP.post_request("indexes/#{uid}/search", Enum.into(params, %{}))
  end
end
