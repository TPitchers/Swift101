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
thing = "Hey" as Int \\ Cannot convert value of type 'String' to type 'Int' in coercion
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

Along with being strict about types swift is also strict about mutability and in some cases requires you to declare methods as `mutating`. Swift has two keywords for declaring objects, `let` and `var`. `let` is for constants and `var` is for variables. 

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

## First Class Functions

# Language Enhancements/Extensions
language Features that are available in Objective-C, but have extended functionality in Swift.
## Enum

## Switch

## extensions

## Protocols

## Arrays - Map/Reduce/Filter/Flatten

# Cocoa API Differences

## Grand Central Dispatch (GCD)

# Useful Links

[Styling](https://github.com/raywenderlich/swift-style-guide)

[Apple Documentation](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/)

[stack overflow documentation](https://stackoverflow.com/documentation/swift/topics)
