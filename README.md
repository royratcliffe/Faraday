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

## Usage

### Setting Up a Connection

```swift
let connection = Connection()
connection.URL = NSURL(string: "http://faraday-tests.herokuapp.com/")
connection.use(EncodeJSON.Handler())
connection.use(DecodeJSON.Handler())
connection.use(Logger.Handler())
connection.use(URLSession.Handler())
```

The URL's trailing slash is very important. Without it, merging URLs will
replace the entire path rather than just append the path. This is a 'feature'
associated with Apple's `NSURL` class.

## Swift Versus Ruby

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

