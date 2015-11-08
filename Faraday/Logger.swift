// Faraday Logger.swift
//
// Copyright © 2015, Roy Ratcliffe, Pioneering Software, United Kingdom
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

public class Logger: Response.Middleware {

  public override func call(env: Env) -> Response {
    let method = env.request?.method ?? "[METHOD]"
    let URLString = (env.request?.URL ?? NSURL()).absoluteString
    Logger.log("\(method) \(URLString)")
    Logger.log("request", headers: env.request?.headers)
    Logger.log("request", body: env.request?.body)
    return super.call(env)
  }

  public override func onComplete(env: Env) {
    if let status = env.response?.status {
      Logger.log("Status: \(String(status))")
    }
    Logger.log("response", headers: env.response?.headers)
    Logger.log("response", body: env.response?.body)
  }

  static func log(prefix: String, headers: [NSObject: AnyObject]?) {
    if let headers = headers {
      for (key, value) in headers {
        Logger.log("\(prefix) \(key): \(String(value))")
      }
    }
  }

  /// Examine the body before deciding how to render it to the log stream. If
  /// the body is data then try to convert it to a string based on UTF-8
  /// encoding.
  static func log(prefix: String, body: Body?) {
    if let body = body {
      switch body {
      case let data as NSData:
        guard let string = String(data: data, encoding: NSUTF8StringEncoding) else {
          fallthrough
        }
        log(string)
      default:
        log(String(body))
      }
    }
  }

  static func log(string: String) {
    for line in string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
      NSLog("%@", line)
    }
  }

  public class Handler: RackHandler {

    public init() {}

    public func build(app: App) -> Middleware {
      return Logger(app: app)
    }

  }

}
