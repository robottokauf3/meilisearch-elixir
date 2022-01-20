defmodule Meilisearch.Version do
  @moduledoc """
  Collection of functions used to retrive Meilisearch version information.

  [MeiliSearch Documentation - Version](https://docs.meilisearch.com/references/version.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Gets version information
  ([ref.](https://docs.meilisearch.com/reference/api/version.html#get-version-of-meilisearch))

  ## Example

      iex> Meilisearch.Version.get()
      {:ok, %{
        "commitSha" => "b46889b5f0f2f8b91438a08a358ba8f05fc09fc1",
        "commitDate" => "2019-11-15T09:51:54.278247+00:00",
        "pkgVersion" => "0.1.1"
      }}

  """
  @spec get :: HTTP.response()
  def get do
    HTTP.get_request("version")
  end
end
