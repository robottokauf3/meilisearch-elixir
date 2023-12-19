defmodule Meilisearch.HTTP do
  @moduledoc """
  Finch client wrapper
  """

  @type path :: String.t()

  @type success :: {:ok, any()}
  @type error :: {:error, integer(), any()}

  @type response :: success | error

  # Client API

  @spec get_request(String.t(), Keyword.t()) :: response()
  def get_request(url, params \\ []) do
    client()
    |> Req.get(url: url, headers: build_headers(), params: params)
    |> handle_response()
  end

  @spec put_request(String.t(), any, Keyword.t()) :: response()
  def put_request(url, body, params \\ []) do
    client()
    |> Req.put(url: url, headers: build_headers(), json: body, params: params)
    |> handle_response()
  end

  @spec patch_request(String.t(), any, Keyword.t()) :: response()
  def patch_request(url, body, params \\ []) do
    client()
    |> Req.patch(url: url, headers: build_headers(), json: body, params: params)
    |> handle_response()
  end

  @spec post_request(String.t(), any, Keyword.t()) :: response()
  def post_request(url, body, params \\ []) do
    client()
    |> Req.post(url: url, headers: build_headers(), json: body, params: params)
    |> handle_response()
  end

  @spec delete_request(String.t(), Keyword.t()) :: response()
  def delete_request(url, params \\ []) do
    client()
    |> Req.delete(url: url, headers: build_headers(), params: params)
    |> handle_response()
  end

  def client do
    Req.new(
      base_url: Meilisearch.Config.endpoint(),
      connect_options: Meilisearch.Config.connect_options()
    )
  end

  # Utils

  defp handle_response({:ok, %Req.Response{body: body, status: status_code}})
       when status_code in 400..599 do
    message =
      case(body) do
        nil -> ""
        "" -> ""
        body -> Map.get(body, "message")
      end

    {:error, status_code, message}
  end

  defp handle_response({:ok, %Req.Response{body: data}}) do
    {:ok, data}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, nil, reason}
  end

  defp build_headers do
    [] |> add_content_type_header() |> add_auth_header()
  end

  defp add_content_type_header(headers) do
    [{"Content-Type", "application/json"} | headers]
  end

  defp add_auth_header(headers) do
    api_key = Meilisearch.Config.api_key()

    [{"Authorization", "Bearer #{api_key}"} | headers]
  end
end
