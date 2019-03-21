//
//  Stack.swift
//  calculator
//
//  Created by Arvin Quiliza on 3/20/19.
//  Copyright © 2019 arvnq. All rights reserved.
//

import Foundation

/**
 Generic stack data structure.
 */
struct Stack<T> {
    var nodeArray: [T] = []
    
    /**
     Inserts a new element at the top of stack.
     - Parameter value: Any element of generic type T
     */
    mutating func push(_ value: T){
        nodeArray.append(value)
    }
    
    /**
     Deletes the top most element of stack.
     - Returns: Element deleted from the top of stack
     */
    mutating func pop() -> T? {
        return nodeArray.popLast()
    }
    
    /**
     Checks current element at the top of stack.
     - Returns: Element at the top of the stack
     */
    func peek() -> T? {
        return nodeArray.last
    }
    
    /**
     Removes all the elements of the stack.
     */
    mutating func clear() {
        nodeArray.removeAll()
    }
}

/**
 Generic queue data structure.
 */
struct Queue<T> {
    var nodeArray: [T] = []
    
    /**
     Inserts a new element in the queue.
     - Parameter value: Any element of generic type T
     */
    mutating func enqueue(_ value: T) {
        nodeArray.append(value)
    }
    
    /**
     Deletes the first element of the queue.
     - Returns: the first element deleted from the queue
     */
    mutating func dequeue() -> T? {
        
        if nodeArray.isEmpty {
            return nil
        } else {
            return nodeArray.removeFirst()
        }
        
    }
    
    /**
     Checks current element in front of the queue.
     - Returns: Element in front of the queue
     */
    func peek() -> T? {
        
        if nodeArray.isEmpty {
            return nil
        } else {
            return nodeArray[0]
        }
        
    }
    
    /**
     Checks if there are elements in the queue.
     */
    var isEmpty: Bool {
        return nodeArray.isEmpty
    }
    
    /**
     Removes all the elements of the queue.
     */
    mutating func clear() {
        nodeArray.removeAll()
    }
    
    /**
     Returns the number of elements in the queue
     */
    var count: Int {
        return nodeArray.count
    }
}
