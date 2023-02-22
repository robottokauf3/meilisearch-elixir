defmodule Meilisearch.Settings do
  @moduledoc """
  Collection of functions used to manage settings.

  [MeiliSearch Documentation - Settings](https://docs.meilisearch.com/references/settings.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get settings.
  ([ref.](https://docs.meilisearch.com/reference/api/settings.html#get-settings))

  ## Example

      iex> Meilisearch.Settings.get("movies")
      {:ok, %{
        "rankingRules" => [
          "typo",
          "words",
          "proximity",
          "attribute",
          "wordsPosition",
          "exactness",
          "desc(release_date)"
        ],
        "filterableAttributes" => [
          "genres"
        ],
        "distinctAttribute" => nil,
        "searchableAttributes" => [
          "title",
          "description",
          "genres"
        ],
        "displayedAttributes" => [
          "title",
          "description",
          "genre",
          "release_date"
        ],
        "stopWords" => nil,
        "synonyms" => {
          "wolverine" => [
            "xmen",
            "logan"
          ],
          "logan" => [
            "wolverine",
            "xmen"
          ]
        }
      }}
  """
  @spec get(String.t()) :: HTTP.response()
  def get(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings")
  end

  @doc """
  Update settings.
  ([ref.](https://docs.meilisearch.com/reference/api/settings.html#update-settings))

  ## Example

      iex> Meilisearch.Settings.update("movies", %{
        "rankingRules" => [
          "words",
          "typo",
          "proximity",
          "attribute",
          "sort",
          "exactness",
          "release_date:desc",
          "rank:desc"
        ],
        "distinctAttribute" => "movie_id",
        "searchableAttributes" => [
          "title",
          "description",
          "genre"
        ],
        "displayedAttributes" => [
          "title",
          "description",
          "genre",
          "release_date"
        ],
        "stopWords" => [
          "the",
          "a",
          "an"
        ],
        "sortableAttributes" => [
          "title",
          "release_date"
        ],
        "synonyms" => %{
          "wolverine" => ["xmen", "logan"],
          "logan" => ["wolverine"]
        }
      })
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update(String.t(), any()) :: HTTP.response()
  def update(index_uid, settings \\ %{}) do
    HTTP.patch_request("indexes/#{index_uid}/settings", settings)
  end

  @doc """
  Reset settings.
  ([ref.](https://docs.meilisearch.com/reference/api/settings.html#reset-settings))

  ## Example

      iex> Meilisearch.Settings.reset("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset(String.t()) :: HTTP.response()
  def reset(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings")
  end

  @doc """
  Get the displayed attributes of an index.
  ([ref.](https://docs.meilisearch.com/reference/api/displayed_attributes.html#get-displayed-attributes))

  ## Example

      iex> Meilisearch.Settings.get_displayed_attributes("movies")
      {:ok, [
        "title",
        "description",
        "genre",
        "release_date"
      ]}
  """
  @spec get_displayed_attributes(String.t()) :: HTTP.response()
  def get_displayed_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/displayed-attributes")
  end

  @doc """
  Update displayed attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/displayed_attributes.html#update-displayed-attributes))

  ## Example

      iex> Meilisearch.Settings.update_displayed_attributes("movies", [
          "title",
          "description",
          "genre",
          "release_date"
      ])
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_displayed_attributes(String.t(), list(String.t())) :: HTTP.response()
  def update_displayed_attributes(index_uid, displayed_attributes) do
    HTTP.put_request(
      "indexes/#{index_uid}/settings/displayed-attributes",
      displayed_attributes
    )
  end

  @doc """
  Reset displayed attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/displayed_attributes.html#reset-displayed-attributes))

  ## Example

      iex> Meilisearch.Settings.reset_displayed_attributes("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_displayed_attributes(String.t()) :: HTTP.response()
  def reset_displayed_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/displayed-attributes")
  end

  @doc """
  Get distinct attribute.
  ([ref.](https://docs.meilisearch.com/reference/api/distinct_attribute.html#get-distinct-attribute))

  ## Example

      iex> Meilisearch.Settings.get_distinct_attribute("movies")
      {:ok, "id"}
  """
  @spec get_distinct_attribute(String.t()) :: HTTP.response()
  def get_distinct_attribute(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/distinct-attribute")
  end

  @doc """
  Update distinct attribute.
  ([ref.](https://docs.meilisearch.com/reference/api/distinct_attribute.html#update-distinct-attribute))

  ## Example

      iex> Meilisearch.Settings.update_distinct_attribute("movies", "id")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_distinct_attribute(String.t(), String.t()) :: HTTP.response()
  def update_distinct_attribute(index_uid, distinct_attribute) do
    HTTP.put_request(
      "indexes/#{index_uid}/settings/distinct-attribute",
      distinct_attribute
    )
  end

  @doc """
  Reset distinct attribute.
  ([ref.](https://docs.meilisearch.com/reference/api/distinct_attribute.html#reset-distinct-attribute))

  ## Example

      iex> Meilisearch.Settings.reset_distinct_attribute("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_distinct_attribute(String.t()) :: HTTP.response()
  def reset_distinct_attribute(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/distinct-attribute")
  end

  @doc """
  Get filterable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/filterable_attributes.html#get-filterable-attributes))

  ## Example

      iex> Meilisearch.Settings.get_filterable_attributes("movies")
      {:ok, [
        "genres",
        "director"
      ]}
  """
  @spec get_filterable_attributes(String.t()) :: HTTP.response()
  def get_filterable_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/filterable-attributes")
  end

  @doc """
  Update filterable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/filterable_attributes.html#update-filterable-attributes))

  ## Example

      iex> Meilisearch.Settings.update_filterable_attributes("movies", [
        "genres",
        "director"
      ])
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_filterable_attributes(String.t(), list(String.t())) :: HTTP.response()
  def update_filterable_attributes(index_uid, filterable_attributes) do
    HTTP.put_request(
      "indexes/#{index_uid}/settings/filterable-attributes",
      filterable_attributes
    )
  end

  @doc """
  Reset filterable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/filterable_attributes.html#reset-filterable-attributes))

  ## Example

      iex> Meilisearch.Settings.reset_filterable_attributes("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_filterable_attributes(String.t()) :: HTTP.response()
  def reset_filterable_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/filterable-attributes")
  end

  @doc """
  Get ranking rules.
  ([ref.](https://docs.meilisearch.com/reference/api/ranking_rules.html#get-ranking-rules))

  ## Example

      iex> Meilisearch.Settings.get_ranking_rules("movies")
      {:ok, [
        "words",
        "typo",
        "proximity",
        "attribute",
        "sort",
        "exactness",
        "release_date:desc"
      ]}
  """
  @spec get_ranking_rules(String.t()) :: HTTP.response()
  def get_ranking_rules(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/ranking-rules")
  end

  @doc """
  Update ranking rules.
  ([ref.](https://docs.meilisearch.com/reference/api/ranking_rules.html#update-ranking-rules))

  ## Example

      iex> Meilisearch.Settings.update_ranking_rules(
        "movies",
        [
          "words",
          "typo",
          "proximity",
          "attribute",
          "sort",
          "exactness",
          "release_date:asc",
          "rank:desc"
        ]
      )
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_ranking_rules(String.t(), list(String.t())) :: HTTP.response()
  def update_ranking_rules(index_uid, ranking_rules) do
    HTTP.put_request("indexes/#{index_uid}/settings/ranking-rules", ranking_rules)
  end

  @doc """
  Reset ranking rules.
  ([ref.](https://docs.meilisearch.com/reference/api/ranking_rules.html#reset-ranking-rules))

  ## Example

      iex> Meilisearch.Settings.reset_ranking_rules("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_ranking_rules(String.t()) :: HTTP.response()
  def reset_ranking_rules(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/ranking-rules")
  end

  @doc """
  Get searchable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/searchable_attributes.html#get-searchable-attributes))

  ## Example

      iex> Meilisearch.Settings.get_searchable_attributes("movies")
      {:ok, [
        "title",
        "description",
        "genre"
      ]}
  """
  @spec get_searchable_attributes(String.t()) :: HTTP.response()
  def get_searchable_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/searchable-attributes")
  end

  @doc """
  Update searchable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/searchable_attributes.html#update-searchable-attributes))

  ## Example

      iex> Meilisearch.Settings.update_searchable_attributes("movies", [
        "title",
        "description",
        "genre"
      ])
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_searchable_attributes(String.t(), list(String.t())) :: HTTP.response()
  def update_searchable_attributes(index_uid, searchable_attributes) do
    HTTP.put_request(
      "indexes/#{index_uid}/settings/searchable-attributes",
      searchable_attributes
    )
  end

  @doc """
  Reset searchable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/searchable_attributes.html#reset-searchable-attributes))

  ## Example

      iex> Meilisearch.Settings.reset_searchable_attributes("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_searchable_attributes(String.t()) :: HTTP.response()
  def reset_searchable_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/searchable-attributes")
  end

  @doc """
  Get sortable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/sortable_attributes.html#get-sortable-attributes))

  ## Example

      iex> Meilisearch.Settings.get_sortable_attributes("movies")
      {:ok, [
        "price",
        "author"
      ]}
  """
  @spec get_sortable_attributes(String.t()) :: HTTP.response()
  def get_sortable_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/sortable-attributes")
  end

  @doc """
  Update sortable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/sortable_attributes.html#update-sortable-attributes))

  ## Example

      iex> Meilisearch.Settings.update_sortable_attributes("movies", [
        "price",
        "author"
      ])
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_sortable_attributes(String.t(), list(String.t())) :: HTTP.response()
  def update_sortable_attributes(index_uid, sortable_attributes) do
    HTTP.put_request(
      "indexes/#{index_uid}/settings/sortable-attributes",
      sortable_attributes
    )
  end

  @doc """
  Reset sortable attributes.
  ([ref.](https://docs.meilisearch.com/reference/api/sortable_attributes.html#reset-sortable-attributes))

  ## Example

      iex> Meilisearch.Settings.reset_sortable_attributes("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_sortable_attributes(String.t()) :: HTTP.response()
  def reset_sortable_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/sortable-attributes")
  end

  @doc """
  Get stop-words.
  ([ref.](https://docs.meilisearch.com/reference/api/stop_words.html#get-stop-words))

  ## Example

      iex> Meilisearch.Settings.get_stop_words("movies")
      {:ok, [
        "of",
        "the",
        "to"
      ]}
  """
  @spec get_stop_words(String.t()) :: HTTP.response()
  def get_stop_words(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/stop-words")
  end

  @doc """
  Update stop-words.
  ([ref.](https://docs.meilisearch.com/reference/api/stop_words.html#update-stop-words))

  ## Example

      iex> Meilisearch.Settings.update_stop_words("movies", ["the", "of", "to"])
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_stop_words(String.t(), list(String.t())) :: HTTP.response()
  def update_stop_words(index_uid, stop_words) do
    HTTP.put_request("indexes/#{index_uid}/settings/stop-words", stop_words)
  end

  @doc """
  Reset stop-words.
  ([ref.](https://docs.meilisearch.com/reference/api/stop_words.html#reset-stop-words))

  ## Example

      iex> Meilisearch.Settings.reset_stop_words("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_stop_words(String.t()) :: HTTP.response()
  def reset_stop_words(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/stop-words")
  end

  @doc """
  Get synonyms.
  ([ref.](https://docs.meilisearch.com/reference/api/synonyms.html#get-synonyms))

  ## Example

      iex> Meilisearch.Settings.get_synonyms("movies")
      {:ok, %{
        "wolverine" => [
          "xmen",
          "logan"
        ],
        "logan" => [
          "wolverine",
          "xmen"
        ],
        "wow" => [
          "world of warcraft"
        ]
      }}
  """
  @spec get_synonyms(String.t()) :: HTTP.response()
  def get_synonyms(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/synonyms")
  end

  @doc """
  Update synonyms.
  ([ref.](https://docs.meilisearch.com/reference/api/synonyms.html#update-synonyms))

  ## Example

      iex> Meilisearch.Settings.update_synonyms("movies", %{
        "wolverine" => ["xmen", "logan"],
        "logan" => ["wolverine", "xmen"],
        "wow" => ["world of warcraft"]
      })
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec update_synonyms(String.t(), any()) :: HTTP.response()
  def update_synonyms(index_uid, synonyms) do
    HTTP.put_request("indexes/#{index_uid}/settings/synonyms", synonyms)
  end

  @doc """
  Reset synonyms.
  ([ref.](https://docs.meilisearch.com/reference/api/synonyms.html#reset-synonyms))

  ## Example

      iex> Meilisearch.Settings.reset_synonyms("movies")
      {:ok, %{
        "taskUid" => 1,
        "indexUid" => "movies",
        "status" => "enqueued",
        "type" => "settingsUpdate",
        "enqueuedAt" => "2021-08-11T09:25:53.000000Z"
      }}
  """
  @spec reset_synonyms(String.t()) :: HTTP.response()
  def reset_synonyms(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/synonyms")
  end
end
