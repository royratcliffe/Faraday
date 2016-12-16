[![Travis](https://img.shields.io/travis/royratcliffe/Faraday/master.svg)](https://travis-ci.org/royratcliffe/Faraday)
[![CocoaPods](https://img.shields.io/cocoapods/v/Faraday.svg)](https://cocoapods.org/pods/Faraday)
[![CocoaDocs](https://img.shields.io/cocoapods/metrics/doc-percent/Faraday.svg)](http://cocoadocs.org/docsets/Faraday)

# Faraday for Swift

[faraday]:https://github.com/lostisland/faraday
[rack]:https://github.com/rack/rack
[rule-them-all]:http://www.intridea.com/blog/2012/3/12/faraday-one-http-client-to-rule-them-all

Faraday is a HTTP client for Swift. Its two main goals are: flexibility and thinness.

Flexibility because connections between clients and servers are complicated
affairs. They need breaking down into manageable pieces. Faraday does this by
adopting the same approach that server-side software architectures typically
take, in one form or another: a middle-ware stack. Requests and responses pass
through a stack of middle-ware components that prepare the request for
transmission and subsequently prepare the response for usage within the client
application. On set-up, you configure the connection's middleware components and
presto, the middle-ware handles your connection's request set-ups and response
tear-downs. The application only needs to examine the cooked results without
getting its hands dirty with the messing ingredients—to use a cuisine metaphor.

Thinness because the framework does its job and no more. It imposes

- no threading model,
- performs no special tricks to make things work,
- invokes no legacy methods,
- has no static managers,
- no background tasks, or special delegate protocols,
- no wrappers around existing Foundation classes,
- no secret dispatch queues,
- no bouncing messages off the notification centre,
- no confusing collections of closures to override.
 
In short, it tries to keep out of the way; smelling fresh and clean.

Faraday aspires to be one HTTP client to [rule them all][rule-them-all] like its
Ruby counterpart. The Swift Faraday framework is a modular HTTP client library
heavily inspired by Ruby [Faraday][faraday] which, in turn, was heavily inspired
by [Rack][rack]. The framework provides a common interface over many adapters,
adopting the concept of Rack middle-ware when processing the HTTP
request-response cycle.  When you build a connection, you build a stack of
middleware elements for processing the requests and responses.

The following describes how to use a basic connection, but you can add your own
middleware to customise your connections. See
[Faraday HAL](https://github.com/royratcliffe/FaradayHAL) for example. It
includes additional middleware handlers for using Hypertext Application Language
(HAL) over your HTTP connections.

## Setting Up a Connection

```swift
let connection = Connection()
connection.url = URL(string: "http://faraday-tests.herokuapp.com/")
connection.use(handler: EncodeJSON.Handler())
connection.use(handler: DecodeJSON.Handler())
connection.use(handler: Logger.Handler())
connection.use(handler: URLSessionAdapter.Handler())
```

The URL's trailing slash is very important. Without it, merging URLs will
replace the entire path rather than just append the path. This is a 'feature'
associated with Apple's `URL` class.

The above code builds a logged JSON-based connection using Apple's `URLSession`
adapter. Requests first see the encode-JSON handler which encodes the request
body using JSON serialisation, from a dictionary to a JSON-encoded string. Then
the JSON-decoder sees the request but does nothing; the decoder only handles the
response when it arrives. Next, the logger handler sees the request and dumps
its details to the debug console using `NSLog`. Finally, the URL session adapter
sees the request and runs it.

When the response arrives, the response body and headers pass back _up_ through
the middleware stack. The logger logs the response. The decoder converts the
response body from JSON to a dictionary. Finally, the encoder sees the response
and does nothing because it only cares about the request. The outcome arrives
with the `Response` object, asynchronously.

Handling requests and responses using middleware mimicks the typical way that
server-side software handles requests and responses. It helps to decompose the
complicated affair. Different elements of the stack focus on their own
particular aspect of the interaction. The "Rack stack" is a useful software
decomposition tool for handling the request-response cycle, server side _and_
client side.

## Using a Connection

Once you set up a connection with a base URL and middleware, you can use it to
run requests: gets, heads, deletes, posts, puts, patches, or any other method.

For example, you can run a `GET` request using the connection as follows:

```swift
_ = connection.get(path: "path/to/resource").onComplete { env in
  guard let response = env.response else { return }
  // Handle the unwrapped response. It contains the response status,
  // response headers and response body.
}
```

This runs an asynchronous `GET` request by adding `path/to/resource` to the base
URL. Note that the completion capture runs asynchronously in another thread, the
one allocated by iOS for the associated URL session data task. Bounce it to
another dispatch queue if necessary.

### Query Values

Requests often include parameters, or query values. Set up any parameters needed
for the request by supplying a request handler to the run-request method, as
follows.

```swift
let response = connection.post { request in
  request.setQuery(values: ["world"], forName: "hello")
  // Do other things to configure the request, e.g. adjust headers, add
  // authentication.
}
// We have the response, but the response is not yet complete. It exists as a
// placeholder until completion. The request runs asynchronously, as does its
// corresponding response.
_ = response.onComplete { env in
  guard let response = env.response else { return }
  let body = response.body as? NSDictionary
}
```

In this case, the post request has no addition path provided. It uses the base
URL only, but it will add parameters to the URL, i.e. literally `?hello=world`
will appear at the end of the request URL. The request permits multiple values
for the same name, hence set query _values_.

### Authorisation

You can use request handlers to set up request authorisation. Faraday has the
two commonly-used authorisation methods baked in: basic and token
authorisation. The following configures one particular request with basic
authorisation, a login and a password.

```swift
let response = connection.get { request in
  request.path = "path/to/resource"
  request.body = ["ping": "pong"]
  _ = request.headers.auth(login: "login", pass: "pass")
  // The headers for this request will now include the following basic authorisation.
  // Authorization: Basic bG9naW46cGFzcw==
}
```

You can set up the connection itself with authorisation, so that all requests
carry the authorisation header. Access the connection headers using
`connection.headers`; these become the default headers for all
requests. Individual request headers merge with and override the defaults.

Token authorisation works similarly, only the arguments differ, i.e.

```swift
_ = request.headers.auth(token: "abcdef", options: ["foo": "bar"])
```

and the request headers will include:

```text
Authorization: Token token=abcdef,foo=bar
```

It works for connections as well as individual requests.

### Chunked Responses

The URL session adapter handles chunked responses. This is where the server
sends multiple responses for the same request. Underneath, the HTTP
request-response cycle is just a temporary TCP-stream connection. For chunked
responses however, the server holds the connection open and delivers multiple
responses. For each response chunk, the server sends the length of the chunk and
the chunk itself.

For chunked transfers, you set up and use a Faraday connection as normal, only
the response completes multiple times for each chunk. See the heartbeat tests
for a detailed example of chunked transfers.

# Swift Versus Ruby

There are some important differences between Swift Faraday and Ruby Faraday.
For one thing, Swift only handles asynchronous responses. Requests become
unfinished responses synchronously, but the request runs over the adapter
_asynchronously_ in another thread. Later, when the request succeeds or fails,
the response finishes. Finished responses invoke their on-complete handlers in
reverse middleware stack order.

Construction is another difference. Swift does not conveniently allow dynamic
instantiation from class to instance. You cannot provide a string and get an
instance. There are ways around this for Swift version 2, but none that does
not involve Objective-C. Instead, middleware components define an embedded
class by convention: a rack handler. Instances of this class or its sub-classes
know how to build a middleware instance given a Rack application.

