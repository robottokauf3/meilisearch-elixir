defmodule Meilisearch.VersionTest do
  use ExUnit.Case

  alias Meilisearch.Version

  test "version returns version infomation" do
    assert {:ok, %{"buildDate" => _, "commitSha" => _, "pkgVersion" => _}} = Version.get()
  end
end
