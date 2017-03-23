//
//  FoundationExt.swift
//  Runner
//
//  Created by Khanh Pham on 3/23/17.
//  Copyright © 2017 Khanh Pham. All rights reserved.
//

import Foundation

extension Array {
    func appending(_ newElement: Element) -> Array {
        var a = self
        a.append(newElement)
        return a
    }
}
