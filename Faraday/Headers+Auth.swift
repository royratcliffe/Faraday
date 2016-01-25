// Faraday Headers+Auth.swift
//
// Copyright © 2016, Roy Ratcliffe, Pioneering Software, United Kingdom
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

extension Headers {

  public var authorization: String? {
    get {
      return self["Authorization"]
    }
    set(value) {
      self["Authorization"] = value
    }
  }

  /// Sets up basic authorisation using the given log-in user name and
  /// corresponding password. These become part of the `Authorization` header
  /// after some encoding. Useful for preparing individual request headers, or
  /// connection-wide request headers, for authorised access.
  /// - returns: the new authorisation header value, or `nil` if the given
  ///   log-in user name and password fails to encode as UTF-8.
  public mutating func basicAuth(login: String, pass: String) -> String? {
    guard let data = "\(login):\(pass)".dataUsingEncoding(NSUTF8StringEncoding) else {
      return nil
    }
    let string = data.base64EncodedStringWithOptions([])
    let basicAuthHeaderValue = "Basic \(string)"
    authorization = basicAuthHeaderValue
    return basicAuthHeaderValue
  }

}
