//
//  Stack.swift
//  calculator
//
//  Created by Arvin Quiliza on 3/20/19.
//  Copyright © 2019 arvnq. All rights reserved.
//

import Foundation

struct Stack<T> {
    var nodeArray: [T] = []
    
    mutating func push(_ value: T){
        nodeArray.append(value)
    }
    
    mutating func pop() -> T? {
        return nodeArray.popLast()
    }
    
    func peek() -> T? {
        return nodeArray.last
    }
    
    mutating func clear() {
        nodeArray.removeAll()
    }
}

struct Queue<T> {
    var nodeArray: [T] = []
    
    mutating func enqueue(_ value: T) {
        nodeArray.append(value)
    }
    
    mutating func dequeue() -> T? {
        
        if nodeArray.isEmpty {
            return nil
        } else {
            return nodeArray.removeFirst()
        }
        
    }
    
    func peek() -> T? {
        
        if nodeArray.isEmpty {
            return nil
        } else {
            return nodeArray[0]
        }
        
    }
    
    var isEmpty: Bool {
        return nodeArray.isEmpty
    }
    
    mutating func clear() {
        nodeArray.removeAll()
    }
}
