// Faraday RackBuilder.swift
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

/// Builds a stack of middleware by stacking rack handlers. The handlers know
/// how to instantiate their associated pieces of middleware when building a
/// response. The builder constructs a nested stack of closures which accept an
/// environment and answer an unfinished response; and build their middleware
/// in-between. Connection objects use a rack builder to manage the middleware
/// stack and build responses from the stack.
class RackBuilder {

  var handlers = [RackHandler]()

  func use(handler: RackHandler) {
    handlers.append(handler)
  }

  /// Constructs the response. Runs when the adapter asks for the response at
  /// the bottom of the Rack builder stack, i.e. when the adapter calls
  /// `app(env)`. This last piece of middleware simply constructs a new
  /// response, attaches it to the environment and returns back up the
  /// middleware application stack.
  lazy var app: App = {
    return self.toApp { env in
      let response = Response()
      env.response = response
      return response
    }
  }()

  func toApp(innerApp: App) -> App {
    return handlers.reverse().reduce(innerApp) { app, handler -> App in
      return { env -> Response in
        handler.build(app).call(env)
      }
    }
  }

  func buildResponse(connection: Connection, request: Request) -> Response {
    return app(buildEnv(connection, request: request))
  }

  func buildEnv(connection: Connection, request: Request) -> Env {
    let env = Env()
    env.request = request
    return env
  }

}
