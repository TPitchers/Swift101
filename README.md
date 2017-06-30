Swift101
===

[TOC]

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

# Language Enhancements

While swift has many new things it also has many major advancements on top of existing concepts from Objective-C.
## Enum

Enums are the first enhancement we will talk about. They are defined like so:

``` swift
enum MyEnum {
	case something
	case somethingElse
}
```

The convention is to use PascalCase for the name of the enum and camelCase for the cases. You can access an enum with dot notation. 

``` swift
let something = MyEnum.something
```

Enums can also extend certain types. In Objective-C all enums are `Int`s under the hood but Swift allows them to be `String`s, `Float`s, `Int`s and others. This saves you writing a function that takes an enum case and returns the type you actually want.

Along with this enums can have associated values which can provide extra context to the enum. This saves the need for extra types or tuples and helpes readability. 

A common example of this being used is in network requests. The two cases are usually `success` paired with a piece of data, or `error` paired with an error type of some sort. In Swift this could be expressed in an enum like this:

``` swift
enum NetworkResult {
    case success(Item)
    case error(Error)
}
```

These enums are created by providing the value.

``` swift
let result = NetworkResult.success(item)
let result = NetworkResult.errror(error)
```

And then they can be accessed via a `switch`.

``` swift
switch result {
case let .success(item):
    // do stuff with item
case let .error(error):
    // do stuff with error
}
```

Along with storing values, they can be made generic. The above enum is great if that type of enum is only going to be used once but it's quite common for something to have a success and error. The generic version looks like this:

``` swift
enum NetworkResult<T> {
    case success(T)
    case error(Error)
}
```

Then when you use it:

``` swift
let result = NetworkResult<String>.success("Hello, World!")
```

On top of this enums can also have both computed properties and functions.

``` swift
enum Theme {
    case light, dark
    
    var primaryColor: UIColor {
        switch self {
        case .light: return .red
        case .dark: return .blue
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .light: return .white
        case .dark: return .darkGray
        }
    }
}
```

This means if you have an instance of the enum you can access these functions and properties.

``` swift
let currentTheme = Theme.light
view.backgroundColor = currentTheme.backgroudColor
view.tintColor = currentTheme.primaryColor
```

## Switch

Unlike switch statemens in other languages that only match a set of things, swifts is a lot more expresive. We have already seen a few switch statements so rather than going over the basics again we will go straight in to the unique parts.

Firstly, switches in swift **must** be exhaustive. This means you either have to have a default or you must cover every case (e.g. every case in an enum).

``` swift
switch number {
case 1:
    number+=1
case 2:
    number+=2
default:
    break
}
```

Secondly, no `break` after each case. Unlike other langauges swifts switches don't implicitly fallthrough.You have to tell it to `fallthrough` yourself.

``` swift
switch number {
case 1:
    number+=1
    fallthrough
case 2:
    number+=2
    fallthrough
default:
    break
}
```

If you don't want to run anything in a statement you can call `break` like we do here in the `default` block.

Switches in swift can also match intervals.

``` swift
switch number {
case 0..<10:
    break
case 10..<100:
    break
case 100..<1000:
    break
default
    break
}
```

They can also be used to do pattern matching with tuples.

``` swift
let point = (1,1)
switch point {
case (0,0):
    print("You are in the center")
case (1..., 1...):
    print("In the positive in both directions")
case (1..., _):
    print("Positive in the X direction")
case (_, 1...):
    print("Positive in the Y direction")
default:
    print("You're in the negative")
}
```

*The `…` here is for ranges. In this case they are open ranges meaning they go from `1` to `∞`.*

## Extensions

Extensions, similar to Objective-C's catagory extensions, can be used add new functionality to excisting types. Swift has a few extras that Objective-C doesn't however. Swift is also unique in that the community has gathered around the convention of using extensions for seperating code, rather than shoving it all in to a single class. This doesn't mean seperate files however. We will get to this soon.

First we will start with a simple example of adding a function to a class that we don't own.

``` swift
extension Array {
    mutating func move(fromPosistion: Int, toPosistion: Int) {
        let element = remove(at: fromPosistion)
        insert(element, at: toPosistion)
    }
}
```

This simple extension adds a move function to arrays that moves an element from one position to another.

Extensions can also be used to add new properties to an excisting type. At the moment these can only be computed properties but there are talks of adding stored properties in future versions (hopefully v5).

``` swift
extension Bool {
    var not: Bool {
        return !self
    }
}

if {expression}.not // much nicer than !{expression}
```

Another thing extensions can be used to add are subscripts.

``` swift
extension String {
    subscript(characterIndex: Int) -> Character {
        return self[index(self.startIndex, offsetBy: characterIndex)]
    }
}

let character = "Hello"[2] // 'l'
```

Initialisers can also be added with extensions. If it is a class you need to add the keyword `convenience` before the `init` keyword. 

``` swift
extension Bool {
    init(oppositeOf opposite: Bool) {
        self.init(opposite.not)
    }
}
```

This extension allows you to make an opposite `Bool` from another `Bool` (or expression that evaluates to a `Bool`).

## Protocols

Protocols in swift offer a lot more flexability when compared to there Objective-C counterpart. Firstly they are classed as types just like structs, classes, etc. Also they are type checked by the compiler to enforce conformance. A disadvantage swift protocols have when compared to Objective-C is the lack of optional methods or parameters, there are a couple work arounds for this though that will be discussed later.

Let's set up an example. We'll start with a `Person` struct.

``` swift
struct Person {
    var firstName: String
    var lastName: String
    // ...
}
```

We want to make our `Person` identifiable in some way, so we will define a protocol for identifiability.	

``` swift
protocol Identifiable {
    var identifier: String { get }
}
```

This protocol defines a variable called `identifier` property that returns a `String`. We have set the property to only be `get`able, so it can't be set by outside sources. Let's add it to our person.

There are two ways we can do this, the first is to make it the same as any other property.

``` swift
struct Person: Identifiable {
    // ...
    var identifier: String
    // ...
}
```

Even though the protocol only says the property is gettable, because we added it just like we would other properties, we could still set it if we wanted.

``` swift
var tom = Person(firstName: "Tom", lastName: "String", identifier: "1")
tom.identifier = "2" // Completely valid
```

The second way to satisfy the requirement of the protocol is to use a computed property.

``` swift
extension Person: Identifiable {
    var identifier: String {
        return "\(firstName.first!)\(lastName.first!)_\(UUID().uuidString)"
    }
}
```

A couple things to note here. Firstly this is a terrible way to get an identifier because each time it's asked for it will be different. Secondly we are using an extension. In swift the convention is to use extensions in the same file to help seperate the code into clear chunks. This doesn't work for the first option as extensions can't be used to add stored properties but they can be used for functions and computed properties.

A common example of this convention is a `UIViewController` implementing `UITableViewDataSource` and `UITableViewDelegate` in the same file.

``` swift
class ViewController: UIViewController {
    
    // ...
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        // ...
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ...
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ...
    }
}
```

This seperates the logic of different parts of the view controller, alleviating some of the massive view controller problems.

Extensions can also be used in another way with protocols, and that's default implementations. This is the first solution to solving the lack of optional methods.

Let's take a common example we all hate with identifying UITableViewCells. It's very common to make the "cell identifier" the same as the name UITableViewCell subclass e.g. `ItemCell` will have the table view identifier `ItemCell`. 

``` swift
let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
```

As good developers we try to avoid rewriting the same string multiple times so we usually define a constant somewhere.

``` swift
let ItemCellIdentifier = "ItemCell" // at top of file somewhere
let cell = tableView.dequeueReusableCell(withIdentifier: ItemCellIdentifier, for: indexPath)
```

This is ugly and just bloats out code. There is a better way. First we will make a change to our `Identifiable` protocol from earlier.

 ``` swift
protocol Identifiable {
    static var identifier: String { get }
}
 ```

By making the `identifier` property `static` we are saying the type, not an instance needs to have the property. Using our `Identifiable` protocol and default implementations through extensions we can make anything that comforms to `Identifiable` get this for free. 

``` swift
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
```

This makes anything that implements identifiable get that behaviour without needing to do it themselves. In our case we want it on UIViews.

``` swift
extension UIView: Identifiable { }
```

That single line is all that's needed to make all UIViews return the name of their class as the `identifier` property. Our cell line now looks like this:

``` swift
let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath)
```

This identifier can also be used for registering a nib.

``` swift
tableView.register(nib, forCellReuseIdentifier: ItemCell.identifier)
```

Along with properties methods can be added. Delegation is the most common use case for this, time for another example. Here we have a custom view that appears as a dial with individual steps.

``` swift
class DialView: UIView {
    var minValue: Float = 0
    var maxValue: Float = 1
    var steps: Int = 10
    // ...
}
```

Now let's add a new dial to our shiny new amp 🎵.

``` swift
self.volumeDial = Dial()
volumeDial.minValue = 0
volumeDial.maxValue = 11 // Turn it up to 11 🤘👅🤘
volumeDial.steps = 11
```

Now we want a way to be notified everytime the dial is turned. Protocols to the rescue.

``` swift
protocol DialViewDelegate {
    func dialView(_ dialView: DialView, didTurnToValue value: Float)
}
```

The naming convention (quite similar to ObjC) is to have the function named the name of the view that the delegate is for (in this case `DialView`). The first parameter should be the `DialView` that called the method so that if the implemented has multiple of the same view you can identify which one sent it (this parameter should be unnamed using `_`, I'll explain this in a sec). The second parameter should allow the function to be identified (in this case it is `didTurnToValue`).

Implemented it looks like this:

``` swift
class Amp: DialViewDelegate {
    // ...
    func dialView(_ dialView: DialView, didTurnToValue value: Float) {
        self.volume = 11 // Ignore the value given and turn it up to 11 anyway
    }
}
```

The method signiture is something we haven't gone over much yet so now is a good time to explain it. First we have the function name `dialView`. In swift parameters are named just like Objective-C but if we don't want it to be named we can put a `_` character. After that we have the name for use within the function which here is `dialView` followed by a colon and the type `DialView`. Next we have a comma and then it repeats.

The above function would look like this when being called:

``` swift
delegate.dialView(self, didTurnToValue: 11)
```

Which reads as "Hey delegate, the dial view `self`(me) turned to value `11`". 

This rule is broken if the delegate function only has 1 parameter and that parameter is the called. For example let's take our `DialView` and its delegate and make it return the number of steps similar to a tableview returning the number of sections. The function is the protocol would look like this:

```  swift
func numberOfSteps(in dialView: DialView) -> Int
```

This is because the named parameters cannot provide enough information about the role of the function. Like I mentioned before the `UITableViewDataSource` protocol suffers from this. It has the functions:

``` swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
func numberOfSections(in tableView: UITableView) -> Int
```

Notice the second one doesn't have the oppertunity to provide the detail of the function in the parameters like the first one does. Out of interest this is what these functions look like when being called:

``` swift
delegate.numberOfSections(in: self) // how many sections are there in me?
delegate.tableView(self, numberOfRowsInSection: 1) // in me how many rows are there in section 1
```

Protocols can also be used to impose initialiser requirements. 

``` swift
protocol Themeable {
    init(withTheme theme: Theme)
}
```

A problem with using protocols with initialisers is that initialisers in protocol implementations must be required, and required initialsers have to be in the base implementaiton, meaning you can't add a protocol with an initialiser in an extension.







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