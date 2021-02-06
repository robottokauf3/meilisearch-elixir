defmodule Meilisearch.Indexes do
  @moduledoc """
  Collection of functions used to manage indexes.

  [MeiliSearch Documentation - Indexes](https://docs.meilisearch.com/references/indexes.html)
  """

  alias Meilisearch.HTTP

  @doc """
  List all indexes

  ## Example

      iex> Meilisearch.Indexes.list()
      {:ok, [
        %{
          "createdAt" => "2020-05-23T06:20:18.394281328Z",
          "name" => "meilisearch_test",
          "primaryKey" => nil,
          "uid" => "meilisearch_test",
          "updatedAt" => "2020-05-23T06:20:18.394292399Z"
        }
      ]}

  """
  @spec list :: HTTP.response()
  def list do
    HTTP.get_request("indexes")
  end

  @doc """
  Get information about an index

  ## Example

      iex> Meilisearch.Indexes.get("meilisearch_test")
      {:ok,
        %{
          "createdAt" => "2020-05-23T06:20:18.394281328Z",
          "name" => "meilisearch_test",
          "primaryKey" => nil,
          "uid" => "meilisearch_test",
          "updatedAt" => "2020-05-23T06:20:18.394292399Z"
        }
      }

  """
  @spec get(String.t()) :: HTTP.response()
  def get(uid) do
    HTTP.get_request("indexes/#{uid}")
  end

  @doc """
  Create an index

  `primary_key` can be passed as an option.

  ## Examples

      iex> Meilisearch.Indexes.create("meilisearch_test")
      {:ok,
        %{
          "createdAt" => "2020-05-23T06:20:18.394281328Z",
          "name" => "meilisearch_test",
          "primaryKey" => nil,
          "uid" => "meilisearch_test",
          "updatedAt" => "2020-05-23T06:20:18.394292399Z"
        }
      }

      iex> Meilisearch.create("meilisearch_test", primary_key: "key_name")
      {:ok,
        %{
          "createdAt" => "2020-05-23T06:20:18.394281328Z",
          "name" => "meilisearch_test",
          "primaryKey" => "key_name",
          "uid" => "meilisearch_test",
          "updatedAt" => "2020-05-23T06:20:18.394292399Z"
        }
      }
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
  Update an index with new primary key.  Will fail if primary key has already been set

  `primary_key` option is required.

  ## Examples

      iex> Meilisearch.Indexes.update("meilisearch_test", primary_key: "new_key")
      {:ok,
        %{
          "primaryKey" => "new_primary_key",
          "createdAt" => "2020-05-25T04:30:10.681720067Z",
          "name" => "meilisearch_test",
          "uid" => "meilisearch_test",
          "updatedAt" => "2020-05-25T04:30:10.685540577Z"
        }
      }
  """
  @spec update(String.t(), primary_key: String.t()) :: HTTP.response()
  def update(uid, opts \\ []) do
    with {:ok, primary_key} <- Keyword.fetch(opts, :primary_key),
         body <- %{primaryKey: primary_key} do
      HTTP.put_request("indexes/#{uid}", body)
    else
      _ -> {:error, "primary_key is required"}
    end
  end

  @doc """
  Delete an index

  ## Examples

      iex> Meilisearch.Indexes.delete("meilisearch_test")
      {:ok, nil}

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

      iex> Meilisearch.Indexes.exists?("meilisearch_test")
      {:ok, true}

      iex> Meilisearch.Indexes.exists?("nonexistent_index")
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
