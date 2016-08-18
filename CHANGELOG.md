# Change Log

## [0.4.4](https://github.com/royratcliffe/faraday/tree/0.4.4)

- Adapter has open access

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.4.3...0.4.4).

## [0.4.3](https://github.com/royratcliffe/faraday/tree/0.4.3)

- Response on-complete callback escapes
- Middleware and Response.Middleware have `open` access

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.4.2...0.4.3).

## [0.4.2](https://github.com/royratcliffe/faraday/tree/0.4.2)

- Allow ping test 60 seconds to respond
- Apply String(describing:) to Any
- Use [String: String] for headers
- NSURLQueryItem to URLQueryItem
- AnyObject to Any

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.4.1...0.4.2).

## [0.4.1](https://github.com/royratcliffe/faraday/tree/0.4.1)

- Wait 30 seconds, at least, for the ping
- Overload Headers auth() methods, basic or token
- Fix Travis configuration for Xcode 8
- Use @import in Objective-C header
- Removed redundant let in `let _ =`

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.4.0...0.4.1).

## [0.4.0](https://github.com/royratcliffe/faraday/tree/0.4.0)

- Sub-folders renamed to Sources and Tests
- Merge branch 'feature/swift_3_0' into develop
- Allow for conditional binding cascades
- Lower-case enumerator value, timedOut
- Assign nil components for nil request paths
- Use "." rather "" for no path
- Use Error rather than NSError or ErrorProtocol

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.3.3...0.4.0).

## [0.3.3](https://github.com/royratcliffe/faraday/tree/0.3.3)

- Remove Gemfile and lock
- Merge branch 'release/0.3.2' into develop

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.3.2...0.3.3).

## [0.3.2](https://github.com/royratcliffe/faraday/tree/0.3.2)

- Merge branch 'feature/swift_2_3' into develop
- Disable conditional_binding_cascade SwiftLint rule
- ++ deprecated
- Xcode 8.x upgrade
- Whole-module optimisation
- Migrate to Swift 2.3 using Xcode 8 beta 3 (8S174q)

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.3.1...0.3.2).

## [0.3.1](https://github.com/royratcliffe/faraday/tree/0.3.1)

- Test ResponseOperation, one ping only
- ResponseOperation class

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.3.0...0.3.1).

## [0.1.x](https://github.com/royratcliffe/faraday/tree/0.2.0)

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
- Travis CI support; fix tests for Travis
- Jazzy set-up

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.1.0...0.2.0).
