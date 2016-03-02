// Faraday NSURLSessionTask+Env.swift
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

extension NSURLSessionTask {

  struct Static {
    /// Provides a unique address in memory space used as a key for identifying
    /// the associated Env object. The exact value does not matter. The address
    /// is the key, not the value.
    static var env = UInt64(bigEndian: 0xbadc0ffee0ddf00d)
  }

  /// Associates a Rack environment with an URL session task, either a data or
  /// upload task. Associates by retaining the environment. The environment
  /// therefore lives at least as long as the task.
  public var env: Env? {
    get {
      return objc_getAssociatedObject(self, &Static.env) as? Env
    }
    set(newEnv) {
      objc_setAssociatedObject(self, &Static.env, newEnv, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

}
