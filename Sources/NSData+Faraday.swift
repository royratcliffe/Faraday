// Faraday NSData+Faraday.swift
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

extension NSData {

  /// - returns: All the byte ranges belonging to this block of data by
  ///   enumerating and collating all the currently available ranges.
  public var byteRanges: [NSRange] {
    var byteRanges = [NSRange]()
    enumerateBytes { (_, range, _) -> Void in
      byteRanges.append(range)
    }
    return byteRanges
  }

  /// - returns: An index set representing all the available byte indexes.
  public var byteIndexes: NSIndexSet {
    let byteIndexes = NSMutableIndexSet()
    enumerateBytes { (_, range, _) -> Void in
      byteIndexes.add(in: range)
    }
    // swiftlint:disable:next force_cast
    return byteIndexes.copy() as! NSIndexSet
  }

}
