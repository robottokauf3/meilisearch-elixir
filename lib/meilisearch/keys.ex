defmodule Meilisearch.Keys do
  @moduledoc """
  Collection of functions used to retrieve public and private key information.

  [MeiliSearch Documentation - Keys](https://docs.meilisearch.com/references/keys.html)
  """
  alias Meilisearch.HTTP

  @doc """
  Get public and private key information.

  ## Example
      iex> Meilisearch.Keys.get()
      {:ok,
        %{
          "results" => [
            %{ 
              "name" => null,
              "description" => "Manage documents: Products/Reviews API key",
              "key" => "d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4",
              "uid" => "6062abda-a5aa-4414-ac91-ecd7944c0f8d",
              "actions" => [
                "documents.add",
                "documents.delete"
              ],
              "indexes" => [ "products", "reviews" ],
              "expiresAt" => "2021-12-31T23:59:59Z",
              "createdAt" => "2021-10-12T00:00:00Z",
              "updatedAt" => "2021-10-13T15:00:00Z"
            },
            %{
              "name" => "Default Search API Key",
              "description" => "Use it to search from the frontend code",
              "key" => "0a6e572506c52ab0bd6195921575d23092b7f0c284ab4ac86d12346c33057f99",
              "uid" => "74c9c733-3368-4738-bbe5-1d18a5fecb37",
              "actions" => [ "search" ],
              "indexes" => [ "*" ],
              "expiresAt" => null,
              "createdAt" => "2021-08-11T10:00:00Z",
              "updatedAt" => "2021-08-11T10:00:00Z"
            },
            %{
              "name" => "Default Admin API Key",
              "description" => "Use it for anything that is not a search operation. Caution! Do not expose it on a public frontend",
              "key" => "380689dd379232519a54d15935750cc7625620a2ea2fc06907cb40ba5b421b6f",
              "uid" => "20f7e4c4-612c-4dd1-b783-7934cc038213",
              "actions" => [ "*" ],
              "indexes" => [ "*" ],
              "expiresAt" => null,
              "createdAt" => "2021-08-11T10:00:00Z",
              "updatedAt" => "2021-08-11T10:00:00Z"
            }],
            "offset" => 0,
            "limit" => 3,
            "total" => 7
            }
  """
  @spec get() :: HTTP.response()
  def get do
    HTTP.get_request("keys")
  end
end
