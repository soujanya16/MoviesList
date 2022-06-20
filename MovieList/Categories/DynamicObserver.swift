//
//  DynamicObserver.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import Foundation
final class DynamicObserver<T>: NSObject {
    typealias Listener = (T) -> Void
    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
}
