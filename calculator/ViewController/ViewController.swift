//
//  ViewController.swift
//  calculator
//
//  Created by Arvin Quiliza on 3/19/19.
//  Copyright © 2019 arvnq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- IBOUTLETS
    /// Calculator's display screen
    @IBOutlet weak var displayLabel: UILabel!
    /// Indicator that the operation is undefined
    @IBOutlet weak var undefineLabel: UILabel!
    
    //MARK:- PROPERTIES
    /// Contains all of the digits in a numeric insert. Digits can be 0-9, and a decimal point
    var operandDigits: [Any] = []
    /// Contains the current and previous operation pressed in the calculator
    var operationStack = Stack<ArithmeticOperation>()
    /// Contains all of the operands combined from the operandDigits array.
    var operandQueue = Queue<Double>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the undefine label
        undefineLabel.alpha = 0
    }

    //MARK:- IBACTIONS
    /**
     Numeric Button tapped. We add the numberValue into operandDigits and compose a new value
     from all of the elements in the operandDigits. The composed value is then displayed on the screen.
     */
    @IBAction func numericButtonTapped(_ numericButton: UIButton) {
        let numberValue = numericButton.tag
        
        operandDigits.append(numberValue)
        
        let displayValue = composeValue(of: operandDigits)
        configureDisplayLabel(with: displayValue)
    }
    
    /**
     Arithmetic Operation Button tapped. We get the operation from the button's title. If there is
     no arithmetic operation in the stack, we push the operationValue. If there is a current arithmetic operation
     in the stack, we execute the operation on the operands and display the result. Once the operation is done
     and the result is displayed, we enqueue the result making it the first operand and push the next operation into stack.
     */
    @IBAction func operationButtonTapped(_ operationButton: UIButton) {
        let operationValue = operationButton.currentTitle
        
        enqueueOperand()
        resetOperandDigits() // once the first operand is enqueued, we clear operandDigits
        
        //we pop the operation first
        guard let currentArithmetic = operationStack.pop() else {
            //if there's nothing to pop, we still push the operation triggered
            pushOperation(using: operationValue!)
            return
        }
        
        var result = ""
        result = performOperation(currentArithmetic)
        configureDisplayLabel(with: result)
        
        // execute the previous routine before actual arithmetic
        enqueueOperand()
        pushOperation(using: operationValue!)
    }
    
    /**
     Plus / Minus Button tapped. Toggle the button's sign either displaying a positive or a negative value.
     */
    @IBAction func negateButtonTapped(_ sender: UIButton) {
        guard let displayText = displayLabel.text,
              let displayValue = Double(displayText) else { return }
        
        let negatedDisplayValue = displayValue * -1
        
        configureDisplayLabel(with: String(negatedDisplayValue))
        
    }
    
    /**
     Percent Button tapped. Get the percent of the value displayed in the calc screen
     */
    @IBAction func percentButtonTapped(_ sender: UIButton) {
        guard let displayText = displayLabel.text,
            let displayValue = Double(displayText) else { return }
        
        let percentDisplayValue = displayValue / 100
        
        configureDisplayLabel(with: String(percentDisplayValue))
    }
    
    /**
     Decimal Button tapped. Decimal point is added into operationDigits when certain conditions are met.
     Subsequently, we display the new value with decimal point in calc screen upon successful decimal point insertion.
     */
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        if operandDigits.isEmpty {
            // we append 0 and . separately, to make . as a single entity
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
    
    
    /**
     Equals Button tapped. We check the operands from the queue and get the operation from the stack.
     Upon getting these values, then we perform the operation.
     */
    @IBAction func equalsButtonTapped(_ equalsButton: UIButton) {
        
        guard let currentArithmetic = operationStack.pop() else { return }
        
        enqueueOperand()
        resetOperandDigits() // once the second operand is enqueued, we clear operandDigits
        
        var result = ""
        result = performOperation(currentArithmetic)
        
        configureDisplayLabel(with: result)
    }

    /**
     AC Button tapped. Cleards operandDigits, as well as operationStack and operandQueues.
     Also clears calculator display showing zero value
     */
    @IBAction func clearButtonTapped(_ clearButton: UIButton) {
        resetOperandDigits()
        configureDisplayLabel(with: "0")
        
        resetOperationAndOperands()
        
    }
    
    //MARK:- HELPER METHODS
    /**
     Removes all the elements of operationStack and operandQueue
     */
    func resetOperationAndOperands() {
        //clear our stack and queue
        operationStack.clear()
        operandQueue.clear()
    }
    
    /**
     Inserting the value from the calculator display into the operandQueue
     */
    func enqueueOperand() {
        guard let displayText = displayLabel.text,
            let displayValue = Double(displayText) else { return }
            //let displayValue = NumberFormatter().number(from: displayText)?.doubleValue else { return }
        
        // enqueue operand
        operandQueue.enqueue(displayValue)
    }
    
    /**
     Pushing the selected ArithmeticOperation into the operationStack
     - Parameters:
        - operationValue: the arithmetic operation selected from the calculator
     */
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
    
    /**
     Combine values inside operandDigits to make a new value. Combining involves
     making each element a string before triggering the joined function
     - Parameters:
        - operand: array containing operandDigit elements.
     - Returns: the string value of the new number combined
     */
    func composeValue(of operand: [Any]) -> String {
        
        // if operand array is empty, return zero
        if operand.isEmpty {
            return String(0)
        }
        
        // no consecutive zeroes is allowed, clear operandDigits and return zero
        if let first = operand.first as? Int,
               first == 0 {
            resetOperandDigits()
            return String(0)
        }
        
        // combine the elements in the operandDigits. Make each element a string and trigger joined
        let combinedValue = operand.compactMap( {"\($0)"} ).joined()
        
        return combinedValue
    }
    
    /**
     Calls the arithmetic operation based on the instance. Operands are dequeued, clearing the operandQueue.
     Operation and Operand data structures are cleared if no result is returned
     - Parameters:
        - currentArithmetic: current arithmeticOperation instance
     - Returns: result of type string to be displayed in calculator screen
     */
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
    
    /**
     Clears all the elements of operandDigits
     */
    func resetOperandDigits() {
        operandDigits.removeAll()
    }
    
    /**
     Configure the display of the calculator
     - Parameter text: string used as the current text of display
     */
    func configureDisplayLabel(with text: String) {
        if let _ = Double(text) { //checks whether the text is an instance of Double
            let dNum: NSDecimalNumber = NSDecimalNumber(string: text)
            displayLabel.text = dNum.stringValue
        } else {
            //if not, then we animate undefine label to display
            UIView.animate(withDuration: 0.5, animations: {
                self.undefineLabel.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.undefineLabel.alpha = 0
                })
            }
            
            let dNum: NSDecimalNumber = NSDecimalNumber(string: text)
            displayLabel.text = dNum.stringValue
        }
    }
    
}



