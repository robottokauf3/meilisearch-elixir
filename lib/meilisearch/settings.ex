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
        "rankingRules" => [
          "typo",
          "words",
          "proximity",
          "attribute",
          "wordsPosition",
          "exactness"
        ],
        "attributesForFaceting" => [],
        "displayedAttributes" => ["*"],
        "distinctAttribute" => nil,
        "searchableAttributes" => ["*"],
        "stopWords" => [],
        "synonyms" => %{}
      }}
  """
  @spec get(String.t()) :: HTTP.response()
  def get(index_uid) do
    HTTP.get_request("indexes/#{index_uid}/settings")
  end

  @doc """
  Update settings.

  ## Example

      iex> Meilisearch.Settings.update("meilisearch_test", %{synonyms: %{alien: ["ufo"]}})
      {:ok, %{"updateId" => 1}}
  """
  @spec update(String.t(), any()) :: HTTP.response()
  def update(index_uid, settings \\ %{}) do
    HTTP.post_request("indexes/#{index_uid}/settings", settings)
  end

  @doc """
  Reset settings.

  ## Example

      iex> Meilisearch.Settings.reset("meilisearch_test")
      {:ok, %{"updateId" => 1}}
  """
  @spec reset(String.t()) :: HTTP.response()
  def reset(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/settings")
  end
end
