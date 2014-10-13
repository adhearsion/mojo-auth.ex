defmodule MojoAuth do
  @doc ~S"""
  Create a new set of credentials for an asserted ID, given a desired TTL and shared secret

  ## Examples

      iex> secret = "eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="
      iex> credentials = MojoAuth.create_credentials({:secret, secret})
      iex> MojoAuth.test_credentials(credentials, secret)
      {:ok, nil}

  """
  def create_credentials({:secret, secret}) do
    secret
  end

  def test_credentials(credentials, secret) do
    {:ok, nil}
  end
end
