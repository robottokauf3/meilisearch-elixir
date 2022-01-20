defmodule Meilisearch.VersionTest do
  use ExUnit.Case

  alias Meilisearch.Version

  test "version returns version infomation" do
    assert {:ok,
            %{
              "commitSha" => _,
              "commitDate" => _,
              "pkgVersion" => _
            }} = Version.get()
  end
end
