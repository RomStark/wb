//
//  Observable.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import Foundation

final class Observable<T> {
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                for listener in self.listeners.values {
                    listener(self.value)
                }
            }
        }
    }
    
    private var listeners: [String: ((T?) -> Void)] = [:]
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ id: String, _ listener: @escaping ((T?) -> Void)) {
        self.listeners[id] = listener
    }
    
    func unbind(_ id: String) {
        print(listeners)
        self.listeners.removeValue(forKey: id)
        print(listeners)
    }
}
