// Faraday NSURLComponents+Faraday.swift
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

/// Adds methods to the Foundation framework's NSURLComponents class for
/// accessing query items by name, also accessing their values by name as an
/// array of strings and setting up their values by name.
extension NSURLComponents {

  /// Filters the query items by name. Answers an array of items whose name
  /// matches the given name string; all the items in the resulting array share
  /// exactly the same name.
  public func queryItems(forName name: String) -> [NSURLQueryItem]? {
    return queryItems?.filter { item in item.name == name }
  }

  /// Answers an array of optional string values belonging to the query items
  /// matching the given name. Strips away the name from the items, leaving just
  /// the optional values.
  public func queryValues(forName name: String) -> [String?]? {
    return queryItems(forName: name)?.map { item in item.value }
  }

  /// Sets query items for a given name using an array of strings. Replaces any
  /// existing query items by the given name. Merges the new query items with
  /// existing items _not_ matching the given name. The new items appear after
  /// any existing ones.
  public func setQueryValues(values: [String?]?, forName name: String) {
    let items = values?.map { value in NSURLQueryItem(name: name, value: value) }
    let otherItems = queryItems?.filter { item in item.name != name }
    if let items = items {
      if let otherItems = otherItems {
        queryItems = otherItems + items
      } else {
        queryItems = items
      }
    } else {
      queryItems = otherItems
    }
  }

}
