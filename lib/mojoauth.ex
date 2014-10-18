defmodule MojoAuth do
  use Timex

  @username_separator ":"
  @default_ttl 86400

  @moduledoc ~S"""
  Create and verify MojoAuth credentials

  ## Examples

      # Simple credentials test :ok
      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(secret: secret)
      iex> MojoAuth.test_credentials(credentials, secret)
      {:ok, nil}

      # Forged credentials test :invalid
      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(secret: secret)
      iex> MojoAuth.test_credentials([username: "foobar", password: credentials[:password]], secret)
      {:invalid, nil}

      # Credentials expire after default TTL of 1 day
      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(secret: secret)
      iex> use Timex
      iex> MojoAuth.test_credentials(credentials, secret, Date.now |> Date.universal |> Date.shift(days: 1, secs: 1) |> Date.convert(:secs)) # Pretend it's the future
      {:expired, nil}

      # Credentials can assert an identity
      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "foobar", secret: secret)
      iex> MojoAuth.test_credentials(credentials, secret)
      {:ok, "foobar"}

      # Forged credentials test :invalid
      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "doodah", secret: secret)
      iex> MojoAuth.test_credentials([username: "sometime:foobar", password: credentials[:password]], secret)
      {:invalid, "foobar"}

      # Credentials expire after default TTL of 1 day
      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "foobar", secret: secret)
      iex> use Timex
      iex> MojoAuth.test_credentials(credentials, secret, Date.now |> Date.universal |> Date.shift(days: 1, secs: 1) |> Date.convert(:secs)) # Pretend it's the future
      {:expired, "foobar"}
  """

  @doc "Create a new set of credentials for an asserted ID, given a desired TTL and shared secret"
  def create_credentials(id: id, secret: secret) do
    username = new_username(id)
    [username: username, password: sign(username, secret)]
  end
  def create_credentials(secret: secret) do
    create_credentials(id: nil, secret: secret)
  end

  @doc "Test that credentials are valid and current"
  def test_credentials([username: username, password: password], secret, timestamp \\ now |> Date.convert(:secs)) do
    [expiry, id] = username_elements(username)
    status = case sign(username, secret) do
      ^password -> status(String.to_integer(expiry), timestamp)
      _ -> :invalid
    end
    {status, id}
  end

  defp sign(message, secret) do
    :crypto.hmac(:sha, secret, message) |> :base64.encode
  end

  defp now do
    Date.now |> Date.universal
  end

  defp status(expiry, timestamp) when expiry > timestamp do
    :ok
  end
  defp status(expiry, timestamp) do
    :expired
  end

  defp username_elements(username) do
    case String.split(username, @username_separator, trim: true) do
      [expiry, id] -> [expiry, id]
      [expiry] -> [expiry, nil]
    end
  end

  defp new_username(id) do
    expiry_timestamp = now |> Date.shift(secs: @default_ttl) |> Date.convert(:secs)
    Enum.join([expiry_timestamp, id], @username_separator)
  end
end
