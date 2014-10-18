defmodule MojoAuth do
  use Timex

  @username_separator ":"
  @default_ttl 86400

  @moduledoc ~S"""
  Create and verify MojoAuth credentials

  ## Examples

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(secret: secret)
      iex> MojoAuth.test_credentials(credentials, secret)
      {:ok, nil}

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(secret: secret)
      iex> MojoAuth.test_credentials([username: 'foobar', password: credentials[:password]], secret)
      {:invalid}

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(secret: secret)
      iex> use Timex
      iex> MojoAuth.test_credentials(credentials, secret, Date.now |> Date.universal |> Date.shift(days: 1, secs: 1) |> Date.convert(:secs)) # Pretend it's the future
      {:expired, nil}

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "foobar", secret: secret)
      iex> MojoAuth.test_credentials(credentials, secret)
      {:ok, "foobar"}

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "doodah", secret: secret)
      iex> MojoAuth.test_credentials([username: 'foobar', password: credentials[:password]], secret)
      {:invalid}

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "foobar", secret: secret)
      iex> use Timex
      iex> MojoAuth.test_credentials(credentials, secret, Date.now |> Date.universal |> Date.shift(days: 1, secs: 1) |> Date.convert(:secs)) # Pretend it's the future
      {:expired, "foobar"}
  """

  @doc "Create a new set of credentials for an asserted ID, given a desired TTL and shared secret"
  def create_credentials(id: id, secret: secret) do
    expiry_timestamp = now |> Date.shift(secs: @default_ttl) |> Date.convert(:secs)
    username = Enum.join([expiry_timestamp, id], @username_separator)
    [username: username, password: sign(username, secret)]
  end
  def create_credentials(secret: secret) do
    create_credentials(id: nil, secret: secret)
  end

  @doc "Test that credentials are valid and current"
  def test_credentials(credentials, secret, timestamp \\ now |> Date.convert(:secs)) do
    password = credentials[:password]
    case sign(credentials[:username], secret) do
      ^password ->
        case String.split(credentials[:username], @username_separator, trim: true) do
          [expiry, id] ->
            {status(expiry, timestamp), id}
          [expiry] ->
            {status(expiry, timestamp), nil}
        end
      _ ->
        {:invalid}
    end
  end

  defp sign(message, secret) do
    :crypto.hmac(:sha, secret, message) |> :base64.encode
  end

  defp now do
    Date.now |> Date.universal
  end

  defp status(expiry, timestamp) do
    case String.to_integer(expiry) > timestamp do
      true -> :ok
      false -> :expired
    end
  end
end
