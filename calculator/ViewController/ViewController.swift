//
//  ViewController.swift
//  calculator
//
//  Created by Arvin Quiliza on 3/19/19.
//  Copyright © 2019 arvnq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    var operandDigits: [Any] = []
    var operationStack = Stack<ArithmeticOperation>()
    var operandQueue = Queue<Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func numericButtonTapped(_ numericButton: UIButton) {
        let numberValue = numericButton.tag
        
        operandDigits.append(numberValue)
        
        let displayValue = composeValue(of: operandDigits)
        configureDisplayLabel(with: displayValue)
    }
    
    @IBAction func operationButtonTapped(_ operationButton: UIButton) {
        let operationValue = operationButton.currentTitle
        
        enqueueOperand()
        resetOperandDigits() // once the first operand is enqueued, we clear operandDigits
        
        ///
        //we pop the operation first
        guard let currentArithmetic = operationStack.pop() else {
            //if there's nothing to pop, we still push the operation triggered
            pushOperation(using: operationValue!)
            return
        }
        
        var result = ""
        result = performOperation(currentArithmetic)
        configureDisplayLabel(with: result)
        ///
        
        // execute the previous routine before actual arithmetic
        enqueueOperand()
        pushOperation(using: operationValue!)
    }
    
    @IBAction func negateButtonTapped(_ sender: UIButton) {
        guard let displayText = displayLabel.text,
              let displayValue = Double(displayText) else { return }
        
        let negatedDisplayValue = displayValue * -1
        
        configureDisplayLabel(with: String(negatedDisplayValue))
        
    }
    
    @IBAction func percentButtonTapped(_ sender: UIButton) {
        guard let displayText = displayLabel.text,
            let displayValue = Double(displayText) else { return }
        
        let percentDisplayValue = displayValue / 100
        
        configureDisplayLabel(with: String(percentDisplayValue))
    }
    
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        if operandDigits.isEmpty {
            // we append 0 and . separately, to compare . as a single entity
            operandDigits.append("0")
            operandDigits.append(".")
        } else {
            
            //check if . has already been entered
            let isDecimalInPlace = operandDigits.contains { "\($0)" == "." }
            
            // if not, append
            if !isDecimalInPlace {
                operandDigits.append(".")
            }
            
        }
        
        let displayValue = composeValue(of: operandDigits)
        configureDisplayLabel(with: displayValue)
    }
    
    
    
    @IBAction func equalsButtonTapped(_ equalsButton: UIButton) {
        
        guard let currentArithmetic = operationStack.pop() else { return }
        
        enqueueOperand()
        resetOperandDigits() // once the second operand is enqueued, we clear operandDigits
        
        var result = ""
        result = performOperation(currentArithmetic)
        
        configureDisplayLabel(with: result)
    }

    @IBAction func clearButtonTapped(_ clearButton: UIButton) {
        resetOperandDigits()
        configureDisplayLabel(with: "0")
        
        resetOperationAndOperands()
        
    }
    
    func resetOperationAndOperands() {
        //clear our stack and queue
        operationStack.clear()
        operandQueue.clear()
    }
    
    func enqueueOperand() {
        guard let displayText = displayLabel.text,
            let displayValue = Double(displayText) else { return }
            //let displayValue = NumberFormatter().number(from: displayText)?.doubleValue else { return }
        
        // enqueue operand
        operandQueue.enqueue(displayValue)
    }
    
    func pushOperation(using operationValue: String) {
        //we push the operation after popping the previous one
        switch operationValue {
            case "+" : operationStack.push(.add)
            case "−" : operationStack.push(.subtract)
            case "×" : operationStack.push(.multiply)
            case "÷" : operationStack.push(.divide)
            default: return
        }
    }
    
    func composeValue(of operand: [Any]) -> String {
        
        // if operand array is empty, return zero
        if operand.isEmpty {
            return String(0)
        }
        
        // no consecutive zeroes, clear operandDigits and return zero
        if let first = operand.first as? Int,
               first == 0 {
            resetOperandDigits()
            return String(0)
        }
        
        //combine
        let combinedValue = operand.compactMap( {"\($0)"} ).joined()
        
        return combinedValue
    }
    
    func performOperation(_ currentArithmetic: ArithmeticOperation) -> String {
        
        var result = ""
        
        if let first = operandQueue.dequeue(),
            let second = operandQueue.dequeue() {
            
            if let oResult = currentArithmetic.getOperationResult(for: first, and: second) {
                let dNum: NSDecimalNumber = NSDecimalNumber(string: String(oResult))
                result = dNum.stringValue
            } else {
                result = "Error"
                resetOperationAndOperands()
            }
            
        }
        
        return result
    }
    
    func resetOperandDigits() {
        operandDigits.removeAll()
    }
    
    func configureDisplayLabel(with text: String) {
        displayLabel.text = text
    }
    
}



