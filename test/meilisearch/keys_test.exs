defmodule Meilisearch.KeysTest do
  use ExUnit.Case
  alias Meilisearch.Keys

  test "Keys.get returns public and private keys" do
    assert { :ok,
             %{
               "results" => [
                 %{ "actions" => [ "search" ] },
                 %{ "actions" => [ "*" ] }
               ]
             }
           } = Keys.get()
  end
end
