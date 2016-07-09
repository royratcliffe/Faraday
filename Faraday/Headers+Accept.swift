// Faraday Headers+Accept.swift
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

  public var accept: String? {
    get {
      return self["Accept"]
    }
    set(value) {
      self["Accept"] = value
    }
  }

  /// Accesses the HTTP Accept header. The header is a comma-delimited string of
  /// media ranges, each with an optional quality factor separated from the
  /// media range by a semicolon. The `accepts` method (plural) splits the
  /// header by commas and trims out any white-space. The result is an array of
  /// strings, one for each media range.
  public var acceptContentTypes: [String]? {
    get {
      return accept?.characters.split(separator: ",").map {
        String($0).trimmingCharacters(in: NSCharacterSet.whitespaces)
      }
    }
    set(value) {
      accept = value?.joined(separator: ", ")
    }
  }

  /// Adds more type elements to the Accept header. Does not add duplicates;
  /// instead, it passes the new elements through a filter in order to remove
  /// duplicates and make the acceptable types unique.
  public mutating func accepts(contentTypes: [String]) {
    guard let oldContentTypes = acceptContentTypes else {
      acceptContentTypes = contentTypes
      return
    }
    acceptContentTypes = oldContentTypes + contentTypes.filter { (contentType) -> Bool in
      !oldContentTypes.contains(contentType)
    }
  }

}
