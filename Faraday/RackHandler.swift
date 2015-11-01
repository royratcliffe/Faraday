// Faraday RackHandler.swift
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

/// Rack handlers build middleware. Middleware does not build itself. Instead,
/// when you _use_ some middleware when setting up a connection, supply and
/// instance of its rack handler.
///
/// Rack handler protocol implementers should inherit from NSObject for two
/// reasons. First, that makes it accessible from Objective-C. Second, NSObject
/// provides a default initialiser so no need to provide one explicitly.
public protocol RackHandler {

  /// Builds a piece of middleware given a capture that accepts an environment
  /// and answers an unfinished response.
  ///
  /// This method cannot be a class method. Only classes allow class methods,
  /// not protocols. This is a factory method for the middleware, implemented as
  /// an instance method.
  func build(app: App) -> Middleware

}
