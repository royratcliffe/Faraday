
[faraday]:https://github.com/lostisland/faraday
[rack]:https://github.com/rack/rack
[rule-them-all]:http://www.intridea.com/blog/2012/3/12/faraday-one-http-client-to-rule-them-all

One HTTP client to [rule them all][rule-them-all], one client to find them, one
client to bring them all, and in the _brightness_ bind them. The Swift Faraday
framework is a modular HTTP client library heavily inspired by Ruby
[Faraday][faraday] which in turn was heavily inspired by [Rack][rack]. “This
mess is gonna get raw, like sushi. So, haters to the left.”

The framework provides a common interface over many adapters, adopting the
concept of Rack middleware when processing the HTTP request-response cycle.
When you build a connection, you build a stack of middleware elements for
processing the requests and responses.

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

