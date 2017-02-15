//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Danny Orozco on 2017-02-15.
//  Copyright © 2017 Danny Orozco. All rights reserved.
//

import Foundation

private func multiply(x: Double, y: Double) -> Double{
    return x*y
}

class CalculatorBrain{
    
    /*
     enum Optional<T> {
        case none 
        case some(T)
     }
 */
    private struct pendingBinaryFunc{
        var binaryFunc: (Double, Double) -> Double
        var firstOperand: Double
    }
    private var pending: pendingBinaryFunc?
    private var internalProgram = [PropertyList]()
    
    
    private var accumulator = 0.0 //our result
    private enum Operation { //data structer with discrete set of values or properties
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations : Dictionary <String,Operation> = [
        "π": Operation.constant(M_PI), //M_PI,
        "e": Operation.constant(M_E), //M_E,
        "√":  Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "x": Operation.binaryOperation({$0 * $1 }),
        "÷": Operation.binaryOperation({$0 / $1 }),
        "-": Operation.binaryOperation({$0 + $1 }),
        "+": Operation.binaryOperation({$0 + $1 }),
        "=": Operation.equals
        
    
    ]
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):  accumulator = value
            case .unaryOperation(let function): accumulator = function(accumulator)
            case .binaryOperation(let function):
                if pending != nil {
                    accumulator = pending!.binaryFunc(pending!.firstOperand, accumulator)
                    pending = nil
                }
                pending = pendingBinaryFunc(binaryFunc: function, firstOperand: accumulator)
            case .equals:
                if pending != nil {
                    accumulator = pending!.binaryFunc(pending!.firstOperand, accumulator)
                    pending = nil
                }
            }
        }
    }
    private func clear(){
        pending = nil
        accumulator = 0.0
        internalProgram.removeAll()
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get{ return internalProgram as CalculatorBrain.PropertyList  }
        set{
            clear()
            if let arrayOfOps = newValue as? [PropertyList]{
                for op in arrayOfOps{
                    if op is Double {
                        setOperand(operand: op as! Double)
                        
                    }
                    else if op is String{
                        performOperation(symbol: op as! String)
                    }
                }
            }
        }
        
    }
    
    var result: Double{
        get{ return accumulator}
        
        
    }
    
    
    
}
