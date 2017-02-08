// Faraday Headers.swift
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

/// Header fields, i.e. header name-value pairs for request or response headers.
public struct Headers: Sequence {

  private var headerFields = [String: String]()

  public subscript(field: String) -> String? {
    get {
      return headerFields[field]
    }
    set(value) {
      headerFields[field] = value
    }
  }

  /// - returns: All the header fields in a form compatible with the Foundation
  ///   framework's NSURLRequest class, hence the method name. Answers an
  ///   immutable copy of all the header fields.
  public var allHeaderFields: [String: String] {
    return headerFields
  }

  /// Provides an accessible initialiser so that `Headers` can be constructed.
  public init() {}

  // MARK: - Sequence Type

  public func makeIterator() -> Dictionary<String, String>.Iterator {
    return headerFields.makeIterator()
  }

}
