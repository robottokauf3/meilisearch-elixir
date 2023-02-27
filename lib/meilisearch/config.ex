defmodule Meilisearch.Config do
  @moduledoc """
  Library configuration helpers
  """

  @default_endpoint "http://127.0.0.1:7700"
  @default_api_key ""
  @default_connect_options []

  @spec endpoint :: String.t()
  def endpoint do
    get(:endpoint, @default_endpoint)
  end

  @spec api_key :: String.t()
  def api_key do
    get(:api_key, @default_api_key)
  end

  def connect_options do
    Application.get_env(:meilisearch, :connect_options, @default_connect_options)
  end

  @spec get(atom, String.t()) :: nil | String.t()
  def get(key, default \\ "") do
    {_key, value} =
      {key, default}
      |> get_application_env()
      |> get_system_env()

    value
  end

  defp get_application_env({key, default}) do
    {key, Application.get_env(:meilisearch, key, default)}
  end

  defp get_system_env({key, default}) do
    normalized_key = normalize_key(key)
    {key, System.get_env(normalized_key, to_string(default))}
  end

  defp normalize_key(key) do
    "meilisearch_#{key}"
    |> to_string
    |> String.upcase()
  end
end
