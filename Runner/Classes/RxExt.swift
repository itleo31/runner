//
//  RxExt.swift
//  Runner
//
//  Created by Khanh Pham on 3/23/17.
//  Copyright © 2017 Khanh Pham. All rights reserved.
//

import Foundation

extension Observable {
    func observeOnMain() -> Observable<Element> {
        return self.observeOn(MainScheduler.instance)
    }
}
