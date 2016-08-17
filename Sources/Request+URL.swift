// Faraday Request+URL.swift
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

// Provides helpers for setting up the request URL. Apple's Foundation class
// NSURL is non-mutable. This extension adds helper methods to allow request
// builders to conveniently adjust the request URL by changing the path, or by
// adding query items.
extension Request {

  /// Accesses the request URL as mutable components. Note that the components
  /// are *relative* components only. The components remain relative to the
  /// URL's base URL. Same goes for new components. The base URL derives from
  /// the original connection.
  public var urlComponents: URLComponents? {
    get {
      guard let url = url else {
        return nil
      }
      return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
    set(newComponents) {
      url = newComponents?.url(relativeTo: url?.baseURL)
    }
  }

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
      return urlComponents?.path
    }
    set(newPath) {
      if let newPath = newPath {
        var components = urlComponents
        components?.path = newPath
        urlComponents = components
      } else {
        urlComponents = nil
      }
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
      return (path as NSString).pathComponents
    }
    set(newPathComponents) {
      if let components = newPathComponents {
        path = NSString.path(withComponents: components)
      } else {
        path = nil
      }
    }
  }

  // MARK: - Query Items

  public func queryItems(forName name: String) -> [URLQueryItem]? {
    return urlComponents?.queryItems(forName: name)
  }

  public func queryValues(forName name: String) -> [String?]? {
    return urlComponents?.queryValues(forName: name)
  }

  /// Sets up the query items by first deconstructing the URL. The URL first
  /// becomes URL components. URL components are mutable, URLs are not. Hence,
  /// the implementation copies the URL components for mutation. After mutating,
  /// converts components back to an immutable URL.
  public func setQuery(values: [String?]?, forName name: String) {
    var components = urlComponents
    components?.setQuery(values: values, forName: name)
    urlComponents = components
  }

}
