defmodule Meilisearch.Health do
  @moduledoc """
  Collection of functions used to retrive Meilisearch health information.

  [MeiliSearch Documentation - Health](https://docs.meilisearch.com/references/health.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get the health of Meilisearch instance.
  ([ref.](https://docs.meilisearch.com/reference/api/health.html#get-health))

  ## Example

      # Healthy
      iex> Meilisearch.Health.get()
      {:ok, %{"status" => "available"}}

      # Unhealthy
      iex> Meilisearch.Health.get()
      {:error, 503, "Server is in maintenance, please try again later"}
  """
  @spec get :: HTTP.response()
  def get do
    HTTP.get_request("health")
  end

  @doc """
  Retrieve the health of the instance as a boolean value.

  ## Example

      iex> Meilisearch.Health.healthy?()
      true
  """
  @spec healthy? :: boolean
  def healthy? do
    case get() do
      {:ok, %{"status" => "available"}} -> true
      _ -> false
    end
  end
end
