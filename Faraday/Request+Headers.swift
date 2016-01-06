// Faraday Request+Headers.swift
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

extension Request {

  public var accept: String? {
    get {
      return headers["Accept"]
    }
    set(newAccept) {
      headers["Accept"] = newAccept
    }
  }

  /// Accesses the HTTP Accept header. The header is a comma-delimited string of
  /// media ranges, each with an optional quality factor separated from the
  /// media range by a semicolon. The `accepts` method (plural) splits the
  /// header by commas and trims out any white-space. The result is an array of
  /// strings, one for each media range.
  public var accepts: [String]? {
    get {
      return accept?.characters.split(",").map {
        String($0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      }
    }
    set(newAccepts) {
      accept = newAccepts?.joinWithSeparator(", ")
    }
  }

}
