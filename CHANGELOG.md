# Change Log

## [0.6.0](https://github.com/royratcliffe/faraday/tree/0.6.0)

Changes for Apple Swift version 3.0.2, amongst other minor adjustments.

- Merge branch 'feature/swift_3_0_2' into develop
- Replace conditional downcast to bridging conversion
- Swift 3.0.2 renames `Generator` to `Iterator`
- Added link to heartbeat tests
- Mark completion and authorisation methods as ‘discardable result’

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.5.4...0.6.0).

## [0.5.4](https://github.com/royratcliffe/faraday/tree/0.5.4)

- Added READ ME section on authorisation and chunked responses
- Added subsection on query values
- Added Using a Connection section
- Comment added to ping tests
- Use `setQuery(values:forName:)` to set query values
- Section about Rack stack
- Promote sub-sections
- Added READ-ME paragraph about customisation
- Removed Usage section
- Description of middleware stack building added
- Fix connection set-up example for Swift 3
- Fix outdated `NSURL` reference; Swift 3 uses `URL`
- More comments for `Connection` class
- Jazzy now uses `author` instead of `author_name`
- Disable code signing
- Xcode enables new warnings
- Upgrade checks by Xcode 8.2 (8C38)

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.5.3...0.5.4).

## [0.5.3](https://github.com/royratcliffe/faraday/tree/0.5.3)

- Merge branch 'feature/chunked_response' into develop
- Fixed chunked-response handling
- Removed negative error expectation from heartbeat test

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.5.2...0.5.3).

## [0.5.2](https://github.com/royratcliffe/faraday/tree/0.5.2)

- FIX: `Env.saveResponse` does not finish the response

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.5.1...0.5.2).

## [0.5.1](https://github.com/royratcliffe/faraday/tree/0.5.1)

- Explicitly cast body to dictionary or array when encoding JSON

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.5.0...0.5.1).

## [0.5.0](https://github.com/royratcliffe/faraday/tree/0.5.0)

- Explicit `@escaping` applies to capture parameters
- Capitalise initial returns comment sentence

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.4.5...0.5.0).

## [0.4.5](https://github.com/royratcliffe/faraday/tree/0.4.5)

- Open access for `URLSessionAdapter` and `URLSessionAdapter.Handler`

See [Full Change Log](https://github.com/royratcliffe/faraday/compare/0.4.4...0.4.5).

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
