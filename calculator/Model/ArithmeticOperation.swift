//
//  Operation.swift
//  calculator
//
//  Created by Arvin Quiliza on 3/20/19.
//  Copyright © 2019 arvnq. All rights reserved.
//

import Foundation

/**
 Enumeration representing arithmetic operation in the calc
 */
enum ArithmeticOperation: String {
    case add
    case subtract
    case multiply
    case divide
    
    /**
     Performs arithmetic operation. Division by zero yields a nil value
     - Parameters:
        - first: the first operand in the operation statement
        - second: the second operand in the operation statement
     - Returns: An optional result
     */
    func getOperationResult(for first: Double, and second: Double) -> Double? {
        
        switch self {
            case .add: return first + second
            case .subtract: return first - second
            case .multiply: return first * second
            case .divide:
                if second == 0 {
                    return nil
                } else {
                    return first / second
                }
        }
    }
}
