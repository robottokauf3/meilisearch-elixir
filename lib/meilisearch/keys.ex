defmodule Meilisearch.Keys do
  @moduledoc """
  Collection of functions used to retrieve public and private key information.

  [MeiliSearch Documentation - Keys](https://docs.meilisearch.com/references/keys.html)
  """
  alias Meilisearch.HTTP

  @doc """
  List all existing API keys. Expired keys are included in the response, but deleted keys are not.
  ([ref.](https://docs.meilisearch.com/reference/api/keys.html#get-all-keys))

  ## Example
      iex> Meilisearch.Keys.list()
      {:ok, %{
        "results" => [
          %{
            "description" => "Manage documents: Products/Reviews API key",
            "key" => "d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4",
            "actions" => [
              "documents.add",
              "documents.delete"
            ],
            "indexes" => [
              "products",
              "reviews"
            ],
            "expiresAt" => "2021-12-31T23:59:59Z",
            "createdAt" => "2021-10-12T00:00:00Z",
            "updatedAt" => "2021-10-13T15:00:00Z"
          },
          %{
            "description" => "Default Search API Key (Use it to search from the frontend code)",
            "key" => "0a6e572506c52ab0bd6195921575d23092b7f0c284ab4ac86d12346c33057f99",
            "actions" => [
              "search"
            ],
            "indexes" => [
              "*"
            ],
            "expiresAt" => nil,
            "createdAt" => "2021-08-11T10:00:00Z",
            "updatedAt" => "2021-08-11T10:00:00Z"
          },
          %{
            "description" => "Default Admin API Key (Use it for all other operations. Caution! Do not share it on the client side)",
            "key" => "380689dd379232519a54d15935750cc7625620a2ea2fc06907cb40ba5b421b6f",
            "actions" => [
              "*"
            ],
            "indexes" => [
              "*"
            ],
            "expiresAt" => nil,
            "createdAt" => "2021-08-11T10:00:00Z",
            "updatedAt" => "2021-08-11T10:00:00Z"
          }
        ]
      }}
  """
  @spec list() :: HTTP.response()
  def list do
    HTTP.get_request("keys")
  end

  @doc """
  Get information on the specified key. Attempting to use this endpoint with a non-existent or deleted key will result in an error.
  ([ref.](https://docs.meilisearch.com/reference/api/keys.html#get-one-key))

  ## Example
      iex> Meilisearch.Keys.get("d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4")
      {:ok, %{
        "description" => "Manage documents: Products/Reviews API key",
        "key" => "d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4",
        "actions" => [
          "documents.add",
          "documents.delete"
        ],
        "indexes" => [
          "products",
          "reviews"
        ],
        "expiresAt" => "2021-12-31T23:59:59Z",
        "createdAt" => "2021-10-12T00:00:00Z",
        "updatedAt" => "2021-10-13T15:00:00Z"
      }}
  """
  @spec get(String.t()) :: HTTP.response()
  def get(key) do
    HTTP.get_request("keys/#{key}")
  end

  @doc """
  Create an API key with the provided description, permissions, and expiration date.
  ([ref.](https://docs.meilisearch.com/reference/api/keys.html#create-a-key))

  Only the `indexes`, `actions`, and `expiresAt` fields are mandatory.

  ## Example
      iex> Meilisearch.Keys.create(%{
        "description" => "Add documents: Products API key",
        "actions" => ["documents.add"],
        "indexes" => ["products"],
        "expiresAt" => "2042-04-02T00:42:42Z"
      })
      {:ok, %{
        "description" => "Add documents: Products API key",
        "key" => "d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4",
        "actions" => [
            "documents.add"
        ],
        "indexes" => [
            "products"
        ],
        "expiresAt" => "2021-11-13T00:00:00Z",
        "createdAt" => "2021-11-12T10:00:00Z",
        "updatedAt" => "2021-11-12T10:00:00Z"
    }}
  """
  @spec create(any) :: HTTP.response()
  def create(opts) do
    HTTP.post_request("keys", opts)
  end

  @doc """
  Update the description, permissions, or expiration date of an API key.
  ([ref.](https://docs.meilisearch.com/reference/api/keys.html#update-a-key))

  ## Example
      iex> Meilisearch.Keys.update("d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4", %{
        "description" => "Manage documents: Products/Reviews API key",
        "actions" => [
          "documents.add",
          "documents.delete"
        ],
        "indexes" => [
          "products",
          "reviews"
        ],
        "expiresAt" => "2042-04-02T00:42:42Z"
      })
      {:ok, %{
        "description" => "Manage documents: Products/Reviews API key",
        "key" => "d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4",
        "actions" => [
            "documents.add",
            "documents.delete"
        ],
        "indexes" => [
            "products",
            "reviews"
        ],
        "expiresAt" => "2021-12-31T23:59:59Z",
        "createdAt" => "2021-11-12T10:00:00Z",
        "updatedAt" => "2021-10-12T15:00:00Z"
      }}
  """
  @spec update(String.t(), any) :: HTTP.response()
  def update(key, opts) do
    HTTP.patch_request("keys/#{key}", opts)
  end

  @doc """
  Delete the specified API key.
  ([ref.](https://docs.meilisearch.com/reference/api/keys.html#delete-a-key))

  ## Example
      iex> Meilisearch.Keys.delete("d0552b41536279a0ad88bd595327b96f01176a60c2243e906c52ac02375f9bc4")
      {:ok, nil}
  """
  @spec delete(String.t()) :: HTTP.response()
  def delete(key) do
    HTTP.delete_request("keys/#{key}")
  end
end
