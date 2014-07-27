//
//  SwiftCheck.swift
//  SwiftCheck
//
//  Created by Laura Skelton and Bert Muthalaly on 7/21/14.
//

import Foundation
import Swift

protocol Checkable: Printable {
    class func arbitrary() -> Self
    // the value passed into shrink (self) should not be in the output array
    func shrink(numValues: Int) -> [Self]
    // does everything shrinkable have to be able to judge the
    // "size" of a value of type Self?
    var shrinksize: Int { get } // should this be a function?
    // should we add validity checks to shrunken values?
    // func valid() -> Bool
}

extension String: Checkable {
    static func arbitrary() -> String {
        return randomString()
    }
    
    static func random (#from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % to)
    }
    
    static func randomString() -> String {
        let randomLength = random(from: 0, to: 100)
        var string = ""
        for i in 0..<randomLength {
            let randomInt : Int = random(from: 13, to: 255)
            string += Character(UnicodeScalar(randomInt))
        }
        return string
    }
    func shrink(numValues: Int) -> [String] {
        let lsg = LazySubstringGenerator(self)
        let numSubstrings = lsg.numberOfPossibleSubstrings
        var resultArray:[String] = []
        for i in 0..<numValues {
            let index = (Int(arc4random()) % (numSubstrings))
            resultArray += lsg.lazySubstring(index)
        }
        return resultArray
    }
    var shrinksize: Int {
    get { return countElements(self) }
    }
    public var description: String {
    get { return self }
    }
}

public enum TestResult {
    case Success
    case Failure(message: String)
}

// does this function need to be more general?
// do we want to call this with some resultSet (imagine a fn sig. (prop: X -> TestResult, resultSet: <collection>))
func swiftcheck<X: Checkable>(times: Int, prop: X -> TestResult) -> Bool {
    for _ in 0..<times {
        let val: X = X.arbitrary()
        let resultValue = prop(val)
        switch resultValue {
        case .Success: ()
        case let .Failure(errorMessage):
            println("\(val) did not satisfy the property: \(errorMessage)")
            
            println("Minimal failure case: " + shrinkcheck(val, times, prop).description)
            println("Done.")
            return false
        }
    }
    println("All 100 tests passed")
    return true
}



func shrinkcheck<X: Checkable>(initial: X, times: Int, prop: X -> TestResult) -> X {
    
    let failingShrunkenValues = initial.shrink(times).filter {
        switch prop($0) {
        case .Success: return false
        case let .Failure(errorMessage): return true
        }
    }
    
    let smallest = failingShrunkenValues.reduce(initial, combine: {
        if $1.shrinksize < $0.shrinksize { return $1 } else { return $0 }
        })
    
    if smallest.shrinksize == initial.shrinksize {
        return initial
    } else {
        return shrinkcheck(smallest, 100, prop)
    }
}


struct LazySubstringGenerator {
    let baseString : String
    init(_ s: String) {
        self.baseString = s
    }
    public var numberOfPossibleSubstrings : Int {
    get {
        return triangularSum(countElements(self.baseString))
    }
    }
    // insert long description of algorithm here
    // HERE BE DRAGONS
    // a needlessly clever way to generate all possible unique substrings
    // 0 <= i < numberOfPossibleSubstrings(s)
    public func lazySubstring(i: Int) -> String {
        //    let cc : Int = countElements(s)
        
        let x = wiggleRoom(i)
        let L : Int = countElements(baseString) - x
        let j : Int = i - triangularSum(x)
        
        let sliceableString = self.baseString as NSString
        return sliceableString.substringWithRange(NSMakeRange(j, L))
    }
    private func wiggleRoom(i : Int) -> Int {
        let magic = (-1 + sqrt((8 * Float(i)) + 1)) / 2 // TODO: naming
        return Int(floor(magic))
    }
    
    // add private
    // the "gauss" function is the sum of all integers from 0 to n
    private func triangularSum(n: Int) -> Int {
        return (n * n + n)/2
    }
}


//public struct LazySubsequenceGenerator<T> {
//    let baseSequence : Array<T>
//    init(_ s: Array<T>) {
//        baseSequence = s
//    }
//    public var numberOfPossibleSubsequences : Int {
//        get { return triangularSum(countElements(baseSequence)) }
//    }
//
//    // 0 <= randomI < numberOfPossibleSubstrings(s)
//    public func lazySubsequence(i: Int) -> Array<T> {
//
//        // given a random index into our "array" of all substrings,
//        // calculate the difference between characterCount and subsequence length
//        // let randomIndexIntoPotentialSubstrings = Int(round(Float(numberOfPossibleSubsequences(s)) * randomVal))
//        let x = wiggleRoom(i)
//        let L : Int = 3 - x
//        let j : Int = i - triangularSum(x)
//        let slice = baseSequence[j...L]
//        return Array(slice)
//    }
//
//    // insert long description of algorithm here
//    // HERE BE DRAGONS
//    private func wiggleRoom(i : Int) -> Int {
//        let n = i
//        // magic
//        let expression = (-1 + sqrt((8 * Float(i)) + 1)) / 2 // TODO: naming, reasoning, explanation
//        return Int(floor(expression))
//    }
//
//    // the sum of all integers from 0 to n
//    private func triangularSum(n: Int) -> Int {
//        return (n * n + n)/2
//    }
//}
