Swift101
===

# Basics

Before starting we recommend taking a look through the following link which will give you a basic overlook of the language syntax.

[LearnXinYminutes](https://learnxinyminutes.com/docs/swift/)

# Language Additions
To start, we plan to go through new features of the language that differentiate it from Objective-C. A major theme throughout (if not all) is type safety and extensibility. 

## Type Safety

To start it off we will discuss type safety and what it means when developing. When we say type safety we mean compile time checks that stop the app being built with unknown state. 

For example casting. In Objective-C the following code compiles:

``` objective-c
NSInteger testInt;
testInt = (NSInteger)@"Hey";
```

While the equivalent code in Swift does not:

``` swift
let thing: Int;
thing = "Hey" as Int \\ 🛑 Cannot convert value of type 'String' to type 'Int' in coercion
```

This can be overridden with the `bang` operator `!`  however there are only a couple places where this should be used:

1. Casting down (such as casting `UITableViewCell` to a subclass)

   ``` swift
   let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath) as! CustomCell
   ```

2. When explicitly unwrapping optionals in a situation where you know they shouldn't be nil (and if they are the app should crash due to unknown state)

   ``` swift
   let url = URL(string: "https://google.com")!
   ```

3. When dealing with Objective-C code that isn't correctly typed and bridged

   ``` swift
   let arrayOfStrings = objCClass.getArray() as! [String]
   ```

When possible you should avoid using this operator and explore other methods that are more type safe. There are some examples that can be shown later that show this.

Along with being strict about types swift is also strict about mutability and in some cases requires you to declare methods as `mutating`. Swift has two keywords for declarations, `let` and `var`. `let` is for constants and `var` is for variables. 

The recommendation is to use `let` for everything to begin with and switch to `var` if what you are doing is not possible. The main reasons for this are compile time optimisations and object consistency. 

Time for an example, adding things to an array.

``` swift
let arrayOfNames = ["Tom", "Torin", "Ricardo"]

var characterCounts = [Int]()
for name in arrayOfNames {
    characterCounts.append(name.count)
}
```

Before, you might have done something like the above, however `characterCounts` is a variable means it could be changed. To avoid this we can use swifts `map` function that can map all items in an array to something else.

``` swift
let arrayOfNames = ["Tom", "Torin", "Ricardo"]
let characterCounts = arrayOfNames.map { (name) -> Int in
    name.count
}
```

This allows `characterCounts` to be declared as a constant, takes up less lines, and makes the code more readable.

You may have noticed during the above code that not everything needs to be specifically declared, this doesn't mean the type system isn't in play however. Instead something called `type inference` is happening. This is where the compiler can infer the type of a declaration based on its input.

``` swift
let myString = "Hello, World!" // Clearly a string
let myBool = true // Clearly a bool
let myInt = 1 // Clearly an int
```

This may not be perfect 100% of the time however. For example if you want a CGFloat.

``` swift
let myFloat = 0.0 // Actually a Double because of type inference
let myActualFloat: CGFloat = 0.0 // Specifying a type will avoid this problem
```

You should try to avoid specifying types when it's clear what the type is.

A great way this comes in handy is not needing to type full enum cases if the type can be inferred.

``` swift
view.backgroundColor = .red // rather than `UIColor.red`
let rect = CGRect(frame: .zero) // rather than `CGRect.zero`
```

This is much nicer to read.

## Optionals

Along with swifts strict type safety is its strict declaration of optionals (objects that could be nil). If declaration isn't marked as optional it must have a value before it can be used. If it's property on a class or struct then it must be assigned a value before the initialiser is finished.

Here are some examples:

1. Can't use a variable that isn't optional before it has been assigned a value.

   ``` swift
    // Doesn't work
    var myInt: Int
    print(myInt) // 🛑 Constant 'myInt' used before being initialized

   // Does work
    var myInt: Int? // Defaults to nil
    print(myInt) // Works fine
   ```

2. Properties must be set before initialiser is finished.

   ``` swift
   // Doesn't work
   class MyClass {
       var property: Int
       init() { } // 🛑 Return from initializer without initializing all stored properties
   }

   // Does work
   class MyClass {
       var property: Int?
       init() { } // `property` defaults to nil
   }
   ```

   Note that with the above examples `var` is used. This is because `let` doesn't default to nil if not assigned because if it was you wouldn't be able to change it later (it can only be assigned once and being assigned nil counts).


Under the hood optionals are actually an enum with two cases, `.none` and `.some(wrapped)`. You may notice that `.some(wrapped)` has a variable attached, this is something we will get to later.

### `switch`

Unlike Objective-C swift is very strict about optionals and won't let you use a variable that is optional without first unwrapping it. Since it's an enum this can be done with a switch.

``` swift
switch myVariable {
case let .some(wrapped):
    print("It has the value: \(wrapped)")
case .none:
    print("There is no value to be found")
}
```

This is quite cumbersome however so swift provides some better ways. 

### `if let`

The first is `if let` which gives you the unwrapped value for use in an if statement.

``` swift
if let myUnwrappedVariable = myVariable {
    print("I have the valiable \(myUnwrappedVariable)")
}
```

You don't have to make a new name for the variable however. Swift will (within that block) realise the variable isn't nil and treat it as normal.

``` swift
if let myVariable = myVariable {
    print("I have the valiable \(myVariable)")
}
```

 This structure isn't great if you need to unwrap lots of variables though as you will just end up in nested hell.

``` swift
if let myVariable = myVariable {
    if let property = myVariable.property {
        if let otherProperty = property.otherProperty {
            // Run code here
        }
    }
}
```

Fortunately unwraps can be chained meaning you only go one level deep.

``` swift
if let myVariable = myVariable,
    let property = myVariable.property,
    let otherProperty = property.otherProperty {
    // run code here
}
```

Sometimes if the value isn't there they you should just return, swift provides a way to do that as well.

### `guard`

`guard` is a way to back-out of a function without the entire function becoming nested deeper. It can be used the same way `if` can and also allows for unwrapping optionals just like `if let`.

``` swift
func doesSomething(neededVariable: Thing?) {
    if let myVariable = myVariable,
        let property = myVariable.property,
        let otherProperty = property.otherProperty {
        
        let anotherThing = otherProperty.doSomething()
        
        if let anotherThing = anotherThing,
            let anotherThingProperty = anotherThing.property,
            let lastProperty = anotherThingProperty.otherProperty {
            // Run code two levels deep
        } else {
            return
        }
        // More code here
    }
}
```

In this example all the code that would run is one or two levels deep in the function which can cause ugly and hard to read code. This doesn't just apply to optionals either, Objective-C can look just as bad when using lots of nested `if`s. This is what `guard` aims to solve. The code above would be come this.

``` swift
func doesSomething(neededVariable: Thing?) {
    guard let myVariable = myVariable,
        let property = myVariable.property,
        let otherProperty = property.otherProperty else {
            return
    }
    
    let anotherThing = otherProperty.doSomething()
    
    guard let anotherThing = anotherThing,
        let anotherThingProperty = anotherThing.property,
        let lastProperty = anotherThingProperty.otherProperty else {
            return
    }
    
    // More code here
}
```

Each piece of code is able to follow on from the last. Guard can also be used to provide more context rather than crashing.

``` swift
guard let value = variable else {
    fatalError("The value should not be nil, did you remember to do x?")
}
```

### Default values

Often when you have an optional value you just want to use a default value if it's nil. To avoid unwrapping just to see if a default value swift allows you to do `nil coalescing`

``` swift
let nonOptionalVariable = optionalVariable ?? "Default variable"
```

### Optional Chaining

Another tool that swift gives you is `optional chaining` which allows you to use variables and there functions as normal but the values returned will be optional and only run if there is variable there but ignored if there isn't. 

This

``` swift
guard let object = myVariable else { return }
let someProperty = object.getProperty()
```

Becomes 

``` swift
let someProperty = object?.getProperty() // `someProperty` is now an optional
```

These can be chained and then a nil check can be done at the end rather than at every step.

``` swift
let property = myVariable?.property
let otherProperty = property?.otherProperty

let anotherThing = otherProperty?.doSomething()
let anotherThingProperty = anotherThing?.property
let lastProperty = anotherThingProperty?.otherProperty

let valueWeWant = lastProperty ?? Thing() // won't be optional because of coalesing
```

This can be shortened further by putting things onto one line (although it is still best to add some splits for readability).

``` swift
let otherProperty = myVariable?.property?.otherProperty
let anotherThing = otherProperty?.doSomething()
let valueWeWant = anotherThing?.property?.otherProperty ?? Thing() // won't be optional because of coalesing
```

### Explicit (🚫18+ only🚫)

The last way to unwrap optionals is explicitly. This should be avoided when possible as it is unsafe. At the same time however, it **should** be used if you know a value should be there. This is because it forces the app to crash if there isn't, stopping `defensive programming` and making sure the app is in an expected state.

This is done using the `bang!` operator (which is an appropriate name in this case).

``` swift
let myValue = optionalVariable!
```

The operator can also be used for properties on structs and classes that you know will have a value by the time you want to use them, such as `UIViews` on a `UIViewController`, which should not be nil by the time the `viewDidLoad` method is called. This then treats the variable as a normal variable and the need to unwrap is gone.

``` swift
class viewController: UIViewController {
    @IBOutlet var myView: UIView! // notice the `!`
    
    override func viewDidLoad() {
        myView.doSomething() // no need for `?`
    }
}
```

## First Class Functions

A major difference between Objective-C and Swift is first class functions. What does this mean? It means functions are a type just like `String` and `Int`. That means they can be passed as parameters to other functions, or stored in variables. Functions have a special signature to define themselves, the most basic being `() -> ()` which is a function that takes no parameters and returns nothing. Other examples include:

``` swift
(String) -> () // Takes a String and return nothing
(String) -> String // Takes a String and returns a String
(Int, Int) -> String // Takes two Ints and returns a String
([Int]) -> [String] // Takes an array of Ints and returns an array of Strings
(String) -> (String, Int) // Takes a String and returns a Tuple of String and Int
```

Heres an example of assigning a function to a variable:

``` Swift
let function: (String) -> (string: String, characterCount: Int) = { value in
    return (value, value.count)
}
```

Slight aside on tuples. A tuple is a grouping of values without the need for a data structure like classes or structs. The can be made by just putting some values in brackets, e.g. `let tuple = (myValue, myOtherValue)`. The values can be accessed by number `tuple.0`. Tuples can also be named e.g. `let stringAndCount = (string: myString, characterCount: myString.count)` and the values can be accessed by name `stringAndCount.characterCount`.

*Back to functions*

As previously mentioned, functions can be passed as arguments to other functions. A common way this is used is as a completion handler for an asynchronous task. A common example is networkings code.

Assume we have a function that logs in a user. It takes a username, password and a completion handler with a bool for success and an optional string error message for when the bool is false. This functions signature would be the following:

``` Swift
func loginUser(withUsername: String, password: String, completion: (Bool, String?) -> ())
```

When calling this function our code would look like this:

``` swift
loginUser(withUsername: "Test", password: "Test", completion: { (success, errorMessage) in
    // Do stuff with results
})
```

In the above a `closure` is passed which is a self contained function, but we could pass a defined function in if we like:

``` swift
func completion(_ success: Bool, errorMessage: String?) {
    // Do stuff with results
}

loginUser(withUsername: "Tom", password: "Test", completion: completion(_:errorMessage:))
```

The first option is often preferred as it is easier to read but the second option can be used to help split up code. Something that the first option allows is trailing closures, which are a slightly different bit of syntactic sugar to make it look nicer. 

``` swift
loginUser(withUsername: "Tom", password: "Test") { (success, errorMessage) in
    // Do stuff here
}
```

This allows you to emit the completion name for the last parameter and have the closure hang of the edge. Again this is purely an aesthetic change.

There is no reason why multiple functions can't be passed into a function. There is no better example of this than `UIView.animate` which has a function for the animations and a function for completion.

``` swift
UIView.animate(withDuration: 1, animations: {
    // Animations here
}) { (completed) in
    // Animation completed
}
```

# Language Enhancements/Extensions

language Features that are available in Objective-C, but have extended functionality in Swift.
## Enum

## Switch

## extensions

## Protocols

## Arrays - Map/Sort/Filter/Reduce/FlatMap

#### Map

Map takes an array of one thing and returns array of another thing (or the same thing). It's goal is to replace for loops with a concise function. In the following example we want to get an array of character counts for an array of strings.

```swift
let counts = ["Tom", "Torin", "Ricardo"].map { (name) -> Int in
    return name.count
}
```

If the closure is only one line the return can even be emitted.

```swift
let counts = ["Tom", "Torin", "Ricardo"].map { (name) -> Int in
    name.count
}
```

**But we can go further!** 

The parameter name can be emitted and replaced with `$0` as that represents the first parameter in a closure (`$1`, `$2` etc. represent following parameters if there are any). Also the return type can be inferred by swift. In this case it's clear we are converting to an `Int`. The final statement becomes this:

```swift
let counts = ["Tom", "Torin", "Ricardo"].map { $0.count }
```

*Beautiful*

This also works on `Dictionary`s  but the result will always be an array. For example:

```swift
let contrivedExampleOfNumbersAndStringsForDemo = ["String 1":5, "String 2":3, "String 3":9, "String 4":2]
let descriptionsOfContrivedExample = contrivedExampleOfNumbersAndStringsForDemo.map { "\($0.key) is \($0.value)" } // result = ["String 2 is 3", "String 3 is 9", "String 1 is 5", "String 4 is 2"]
```

One thing you will notice from the above is that the results are out of order. This is because `Dictionary` (and also `Set`) are unordered.

If you wish to map only the values of a `Dictionary` and keep the keys the same that is possible with `mapValues` which gives you a `Dictionary` back.

```swift
let stringifiedNumbers = contrivedExampleOfNumbersAndStringsForDemo.mapValues { $0*$0 }
// the numbers have been squared["String 2": 9, "String 3": 81, "String 1": 25, "String 4": 4]
```

#### Sort

That's enough about map. Next is sort which (as I'm sure you can guess) sorts a collection.

```Swift
let ordereredNumbers = [4,1,3,51,12,5,31,8,7].sorted { (number1, number2) -> Bool in
    number1 < number2
} // [1, 3, 4, 5, 7, 8, 12, 31, 51]
```

 Of course this can be simplified greatly.

```swift
let ordereredNumbers = [4,1,3,51,12,5,31,8,7].sorted { $0 < $1 } // [1, 3, 4, 5, 7, 8, 12, 31, 51]
```

Actually, since we are sorting `Int`s swift does this for us without needing to do anything.

```swift
let ordereredNumbers = [4,1,3,51,12,5,31,8,7].sorted() // [1, 3, 4, 5, 7, 8, 12, 31, 51]
```

#### Filter

Filter allows you to remove unwanted items from a collection.

```swift
let filteredNumbers = [1, 3, 4, 5, 7, 8, 12, 31, 51].filter { (number) -> Bool in
    number < 10
} // [1, 3, 4, 5, 7, 8]
```

Once again, shorter!

```swift
let filteredNumbers = [1, 3, 4, 5, 7, 8, 12, 31, 51].filter { $0 < 10 } // [1, 3, 4, 5, 7, 8]
```

#### Reduce

The aim of reduce is to take a collection and return a single value. For example adding a bunch of numbers together.

```swift
let ultimateNumber = [1, 3, 4, 5, 7, 8].reduce(0) { (current, next) -> Int in
    current + next
} // 28
```

The first parameter is the starting value and in each call of the closure you are passed the running total and the next parameter. In this case we are starting from 0 and adding the next value to the running total.

Like the others this function can be shortened, although if you go all the way it can be a little unreadable...

```swift
[1, 3, 4, 5, 7, 8].reduce(0, +) // 28
```

#### FlatMap

The last built in collection function is FlatMap which takes a collection of collections and makes them a single collection.

```swift
[["28", "8", "3"], ["19", "4", "9"], ["6",  "13", "5"]].flatMap { (array) -> Array<String> in
    return array
} // ["28", "8", "3", "19", "4", "9", "6", "13", "5"]
```

The shortened one looks like a little nicer.

```swift
[["28", "8", "3"], ["19", "4", "9"], ["6",  "13", "5"]].flatMap { $0 } // ["28", "8", "3", "19", "4", "9", "6", "13", "5"]
```

#### Chain

All of the functions can be combined and run one after the other. In this example we will take a collection of collections of strings and end up with a single number.

```swift
let total = initialArray
    .flatMap { $0 }
    .map { Int($0) }
    .flatMap{ $0 } // FlatMap also removes nils from a collection
    .filter { $0 < 10 ? true : false }
    .reduce(0) { $0 + $1 } // 35
```

# Cocoa API Differences

## Grand Central Dispatch (GCD)

# Useful Links

[Styling](https://github.com/raywenderlich/swift-style-guide)

[Apple Documentation](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/)

[stack overflow documentation](https://stackoverflow.com/documentation/swift/topics)

 ```

 ```