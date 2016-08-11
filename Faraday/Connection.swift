// Faraday Connection.swift
//
// Copyright © 2015, 2016, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

import Foundation

/// Represents a connection over which you can run HTTP requests and receive
/// their corresponding HTTP responses. Set up the connection first using
/// middleware. Use an _adapter_ as the last item of middleware for actually
/// performing the request in some adapter-dependent way; adapters perform the
/// request then subsequently decode the adapter-dependent response.
///
/// Connections manage request defaults such as the URL, including query items,
/// and headers. All new requests receive the connection defaults, the default
/// URL and headers.
public class Connection {

  public init() {}

  public var url: URL?

  public var headers = Headers()

  var builder = RackBuilder()

  /// Uses the given middleware in the connection stack. Order matters. The
  /// first piece of middleware will be the first to see the request but the
  /// last to see the response. The last and deepest piece of middleware must be
  /// an adapter of some kind that knows how to interpret the request in some
  /// platform-dependent way and asynchronously finish the response at some
  /// later time. Responses start off unfinished.
  public func use(handler: RackHandler) {
    builder.use(handler: handler)
  }

  var app: App {
    return builder.app
  }

  /// Defines the capture signature for request builders. Running a request
  /// accepts a capture. The capture builds the new request by setting up its
  /// URL, its headers and if necessary its body.
  public typealias RequestBuilder = (Request) -> Void

  /// Runs a GET request.
  public func get(path: String? = nil, requestBuilder: RequestBuilder? = nil) -> Response {
    return runRequest(method: "GET", path: path, requestBuilder: requestBuilder)
  }

  /// Runs a HEAD request.
  public func head(path: String? = nil, requestBuilder: RequestBuilder? = nil) -> Response {
    return runRequest(method: "HEAD", path: path, requestBuilder: requestBuilder)
  }

  /// Runs a DELETE request.
  public func delete(path: String? = nil, requestBuilder: RequestBuilder? = nil) -> Response {
    return runRequest(method: "DELETE", path: path, requestBuilder: requestBuilder)
  }

  /// Runs a POST request.
  public func post(path: String? = nil, requestBuilder: RequestBuilder? = nil) -> Response {
    return runRequest(method: "POST", path: path, requestBuilder: requestBuilder)
  }

  /// Runs a PUT request.
  public func put(path: String? = nil, requestBuilder: RequestBuilder? = nil) -> Response {
    return runRequest(method: "PUT", path: path, requestBuilder: requestBuilder)
  }

  /// Runs a PATCH request.
  public func patch(path: String? = nil, requestBuilder: RequestBuilder? = nil) -> Response {
    return runRequest(method: "PATCH", path: path, requestBuilder: requestBuilder)
  }

  /// Builds a request using the given method, then builds a response using the
  /// middleware. Answers the resulting unfinished response object. Requests
  /// always run asynchronously.
  /// - parameter method: String specifying the request method.
  /// - parameter requestBuilder: Capture for building the request.
  /// - returns: Unfinished response.
  public func runRequest(method: String,
                         path: String? = nil,
                         requestBuilder: RequestBuilder? = nil) -> Response {
    return run(request: buildRequest(method: method, path: path, requestBuilder: requestBuilder))
  }

  /// Runs an arbitrary request over the connection without any request
  /// building. This assumes that the request has already been fully built up,
  /// ready to run.
  public func run(request: Request) -> Response {
    return buildResponse(request: request)
  }

  /// Builds a response based on the request. Delegates to the Rack builder.
  func buildResponse(request: Request) -> Response {
    return builder.buildResponse(connection: self, request: request)
  }

  /// Builds a request based on the given method. Sets up the initial request
  /// using the connection's defaults including its URL and headers. Finally
  /// sends the request to the given request builder for further configuration.
  /// - parameter method: String specifying the request method.
  /// - parameter requestBuilder: Capture for building the request.
  ///
  /// In the Ruby implementation, the connection shares responsibility for
  /// building the request with the Rack builder. Not so here.
  public func buildRequest(method: String,
                           path: String? = nil,
                           requestBuilder: RequestBuilder? = nil) -> Request {
    let request = Request()
    request.method = method
    if let url = url {
      request.url = URL(string: path ?? ".", relativeTo: url)
    } else {
      request.url = URL(string: path ?? ".")
    }
    request.headers = headers
    requestBuilder?(request)
    return request
  }

}
