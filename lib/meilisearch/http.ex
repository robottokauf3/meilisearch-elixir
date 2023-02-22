defmodule Meilisearch.HTTP do
  @moduledoc """
  HTTPoison client wrapper
  """
  use HTTPoison.Base

  @type path :: String.t()

  @type success :: {:ok, any()}
  @type error :: {:error, integer(), any()}

  @type response :: success | error

  # Client API

  @spec get_request(String.t(), any, Keyword.t()) :: response()
  def get_request(url, headers \\ [], options \\ []) do
    url
    |> get(headers, options)
    |> handle_response()
  end

  @spec put_request(String.t(), any, any, Keyword.t()) :: response()
  def put_request(url, body, headers \\ [], options \\ []) do
    url
    |> put(body, headers, options)
    |> handle_response()
  end

  @spec patch_request(String.t(), any, any, Keyword.t()) :: response()
  def patch_request(url, body, headers \\ [], options \\ []) do
    url
    |> patch(body, headers, options)
    |> handle_response()
  end

  @spec post_request(String.t(), any, any, Keyword.t()) :: response()
  def post_request(url, body, headers \\ [], options \\ []) do
    url
    |> post(body, headers, options)
    |> handle_response()
  end

  @spec delete_request(String.t(), any, Keyword.t()) :: response()
  def delete_request(url, headers \\ [], options \\ []) do
    url
    |> delete(headers, options)
    |> handle_response()
  end

  # HTTPoison Callbacks

  def process_response_body(""), do: nil

  def process_response_body(body) do
    Jason.decode!(body)
  end

  def process_url(path) do
    base_url = Meilisearch.Config.endpoint()

    base_url
    |> URI.merge(path)
    |> to_string()
  end

  def process_request_body(""), do: ""
  def process_request_body(body), do: Jason.encode!(body)

  def process_request_headers(headers) do
    headers
    |> add_content_type_header()
    |> add_auth_header()
  end

  # Utils

  defp handle_response({:ok, %HTTPoison.Response{body: body, status_code: status_code}})
       when status_code in 400..599 do
    message =
      case body do
        nil -> ""
        body -> Map.get(body, "message")
      end

    {:error, status_code, message}
  end

  defp handle_response({:ok, %HTTPoison.Response{body: data}}) do
    {:ok, data}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, nil, reason}
  end

  defp add_content_type_header(headers) do
    [{"Content-Type", "application/json"} | headers]
  end

  defp add_auth_header(headers) do
    api_key = Meilisearch.Config.api_key()

    [{"Authorization", "Bearer #{api_key}"} | headers]
  end
end
