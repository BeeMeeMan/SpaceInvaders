/*
 Convertion of String arithmetic expressions into the array and
 arithmetic expression calculation with Shunting-yard algorithm
 Xcode version 13.0 (13A233).
 Created by Korsun E. V. , October 23, 2021.
 Released into the public domain.
*/

import UIKit
import Foundation

// MARK: - Convertion of String arithmetic expressions into the array

func mathStringToArray (_ string: String) -> [String] {
    // Adding split operators:
    
    let operators = "+-/*()^"
    
    // Adding stack for composition of numbers:
    
    var numberStack: String = ""
    
    // Adding array for saving answer:
    
    var array = [String]()
    
    // Cycle of String:
    
for character in string{
    // If first number is negative:
    
    if array.count == 0 && numberStack.count == 0 && character == "-"{
        
        numberStack += String(character)
     
     // If negative number after the parenthesis:
    } else if array.count != 0 && array.last! == "(" && numberStack.count == 0 && character == "-" {
        
        numberStack += String(character)
        
    // Adding number from stack to array:
    } else if !operators.contains(character) {
        
        numberStack += String(character)
     
    } else {
        // Adding number from stack to array (cleaning stack before adding operator):
        
        if numberStack != ""{
            array.append(numberStack)
            numberStack = ""
        }
        // Adding operator:
        
        array.append(String(character))
    }
        
    }
    
    // Adding last number from the string (last number of the stack) to array :
    if  numberStack != ""{
        array.append(numberStack)
        numberStack = ""
    }
    return array
}

//  Example of work:

    let test = "-2+99.34-234/382.12*(-92+12^3)+99"

    print(mathStringToArray(test))
    
//  MARK: - Arithmetic calculation of array with Shunting-yard algorithm:

    func arrayCalculation (_ formula: [String]) -> Double{
        
       // Set priority of different arithmetic operation:
        
        let priorityDict: [String: Int] = ["+":1, "-":1, "*":2, "/":2, "(": 0, ")": 0, "^":3]
        
        // Add stack for math operator:
        var operatorStack = [String]()
        
        // Add stack for numbers:
        var numberStack = [Double]()
        
        // Adding a method for defining mathematical operators according to the data from the stacks:
        
        func operation () -> Double{
            
            let topStackNumber = numberStack.last!                  //Last number in stack
            let bottomStackNumber = numberStack.dropLast().last!    //Penult number in stack
            let symbol = operatorStack.last!                        //Last operator in stack
            
            switch symbol {
            case "+":
                return bottomStackNumber + topStackNumber
            case "-":
                return bottomStackNumber - topStackNumber
            case "*":
                return bottomStackNumber * topStackNumber
            case "/":
                return bottomStackNumber / topStackNumber
            case "^":
                return pow(bottomStackNumber,topStackNumber)
            default:
                return 0
            }
        }
        
        // Add calculation logics:
        func stackCalculation(ForInLoop element: String){
            // Take two last numbers from numberStack and make math operation with them, according to the last operator in the stack. Then switch two last number from the stackby new result, and add current operator in the stack:
             
                let answer = operation()
                numberStack = numberStack.dropLast(2)
                numberStack.append(answer)
                operatorStack = operatorStack.dropLast()
            }
 
        // Reading all element of array:
        for element in formula {
            
            
            // If element number, add it to numberStack:
            
            if !priorityDict.keys.contains(element){
                
                numberStack.append(Double(element)!)
            
            // If element "(", add it to operatorStack:
                
            } else if element == "(" {
                
                operatorStack.append(element)
               
            // If element ")", do calculation of all element in parentheses until element become "(" :
            } else if element == ")" {
                
            while operatorStack.last! != "(" {
                                        
                    stackCalculation(ForInLoop: element)
                                       
                }
                // Remove "(" from stack when make all the calculaton in the parentheses:
                operatorStack = operatorStack.dropLast()
                
                // If operatorStack isempty or priority of new operator element is greater then stack last elemet, then just add it to operatorStack:
            } else if operatorStack.isEmpty || priorityDict[operatorStack.last!]!  < priorityDict[element]!{
                    
                    operatorStack.append(element)
                // If new operator element priority is less then stack last elemet, then we take two last numbers from numberStack and make math operation with them, according to the last operator in the stack. Then switch two last number from the stackby new result, and add current operator in the stack:
            } else if priorityDict[operatorStack.last!]!  >= priorityDict[element]!{
                    
                // Make calculation in other cases:
                    stackCalculation(ForInLoop: element)
                
                while !operatorStack.isEmpty && priorityDict[operatorStack.last!]!  >= priorityDict[element]! {
                    print(numberStack)
                    print(operatorStack)
                    stackCalculation(ForInLoop: element)
                    

                    }
                
                    operatorStack.append(element)
               
            
        }
        }
 
       
 //        Count the pair of numbers left after forInLoop:
        for element in operatorStack {
            stackCalculation(ForInLoop: element)


        }
        print(numberStack)
        return numberStack.first!
              
    
    }

//  Example of work:

//let test = "-2+99.34-234/382.12*(-92+12^3)+99"
    let test2 = "((-2+99.34)-234/382.12)*(-92+12^3)+99-197*324-29/32-(99*23.3+(22^2-99*3))-31.1^2"
    
    let arrayConvert = mathStringToArray(test2)

    print(arrayConvert)
    print(arrayCalculation(arrayConvert))
