// Faraday Response+Headers.swift
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

extension Response {

  /// - returns: Answers the response content type, including the main type and
  ///   sub-type. Automatically removes any optional parameters, such as the
  ///   content character set. Trims any white-space from the string. Answers
  ///   `nil` if the response does not have a content type.
  ///
  /// Splits the content type at the first semi-colon. There is always at least
  /// one split, even if no semi-colon. The first split is the entire content
  /// type if none.
  public var contentType: String? {
    guard let contentType = headers["Content-Type"] else { return nil }
    let splits = contentType.characters.split(1) { $0 == ";" }
    return String(splits.first!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }

}
