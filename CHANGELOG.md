# Change Log

## [0.1.x](https://github.com/royratcliffe/faraday/tree/0.1.11)

Initial versions with various patches for:

- Weakly retain expectation (fix tests)
- Token and basic authorisation
- Fix for response retaining `env` before invoking call-backs
- Using the given dispatch queue (fix)
- Response success or failure using `onSuccess` or `onFailure`
- URL session handler sets up configuration and session
- Make `buildRequest` method public
- Invoke `runRequest(request)` from `runRequest(method, path, requestBuilder)`
- Make `buildResponse` behaviour available for `Connection`s
- Variant of `Response`'s `onComplete` method: with dispatch queue
- Ping tests use optional `path` argument
- Request runners accept optional `path` argument
- Travis CI support
- Jazzy set-up

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.1.0...0.1.11).
