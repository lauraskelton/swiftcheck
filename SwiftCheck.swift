//
//  SwiftCheck.swift
//  SwiftCheck
//
//  Created by Laura Skelton and Bert Muthalaly on 7/21/14.
//

import Foundation
import Swift

/**
TestResult lets us know if this test failed or succeeded
*/
public enum TestResult {
    case Success
    case Failure(message: String)
}

/**
Checkable makes sure values can be checked with SwiftCheck
*/
protocol Checkable: Printable {
    
    /**
    Arbitrary generates an arbitrary value to test
    */
    class func arbitrary() -> Self
    // the value passed into shrink (self) should not be in the output array
    
    /**
    Shrink finds the minimum possible failure case for a failed test
    */
    func shrink(numValues: Int) -> [Self]
    // does everything shrinkable have to be able to judge the
    // "size" of a value of type Self?
    
    /**
    Shrinksize compares the size of two shrunken values
    */
    var shrinksize: Int { get } // should this be a function?
    // should we add validity checks to shrunken values?
    // func valid() -> Bool
    
}

/**
Checkable string extends String
*/
extension String: Checkable {
    
    /**
    arbitrary string generates a random string for testing
    */
    static func arbitrary() -> String {
        return randomString()
    }
    
    /**
    Random generates a random number
    */
    static func random (#from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % to)
    }
    
    /**
    RandomString generates a random string
    */
    static func randomString() -> String {
        let randomLength = random(from: 0, to: 100)
        var string = ""
        for i in 0..<randomLength {
            let randomInt : Int = random(from: 13, to: 255)
            string += Character(UnicodeScalar(randomInt))
        }
        return string
    }
    
    /**
    Shrink finds a smaller substring of the given string
    */
    func shrink(numValues: Int) -> [String] {
        let arrayOfSubstrings : ArrayOfAllSubstrings = ArrayOfAllSubstrings(self)
        let numSubstrings = arrayOfSubstrings.count
        var resultArray:[String] = []
        for i in 0..<numValues {
            let index = (Int(arc4random()) % (numSubstrings))
            resultArray.append(arrayOfSubstrings[index])
        }
        return resultArray
    }
    
    /**
    Shrinksize gives the length of the string
    */
    var shrinksize: Int {
        get { return countElements(self) }
    }
    
    /**
    Description allows us to print the string to the console
    */
    public var description: String {
        get { return self }
    }
}

/**
Checkable Int extends Int
*/
extension Int: Checkable {
    
    /**
    arbitrary int generates a random int for testing
    */
    static func arbitrary() -> Int {
        return randomInt()
    }
    
    /**
    Random generates a random number
    */
    static func random (#from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % to)
    }
    
    /**
    RandomInt generates a random number
    */
    static func randomInt() -> Int {
        return random(from: 0, to: Int.max)
    }
    
    /**
    Shrink finds a smaller number than the given number
    */
    func shrink(numValues: Int) -> [Int] {
        var resultArray:[Int] = []
        for i in 0..<numValues {
            let i = Int(arc4random()) % (self)
            resultArray.append(i)
        }
        return resultArray
    }
    
    /**
    Shrinksize gives the Int
    */
    var shrinksize: Int {
        get { return self }
    }
    
    /**
    Description allows us to print the Int to the console
    */
    public var description: String {
        get { return "\(self)" }
    }
}

/**
IntArray allows us to make checkable Arrays of Ints
*/
public class IntArray {
    let array: [Int]
    
    init(array: [Int]) {
        self.array = array
    }
}

/**
Checkable IntArray extends IntArray
*/
extension IntArray: Checkable {
    
    /**
    arbitrary Array generates a random Array for testing
    */
    class func arbitrary() -> IntArray {
        return IntArray(array: randomArray())
    }
    
    /**
    Random generates a random number
    */
    class func random (#from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % to)
    }
    
    /**
    RandomArray generates a random Array of Ints
    */
    class func randomArray() -> [Int] {
        let randomLength = random(from: 0, to: 100)
        var intArray = [Int]()
        for i in 0..<randomLength {
            intArray.append(random(from: 0, to: Int.max))
        }
        return intArray
    }
    
    /**
    Shrink finds a smaller subset of the given array
    */
    func shrink(numValues: Int) -> [IntArray] {
        let arrayOfSubarrays = ArrayOfAllSubArrays(self.array)
        let numSubArrays = arrayOfSubarrays.count
        var resultArray:[IntArray] = []
        for i in 0..<numValues {
            let index = (Int(arc4random()) % (numSubArrays))
            // force return type to [Int] here, because we set our base array to [Int] above with self.array
            let subArray: [Int] = arrayOfSubarrays[index] as [Int]
            resultArray.append(IntArray(array: subArray))
        }
        return resultArray
    }
    
    /**
    Shrinksize gives the count of the array
    */
    var shrinksize: Int {
        get { return self.array.count }
    }
    
    /**
    Description allows us to print the array to the console
    */
    public var description: String {
        get {
            var resultString = "["
            var i = 0
            for value in self.array {
                resultString += "\(value)"
                if i + 1 < self.array.count - 1 {
                    resultString += ","
                }
                i += 1
            }
            resultString += "]"
            return resultString
        }
    }
}

/**
StringArray allows us to make checkable Arrays of Strings
*/
public class StringArray {
    let array: [String]
    
    init(array: [String]) {
        self.array = array
    }
}

/**
Checkable StringArray extends StringArray
*/
extension StringArray: Checkable {
    
    /**
    arbitrary Array generates a random Array for testing
    */
    class func arbitrary() -> StringArray {
        return StringArray(array: randomArray())
    }
    
    /**
    Random generates a random number
    */
    class func random (#from: Int, to: Int) -> Int {
        return from + (Int(arc4random()) % to)
    }
    
    /**
    RandomString generates a random string
    */
    class func randomString() -> String {
        let randomLength = random(from: 0, to: 100)
        var string = ""
        for i in 0..<randomLength {
            let randomInt : Int = random(from: 13, to: 255)
            string += Character(UnicodeScalar(randomInt))
        }
        return string
    }
    
    /**
    RandomArray generates a random Array of Strings
    */
    class func randomArray() -> [String] {
        let randomLength = random(from: 0, to: 100)
        var stringArray = [String]()
        for i in 0..<randomLength {
            stringArray.append(randomString())
        }
        return stringArray
    }
    
    /**
    Shrink finds a smaller subset of the given array
    */
    func shrink(numValues: Int) -> [StringArray] {
        let arrayOfSubarrays = ArrayOfAllSubArrays(self.array)
        let numSubArrays = arrayOfSubarrays.count
        var resultArray:[StringArray] = []
        for i in 0..<numValues {
            let index = (Int(arc4random()) % (numSubArrays))
            // force return type to [Int] here, because we set our base array to [String] above with self.array
            let subArray: [String] = arrayOfSubarrays[index] as [String]
            resultArray.append(StringArray(array: subArray))
        }
        return resultArray
    }
    
    /**
    Shrinksize gives the count of the array
    */
    var shrinksize: Int {
        get { return self.array.count }
    }
    
    /**
    Description allows us to print the array to the console
    */
    public var description: String {
        get {
            var resultString = "["
            var i = 0
            for value in self.array {
                resultString += "\(value)"
                if i + 1 < self.array.count - 1 {
                    resultString += ","
                }
                i += 1
            }
            resultString += "]"
            return resultString
        }
    }
}


// does this function need to be more general?
// do we want to call this with some resultSet (imagine a fn sig. (prop: X -> TestResult, resultSet: <collection>))


/**
SwiftCheck attempts to check a Checkable type for failure cases

@param times      The number of randomly generated tests to run
@param prop The property to test

@return          A Bool representing whether all test cases passed or whether any failed
*/
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


/**
ShrinkCheck attempts to shrink a failing test case to find the minimal possible failure case derived from it.

@param initial      The value that already failed to satisfy the property
@param times      The number of shrunken values to generate from this initial value
@param prop The property to test

@return          A failing value representing the smallest value found that still fails to satisfy the property
*/
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

/**
ArrayOfAllSubstrings gives a random unique substring from the array of all possible substrings, without first having to generate the array
*/
struct ArrayOfAllSubstrings {
    let baseString : String
    init(_ s: String) {
        self.baseString = s
    }
    var count : Int {
        return triangularSum(countElements(self.baseString))
    }
    // insert long description of algorithm here
    // HERE BE DRAGONS
    // a needlessly clever way to generate all possible unique substrings
    // 0 <= i < s.count
    subscript(i:Int) -> String {
        // computes the substring at this index when accessed through arrayOfSubstrings[index]
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
    
    // the triangular sum is the sum of all integers from 0 to n
    private func triangularSum(n: Int) -> Int {
        return (n * n + n)/2
    }
}


/**
ArrayOfAllSubArrays gives a random unique subarray from the array of all possible subarrays, without first having to generate the array
*/
struct ArrayOfAllSubArrays {
    let baseArray : [AnyObject]
    init(_ a: [AnyObject]) {
        self.baseArray = a
    }
    var count : Int {
        return triangularSum(self.baseArray.count)
    }
    // insert long description of algorithm here
    // HERE BE DRAGONS
    // a needlessly clever way to generate all possible unique subarrays
    // 0 <= i < a.count
    subscript(i:Int) -> [AnyObject] {
        // computes the subarray at this index when accessed through arrayOfSubarrays[index]
        let x = wiggleRoom(i)
            let L : Int = baseArray.count - x
            let j : Int = i - triangularSum(x)
            return slice(start: j,length: L)
    }
    
    private func slice(#start: Int, length: Int) -> [AnyObject] {
        let slicedArray: [AnyObject] = Array<AnyObject>(self.baseArray[start..<start+length])
        return slicedArray
    }
    
    private func wiggleRoom(i : Int) -> Int {
        let magic = (-1 + sqrt((8 * Float(i)) + 1)) / 2 // TODO: naming
        return Int(floor(magic))
    }
    
    // the triangular sum is the sum of all integers from 0 to n
    private func triangularSum(n: Int) -> Int {
        return (n * n + n)/2
    }
}