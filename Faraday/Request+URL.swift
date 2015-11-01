// Faraday Request+URL.swift
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

// Provides helpers for setting up the request URL. Apple's Foundation class
// NSURL is non-mutable. This extension adds helper methods to allow request
// builders to conveniently adjust the request URL by changing the path, or by
// adding query items.
extension Request {

  /// Getter and setter for accessing the request URL's relative path; they do
  /// not access the _absolute_ URL if the URL has a base URL.
  ///
  /// You cannot directly assign the URL path. Foundation framework's NSURL
  /// class is immutable. Instead, the setter extracts the URL components,
  /// mutates the components, then reconstructs and assigns a new URL based on
  /// the new components, retaining the same base URL. For this reason, the
  /// getter also passes the URL through its mutable counterpart before
  /// extracting the path. Hence the getter and setter deal with the URL at the
  /// same level, the URL-component level.
  public var path: String? {
    get {
      guard let URL = URL else { return nil }
      let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false)
      return components?.path
    }
    set(newPath) {
      guard let URL = URL else { return }
      let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false)
      components?.path = newPath
      self.URL = components?.URLRelativeToURL(URL.baseURL)
    }
  }

  /// Provides convenient access to the URL path as an array of string
  /// components. This getter-setter accessor pair accepts and replies with an
  /// optional array of string objects. If `nil`, there is no path.
  public var pathComponents: [String]? {
    get {
      guard let path = path else {
        return nil
      }
      return NSString(string: path).pathComponents
    }
    set(newPathComponents) {
      if let components = newPathComponents {
        path = NSString.pathWithComponents(components)
      }
      else {
        path = nil
      }
    }
  }

}
