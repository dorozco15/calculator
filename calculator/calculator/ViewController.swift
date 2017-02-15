//
//  ViewController.swift
//  calculator
//
//  Created by Danny Orozco on 2017-02-09.
//  Copyright © 2017 Danny Orozco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
// line above means that vieController inherits UIViewController 
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false //checks if user is inputing numbers
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {//digit gets the digit pressed if its set aka != nil
            if userIsInTheMiddleOfTyping{ // if inputing numbers..
                let textCurrentInDisplay = display.text! //grab the digits in the display label
                
                    display.text = textCurrentInDisplay + digit //send the old display digits with the new pressed digit appended on the end

            }
            else{ //if user is NOT typing aka text field is empty or 0
                display.text = digit //remove old stuff from display label and display new digit pressed
                
            }
            
            userIsInTheMiddleOfTyping = true //once the first digit is pressed the user is actively typing
        }
        
    }//end touchDigit()
    
    private var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if (savedProgram != nil) {
            brain.program = savedProgram!
            displayValue = brain.result
        }
            
    }
    
    //computed variable for gettign and setting stuff from our label
    private var displayValue: Double {
        get{ return Double(display.text!)! } //remember to unwrapp the val
        
        set{ display.text = String(newValue)}
            
    }
    //calculator brain initialization
    private var brain  = CalculatorBrain()
    //perform operation function
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue) //the first operand is what was in the label before function button was pressed
            userIsInTheMiddleOfTyping = false //user is not typing anymore
        }
        
        if let mathSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathSymbol)
            
        }
        displayValue = brain.result
        
    }

}

