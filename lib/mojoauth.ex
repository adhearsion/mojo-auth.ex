defmodule MojoAuth do
  @doc ~S"""
  Create a new set of credentials for an asserted ID, given a desired TTL and shared secret

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
      iex> credentials = MojoAuth.create_credentials(id: "foobar", secret: secret)
      iex> MojoAuth.test_credentials(credentials, secret)
      {:ok, "foobar"}

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials(id: "doodah", secret: secret)
      iex> MojoAuth.test_credentials([username: 'foobar', password: credentials[:password]], secret)
      {:invalid}
  """
  def create_credentials(id: id, secret: secret) do
    username = Enum.join(["foobar", id], ":")
    [username: username, password: sign(username, secret)]
  end
  def create_credentials(secret: secret) do
    create_credentials(id: nil, secret: secret)
  end

  def test_credentials(credentials, secret) do
    password = credentials[:password]
    case sign(credentials[:username], secret) do
      ^password ->
        case String.split(credentials[:username], ":", trim: true) do
          [expiry, id] ->
            {:ok, id}
          [expiry] ->
            {:ok, nil}
        end
      _ ->
        {:invalid}
    end
  end

  defp sign(message, secret) do
    :base64.encode(:crypto.hmac(:sha, secret, message))
  end
end
