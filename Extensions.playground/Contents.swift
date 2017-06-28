import UIKit

/*
 Extensions are a way to add extra functionality to an object. Often it's one you don't own such as UIKit classes, but swift also promotes using extensions for your own objects as a way to keep functionality seperated.
 
 The naming convention for this is `{Class Being Extended}+{What it's being extended with}.swift` e.g. `UIView+Stringable.swift`. Throughout this file I'll give examples of what I would name the extensions if I were to seperate them out, however many times the extension could just be in the same file as the original type and only seperated to help structure the code.
 */

/*
 The first thing extensions can be used to add is computed properties. These are properties that don't corrospond directly to a variable but instead run a piece of code similar to a function. The main benifit of this is something that looks like a variable but is actually a funtion under the hood.
 */
struct Person {
    var firstName: String
    var lastName: String
    var middleNames: [String]
    
    init(firstName: String, lastName: String, middleNames: [String] = []) {
        self.firstName = firstName
        self.lastName = lastName
        self.middleNames = middleNames
    }
}

// Person+fullName.swift
extension Person {
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

let me = Person(firstName: "Tom", lastName: "Singleton")

print(me.fullName)

/*
 The next, and most obvious, thing that can be added are extra functions.
 */
//Person+capitialisation.swift
extension Person {
    func getCapitalisedName() -> String {
        return self.fullName.uppercased()
    }
}

/*
 Along with this, extra initialisers can be added to types through extensions. These are called convinience initialisers and must call the original initialiser at some point.
 
 A great example of why this could be useful is making UIKit classes intialisable with a custom object that we created.
 
 These can make great alternatives to factory methods, although they may be less descriptive. Here is an example of both.
 */
// Person+johnDoe
extension Person {
    init() {
        self.init(firstName: "John", lastName: "Doe")
    }
    
    static func getJohnDoePerson() -> Person {
        return Person(firstName: "John", lastName: "Doe")
    }
}

let john1 = Person()
let john2 = Person.getJohnDoePerson()

/*
 Extensions can also be used to add subscripts to types
 */
// Person+subscript
extension Person {
    subscript(index: Int) -> String {
        switch index {
        case 0:
            return firstName
        case 1...middleNames.count:
            return middleNames[index-1]
        default:
            return lastName
        }
    }
}

let tom = Person(firstName: "Tom", lastName: "Singleton", middleNames: ["William"])
print(tom[0])
print(tom[1])
print(tom[2])

/*
 This can be great for adding subscripts to types that don't have them (but really should)
 */
extension String {
    subscript(range: ClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return self.substring(with: start..<end)
    }
}

//  let firstTwoCharacters = "123456"[0...2]
//  print(firstTwoCharacters)

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        var newString = ""
        for _ in 0..<rhs {
            newString.append(lhs)
        }
        return newString
    }
}

/*
 Having a wide array of extensions for common code can also improve the development experience. Here are some examples of simple extensions.
 */
// Optional+hasValue
extension Optional {
    var hasValue: Bool {
        if case .none = self { return false }
        else { return true }
    }
    
    var isNil: Bool {
        return !hasValue
    }
}

let optional: String? = nil
print(optional.hasValue)
print(optional.isNil)


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 0xff) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xff,
            green: (rgb >> 8) & 0xff,
            blue: rgb & 0xff
        )
    }
    
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xff,
            green: (argb >> 8) & 0xff,
            blue: argb & 0xff,
            alpha: (argb >> 24) & 0xff
        )
    }
}

let color = UIColor(rgb: 0xffffff)
let red = UIColor(rgb: 0xff0000)
let lightRed = UIColor(argb: 0x21ff0000)

extension String {
    var uiColor: UIColor? {
        let hexString: String
        
        if self[0...1] == "#" {
            hexString = self[1...self.count]
        } else {
            hexString = self
        }
        
        let splitHexString: [String]
        switch hexString.count {
        case 8:
            splitHexString = splitupHexString(hexString: hexString)
        case 6:
            splitHexString = splitupHexString(hexString: "ff".appending(hexString))
        case 3:
            let newHexString = hexString*2
            splitHexString = splitupHexString(hexString: "ff".appending(newHexString))
        case 2:
            let newHexString = hexString*3
            splitHexString = splitupHexString(hexString: "ff".appending(newHexString))
        default:
            return nil
        }
        
        let alpha = Int(splitHexString[0], radix: 16)
        let red = Int(splitHexString[1], radix: 16)
        let green = Int(splitHexString[2], radix: 16)
        let blue = Int(splitHexString[3], radix: 16)
        
        return UIColor(red: red!, green: green!, blue: blue!, alpha: alpha!)
    }
    
    private func splitupHexString(hexString: String) -> [String] {
        let alphaString = hexString[0...2]
        let redString = hexString[2...4]
        let greenString = hexString[4...6]
        let blueString = hexString[6...8]
        return [alphaString, redString, greenString, blueString]
    }
}

"#ff2211".uiColor
"#fff".uiColor
"#72000000".uiColor
"123456".uiColor
"#21".uiColor
"#00ff00".uiColor

