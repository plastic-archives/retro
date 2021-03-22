defmodule Retro.ConfigHelperTest do
  use ExUnit.Case, async: true

  import Retro.ConfigHelper

  describe "parse_phoenix_endpoint_url/1" do
    test "parse HTTPS url" do
      assert parse_phoenix_endpoint_url("https://example.com/") == [
               scheme: "https",
               host: "example.com",
               port: 443,
               path: "/"
             ]
    end

    test "parse HTTPS url without slash" do
      assert parse_phoenix_endpoint_url("https://example.com") == [
               scheme: "https",
               host: "example.com",
               port: 443,
               path: nil
             ]
    end

    test "parse HTTP url" do
      assert parse_phoenix_endpoint_url("http://example.com/") == [
               scheme: "http",
               host: "example.com",
               port: 80,
               path: "/"
             ]
    end

    test "parse HTTP url without slash" do
      assert parse_phoenix_endpoint_url("http://example.com") == [
               scheme: "http",
               host: "example.com",
               port: 80,
               path: nil
             ]
    end
  end

  describe "extract_host/1" do
    test "extract HTTPS" do
      assert extract_host("https://example.com/") == "example.com"
    end

    test "extract HTTP" do
      assert extract_host("http://example.com/") == "example.com"
    end
  end
end
