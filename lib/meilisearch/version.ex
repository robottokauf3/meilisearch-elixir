defmodule Meilisearch.Version do
  @moduledoc """
  Collection of functions used to retrive Meilisearch version information.

  [MeiliSearch Documentation - Version](https://docs.meilisearch.com/references/version.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Gets version information

  ## Example

      iex> Meilisearch.Version.get()
      {:ok, %{"commitDate" => "2020-04-29T09:05:31.455410849+00:00", "commitSha" => "UNKNOWN", "pkgVersion" => "0.10.1"}}

  """
  @spec get :: HTTP.response()
  def get do
    HTTP.get_request("version")
  end
end
