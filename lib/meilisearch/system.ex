defmodule Meilisearch.System do
  @moduledoc """
  Collection of functions used to retrieve extended information about hardware usage by Meilisearch.

  [MeiliSearch Documentation - System Information](https://docs.meilisearch.com/references/sys-info.html)
  """
  alias Meilisearch.HTTP

  @doc """
  Get system information.

  ## Example
      iex> Meilisearch.Keys.get()
      {:ok,
      %{
        "global" => %{
          "inputData" => 0,
          "outputData" => 0,
          "totalMemory" => 0,
          "totalSwap" => 0,
          "usedMemory" => 0,
          "usedSwap" => 0
        },
        "memoryUsage" => nil,
        "process" => %{"cpu" => 0.0, "memory" => 0},
        "processorUsage" => [0.0, 0.0, 0.0, 0.0]
      }}
  """
  @spec info() :: HTTP.response()
  def info do
    HTTP.get_request("sys-info")
  end

  @doc """
  Get system information with human-readable units.

  ## Example
      iex> Meilisearch.Keys.get()
      {:ok,
      %{
        "global" => %{
          "inputData" => "0 B",
          "outputData" => "0 B",
          "totalMemory" => "0 B",
          "totalSwap" => "0 B",
          "usedMemory" => "0 B",
          "usedSwap" => "0 B"
        },
        "memoryUsage" => "NaN %",
        "process" => %{"cpu" => "None", "memory" => "None"},
        "processorUsage" => ["0.0 %", "0.0 %", "0.0 %", "0.0 %"]
      }}
  """
  @spec info_pretty() :: HTTP.response()
  def info_pretty do
    HTTP.get_request("sys-info/pretty")
  end
end
