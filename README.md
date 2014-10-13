[![Build Status](https://travis-ci.org/mojolingo/mojoauth.ex.svg?branch=develop)](http://travis-ci.org/mojolingo/mojoauth.ex)

# mojoauth

[MojoAuth](http://mojolingo.com/mojoauth) is a set of standard approaches to cross-app authentication based on [Hash-based Message Authentication Codes](http://en.wikipedia.org/wiki/Hash-based_message_authentication_code) (HMAC), inspired by ["A REST API For Access To TURN Services"](http://tools.ietf.org/html/draft-uberti-behave-turn-rest).

## Dependencies

* elixir
* mix

## Building

Simply run `mix compile`.

## Usage

```elixir
% Generate a shared secret
2> secret = MojoAuth.create_secret().
"eN1lvHK7cXPYFNwmEwZ3QNMAiCC651E5ikuEOj7+k4EMYTXb3XxXo3iBw4ScxqzJ+aH6aDCCe++LPVGRjgfl3Q=="

% Create temporary credentials
3> credentials = MojoAuth.create_credentials({:id, "foobar"}, {:secret, secret}).
[{:username,"1412629132:foobar"},
 {:password,"Q1RegXu0oYtm1UYqxRkegilugeM="}]

% Test credentials
4> MojoAuth.test_credentials([{:username, "1412629132:foobar"}, {:password,"Q1RegXu0oYtm1UYqxRkegilugeM="}], secret).
{:ok,"foobar"}
5> MojoAuth.test_credentials([{:username, "1412629132:foobar"}, {:password,"wrongpassword"}], secret).
{:invalid}

% 1 day later
6> MojoAuth.test_credentials([{:username, "1412629132:foobar"}, {:password,"Q1RegXu0oYtm1UYqxRkegilugeM="}], secret).
{:expired}
```

## Contributing

1. [Fork it](https://github.com/mojolingo/mojoauth.ex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
