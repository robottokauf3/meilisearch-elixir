defmodule Meilisearch.KeysTest do
  use ExUnit.Case
  alias Meilisearch.Keys

  test "Keys.get returns public and private keys" do
    assert {
             :ok,
             %{
               "private" => _,
               "public" => _
             }
           } = Keys.get()
  end
end
