defmodule Meilisearch.Settings do
  @moduledoc """
  Collection of functions used to manage settings.

  [MeiliSearch Documentation - Settings](https://docs.meilisearch.com/references/settings.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get settings.

  ## Example

    iex> Meilisearch.Settings.get("meilisearch_test")
    {:ok,
      %{
        "displayedAttributes" => [ "*" ],
        "searchableAttributes" => [ "*" ],
        "filterableAttributes" => [],
        "sortableAttributes" => [],
        "rankingRules" => [
          "words",
          "typo",
          "proximity",
          "attribute",
          "sort",
          "exactness"
        ],
        "stopWords" => [],
        "synonyms" => %{},
        "distinctAttribute" => null,
        "typoTolerance" => %{
          "enabled" => true,
          "minWordSizeForTypos" => {
            "oneTypo" => 5,
            "twoTypos" => 9
          },
          "disableOnWords" => [],
          "disableOnAttributes" => []
        },
        "faceting" => %{ "maxValuesPerFacet" => 100 },
        "pagination" => %{ "maxTotalHits" => 1000 }
      }
    }
  """
  @spec get(String.t()) :: HTTP.response()
  def get(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings")
  end

  @doc """
  Update settings.

  ## Example

      iex> Meilisearch.Settings.update("meilisearch_test", %{synonyms: %{alien: ["ufo"]}})
      {:ok, %{"taskUid" => 1}}
  """
  @spec update(String.t(), any()) :: HTTP.response()
  def update(index_uid, settings \\ %{}) do
    HTTP.patch_request("indexes/#{index_uid}/settings", settings)
  end

  @doc """
  Reset settings.

  ## Example

      iex> Meilisearch.Settings.reset("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset(String.t()) :: HTTP.response()
  def reset(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings")
  end

  @doc """
  Get synonyms.

  ## Example

      iex> Meilisearch.Settings.get_synonyms("meilisearch_test")
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

  ## Example

      iex> Meilisearch.Settings.update_synonyms("meilisearch_test", %{alien: ["ufo"]})
      {:ok, %{"taskUid" => 1}}
  """
  @spec update_synonyms(String.t(), any()) :: HTTP.response()
  def update_synonyms(index_uid, synonyms) do
    HTTP.put_request("indexes/#{index_uid}/settings/synonyms", synonyms)
  end

  @doc """
  Reset synonyms.

  ## Example

      iex> Meilisearch.Settings.reset_synonyms("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset_synonyms(String.t()) :: HTTP.response()
  def reset_synonyms(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/synonyms")
  end

  @doc """
  Get stop-words.

  ## Example

      iex> Meilisearch.Settings.get_stop_words("meilisearch_test")
      {:ok, []}
  """
  @spec get_stop_words(String.t()) :: HTTP.response()
  def get_stop_words(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/stop-words")
  end

  @doc """
  Update stop-words.

  ## Example

      iex> Meilisearch.Settings.update_stop_words("meilisearch_test", ["the", "of", "to"])
      {:ok, %{"taskUid" => 1}}
  """
  @spec update_stop_words(String.t(), list(String.t())) :: HTTP.response()
  def update_stop_words(index_uid, stop_words) do
    HTTP.put_request("indexes/#{index_uid}/settings/stop-words", stop_words)
  end

  @doc """
  Reset stop-words.

  ## Example

      iex> Meilisearch.Settings.reset_stop_words("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset_stop_words(String.t()) :: HTTP.response()
  def reset_stop_words(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/stop-words")
  end

  @doc """
  Get ranking rules.

  ## Example

      iex> Meilisearch.Settings.get_ranking_rules("meilisearch_test")
      {:ok,
        ["typo",
        "words",
        "proximity",
        "attribute",
        "wordsPosition",
        "exactness"
        ]
      }
  """
  @spec get_ranking_rules(String.t()) :: HTTP.response()
  def get_ranking_rules(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/ranking-rules")
  end

  @doc """
  Update ranking rules.

  ## Example

      iex> Meilisearch.Settings.update_ranking_rules(
        "meilisearch_test",
        ["typo", "words", "proximity", "attribute"]
      )
      {:ok, %{"updateId" => 1}}
  """
  @spec update_ranking_rules(String.t(), list(String.t())) :: HTTP.response()
  def update_ranking_rules(index_uid, ranking_rules) do
    HTTP.put_request("indexes/#{index_uid}/settings/ranking-rules", ranking_rules)
  end

  @doc """
  Reset ranking rules.

  ## Example

      iex> Meilisearch.Settings.reset_ranking_rules("meilisearch_test")
      {:ok, %{"updateId" => 1}}
  """
  @spec reset_ranking_rules(String.t()) :: HTTP.response()
  def reset_ranking_rules(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/ranking-rules")
  end

  @doc """
  Get maxValuesPerFacet setting.

  ## Example

    iex> Meilisearch.Settings.get_faceting("meilisearch_test")
    {:ok,
      %{ "maxValuesPerFacet" => 100 }
    }
  """
  @spec get_faceting(String.t()) :: HTTP.response()
  def get_faceting(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/faceting")
  end

  @doc """
  Update maxValuesPerFacet setting.

  ## Example

      iex> Meilisearch.Settings.update_faceting(
        "meilisearch_test",
        %{ maxValuesPerFacet: 2 }
      )
      {:ok, %{"taskUid" => 1}}
  """
  @spec update_faceting(String.t(), map()) :: HTTP.response()
  def update_faceting(index_uid, faceting_settings) do
    HTTP.patch_request(
      "indexes/#{index_uid}/settings/faceting",
      faceting_settings
    )
  end

  @doc """
  Reset maxValuesPerFacet setting.

  ## Example

      iex> Meilisearch.Settings.reset_faceting("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset_faceting(String.t()) :: HTTP.response()
  def reset_faceting(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/faceting")
  end

  @doc """
  Get attributes for filtering & faceting.

  ## Example

      iex> Meilisearch.Settings.get_filterable_attributes("meilisearch_test")
      {:ok, [
        "genres",
        "directors",
        "release_date.year"
      ]}
  """
  @spec get_filterable_attributes(String.t()) :: HTTP.response()
  def get_filterable_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/filterable-attributes")
  end

  @doc """
  Update attributes for filtering & faceting.

  ## Example

      iex> Meilisearch.Settings.update_filterable_attributes(
        "meilisearch_test",
        ["title"]
      )
      {:ok, %{"taskUid" => 1}}
  """
  @spec update_filterable_attributes(String.t(), list(String.t())) :: HTTP.response()
  def update_filterable_attributes(index_uid, filterable_attributes) do
    HTTP.put_request(
      "indexes/#{index_uid}/settings/filterable-attributes",
      filterable_attributes
    )
  end

  @doc """
  Reset attributes for filtering & faceting.

  ## Example

      iex> Meilisearch.Settings.reset_filterable_attributes("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset_filterable_attributes(String.t()) :: HTTP.response()
  def reset_filterable_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/filterable-attributes")
  end

  @doc """
  Get distinct attribute.

  ## Example

      iex> Meilisearch.Settings.get_distinct_attribute("meilisearch_test")
      {:ok, "id"}
  """
  @spec get_distinct_attribute(String.t()) :: HTTP.response()
  def get_distinct_attribute(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/distinct-attribute")
  end

  @doc """
  Update distinct attribute.

  ## Example

      iex> Meilisearch.Settings.update_distinct_attribute("meilisearch_test", "id")
      {:ok, %{"taskUid" => 1}}
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

  ## Example

      iex> Meilisearch.Settings.reset_distinct_attribute("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset_distinct_attribute(String.t()) :: HTTP.response()
  def reset_distinct_attribute(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/distinct-attribute")
  end

  @doc """
  Get searchable attributes.

  ## Example

      iex> Meilisearch.Settings.get_searchable_attributes("meilisearch_test")
      {:ok, ["*"]}
  """
  @spec get_searchable_attributes(String.t()) :: HTTP.response()
  def get_searchable_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/searchable-attributes")
  end

  @doc """
  Update searchable attributes.

  ## Example

      iex> Meilisearch.Settings.update_searchable_attributes("meilisearch_test", ["title"])
      {:ok, %{"taskUid" => 1}}
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

  ## Example

      iex> Meilisearch.Settings.reset_searchable_attributes("meilisearch_test")
      {:ok, %{"updateId" => 1}}
  """
  @spec reset_searchable_attributes(String.t()) :: HTTP.response()
  def reset_searchable_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/searchable-attributes")
  end

  @doc """
  Get displayed attributes.

  ## Example

      iex> Meilisearch.Settings.get_displayed_attributes("meilisearch_test")
      {:ok, ["*"]}
  """
  @spec get_displayed_attributes(String.t()) :: HTTP.response()
  def get_displayed_attributes(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings/displayed-attributes")
  end

  @doc """
  Update displayed attributes.

  ## Example

      iex> Meilisearch.Settings.update_displayed_attributes("meilisearch_test", ["title"])
      {:ok, %{"taskUid" => 1}}
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

  ## Example

      iex> Meilisearch.Settings.reset_displayed_attributes("meilisearch_test")
      {:ok, %{"taskUid" => 1}}
  """
  @spec reset_displayed_attributes(String.t()) :: HTTP.response()
  def reset_displayed_attributes(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings/displayed-attributes")
  end
end
