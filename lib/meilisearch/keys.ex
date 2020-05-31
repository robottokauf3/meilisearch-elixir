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
          "private" => "abcdefghijklmnopqrstuvwxyz1234567890",
          "public" => "1234567890abcdefghijklmnopqrstuvwxyz"
        }
      }
  """
  @spec get() :: HTTP.response()
  def get do
    HTTP.get_request("keys")
  end
end
