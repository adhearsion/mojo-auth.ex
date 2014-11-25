[![Build Status](https://travis-ci.org/mojolingo/mojo-auth.ex.svg?branch=develop)](http://travis-ci.org/mojolingo/mojo-auth.ex)

# mojoauth

[MojoAuth](http://mojolingo.github.io/mojo-auth/) is a set of standard approaches to cross-app authentication based on [Hash-based Message Authentication Codes](http://en.wikipedia.org/wiki/Hash-based_message_authentication_code) (HMAC), inspired by ["A REST API For Access To TURN Services"](http://tools.ietf.org/html/draft-uberti-behave-turn-rest).

## Dependencies

* elixir
* mix

## Building

Simply run `mix compile`.

## Usage

```elixir
# Generate a shared secret
iex(1)> secret = MojoAuth.create_secret
"y662KxTm1X4DvVCml+witUgwdJkNbR013JvFFUy6ZxuWozjHwND6vlIREoylJBh/9TiuSMpBqluNekWqN7kaPg=="

# Create temporary credentials
iex(2)> credentials = MojoAuth.create_credentials(id: "foobar", secret: secret)
[username: "1413748361:foobar", password: "sJgD0PLv892CUSfp1HL2td5NEeM="]

# Test credentials
iex(3)> MojoAuth.test_credentials(credentials, secret)
{:ok, "foobar"}
iex(4)> MojoAuth.test_credentials([username: "1412629132:foobar", password: "wrongpassword"], secret)
{:invalid, "foobar"}

# 1 day later
iex(5)> MojoAuth.test_credentials(credentials, secret)
{:expired, "foobar"}
```

## Contributing

1. [Fork it](https://github.com/mojolingo/mojo-auth.ex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
