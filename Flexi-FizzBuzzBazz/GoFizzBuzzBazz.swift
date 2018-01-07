//
//  GoFizzBuzzBazz.swift
//  Flexi-FizzBuzzBazz
//
//  Created by Kean Chin on 1/7/18.
//  Copyright © 2018 Kean Chin. All rights reserved.
//

import Foundation

public class GoFizzBuzzBazz
{
    public var Fizz: Int? = 0
    
    public var Buzz: Int? = 0
    
    public let MaxArraySizeAllowed : Int = 2000;
    
    // Determine array size based on number of elements to store
    public func GetArraySize(start: Int, end: Int) -> Int
    {
        var startTemp = start
        var endTemp = end
        // Swap start and end if start is greater than end
        CheckStartAndEnd(&startTemp, &endTemp)
        
        var arraySize = endTemp - startTemp + 1;
        
        // Make sure array size of at least 1
        if arraySize <= 0 { arraySize = 1 }
        
        return arraySize
    }
    
    // Swap start and end if start is greater than end
    func CheckStartAndEnd(_ start: inout Int, _ end: inout Int)
    {
        if (end < start)
        {
            let temp = end
            end = start
            start = temp
        }
    }
    
    // Predicates
    public func iEqualBazz (i: Int, B: Int) -> Bool {
        return i == B
    }
    
    public func iLessThanBazz (i: Int, B: Int) -> Bool {
        return i < B
    }
    
    public func iGreaterThanBazz (i: Int, B: Int) -> Bool {
        return i > B
    }
    
    public func noBazz (i: Int, B: Int) -> Bool {
        return false
    }
    
    // FizzBuzzBazz() returns a string array per the given start and end index and predicate
    public func FizzBuzzBazz(iStart: Int, iEnd: Int, iBazz: Int, predicateFunc: (Int, Int) -> Bool) -> [String]
    {
        var strResult = [String]() // String array to hold result
        
        var start = iStart
        var end = iEnd
        
        if (start == 0) { strResult.append("Start cannot be 0.") }
        else if (end == 0) { strResult.append("End cannot be 0.") }
        else {
            CheckStartAndEnd(&start, &end);   // Swap start and end if start is greater than end
            
            let arraySize = GetArraySize(start: start, end: end);
            
            if (Fizz == 0 || Fizz == nil) { strResult.append("Fizz cannot be 0.") }
            else if (Buzz == 0 || Buzz == nil) { strResult.append("Buzz cannot be 0.") }
            else if (arraySize > MaxArraySizeAllowed) {
                strResult.append("Start - End must be < \(MaxArraySizeAllowed).")
            }
            else
            {
                for i in start...end
                {
                    // Set Fizz and Buzz flags for each i
                    let isFizz: Bool = ((i % Fizz!) == 0)
                    let isBuzz: Bool = ((i % Buzz!) == 0)
                    
                    // Act on the conditions for Fizz, Buzz, FizzBuzz, and FizzBuzzBazz
                    //  to create string items accordingly
                    if (isFizz && isBuzz)
                    {
                        if (predicateFunc(i, iBazz)) { strResult.append("FizzBuzzBazz") }
                        else { strResult.append("FizzBuzz") }
                    }
                    else if isFizz { strResult.append("Fizz") }
                    else if isBuzz { strResult.append("Buzz") }
                    else { strResult.append("\(i)") }
                }
            }
        }
        
        return strResult;
    }
}
