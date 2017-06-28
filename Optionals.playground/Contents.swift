import UIKit

/*
 Optionals are swifts way to avoid crashes when a value is missing. The benifit of optionsals is (common theme) is that they are compile time checked, stopping you from writing running code that can fail.
 */

var optionalValue: String? = nil

/*
 Optionals, under the hood, are an enum with two cases:
 - .none: There is no value
 - .some(value): There is a value
 
 This means you can use a switch to get a value
 */
switch optionalValue {
case .none:
    print("The optional is empty")
case let .some(value):
    print("The optional has the value \(value)")
}

optionalValue = "Hello World"

switch optionalValue {
case .none:
    print("The optional is empty")
case let .some(value):
    print("The optional has the value \(value)")
}

/*
 This syntax is quite cumbersome to put throughtout your code however, so swift has a simplier way, if let.
 
 if let is a way to unwrap an optional in an if statement, the same way you would check if a value in nil in Objective-C. The difference being this time it's compile time checked.
 */

if let value = optionalValue {
    print("The value is \(value)")
}

/*
 This syntax can also be used to check a variables type
 */
let something: Any
something = "A string"

if let something = something as? String {
    print("something is a string and it's value is \(something)")
}

/*
 Along with if let swift also introduces another construct to check optionals: guard.
 
 guard is away to check a condition, and if that condition is false, backout of the current function.
 */
func printOptionalString(string: String?) {
    guard let string = string else {
        print("The value provided is nil")
        return
    }
    print(string)
}

printOptionalString(string: nil)
printOptionalString(string: "A value")

/*
 Just like if let, guard can be used for multiple things, not just optionals. Also, both if let and guard can run multiple statements at the same time
 */

func printPotentialString(potentialString: Any?) {
    guard let object = potentialString,
        let string = object as? String else {
            print("The object provided was either nil, or not a string")
            return
    }
    print(string)
}

printPotentialString(potentialString: nil)
printPotentialString(potentialString: 1)
printPotentialString(potentialString: "A value")

/*
 Always having to optionally unwrap variables everytime you want to use them would be a pain, especially if you know there is a value and if there isn't the app should crash. To do that you can explicitly unwrap a variable. Note that this will cause the app to crash if it is nil.
 
 This is done with an exclamation mark!
 */

let definitelyHasAValue: String? = "The value is definitely here"
print(definitelyHasAValue!)

/*
 If you want to declare a variable that could be nil but always know that when it's used it will have a value then the exclamation mark can be put in the declaration
 
 This way you can use the variable as if it weren't optional but it's very important to note that if you use it while it is nil, CRASH!
 */

var willHaveAValueWhenIUseIt: String! = nil

willHaveAValueWhenIUseIt = "Now has a value"
print(willHaveAValueWhenIUseIt)

