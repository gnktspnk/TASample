//
//  Variable.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation

class Variable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            guard listener != nil else { return }
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: Listener?) {
        self.listener =  listener
        listener?(value)
    }
}
