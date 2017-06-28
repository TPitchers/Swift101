import UIKit

/*
 Swift is often called a Protocol-Oriented language. This means many things are thought about in a protocol way, and protocols can provide a lot more functionality then their Objective-C counterpart.
 
 Firstly the are considered types and are fully type checked just like the rest of swift
 */
protocol Stringable {
    func getString() -> String
}

struct ExampleStruct: Stringable {
    func getString() -> String {
        return "Example string"
    }
}

func expectsStringableProtocol(stringableProtocol: Stringable) {
    print(stringableProtocol.getString())
}

let example = ExampleStruct()
expectsStringableProtocol(stringableProtocol: example)

/*
 Protocols in swift also support inheritence of other protocols. This allows you to compose multiple protocols together
 */

protocol Intable {
    func getInt() -> Int
}

protocol Boolable {
    func getBool() -> Bool
}

protocol ValueTypeable: Stringable, Intable, Boolable { }

struct SomeValueStruct: ValueTypeable {
    func getString() -> String {
        return "string value"
    }
    func getInt() -> Int {
        return 0
    }
    func getBool() -> Bool {
        return true
    }
}

/*
 Sometimes you want a default implementation of a protocol rather than rewriting the same code each time you implement it. This can be done in swift with extensions
 */
extension ValueTypeable {
    func getBool() -> Bool {
        return false
    }
    func getString() -> String {
        return "Default String"
    }
    func getInt() -> Int {
        return 5
    }
}

/*
 This means all you have to do to implement it is make a type inherit from it
 */
struct AnotherType: ValueTypeable { }

print(AnotherType().getString())

/*
 Extensions can be used to add conformance to a protocol that didn't originally conform to it.
 */
extension UIView: ValueTypeable {
    func getInt() -> Int {
        return Int(frame.width*frame.height)
    }
    func getBool() -> Bool {
        return isUserInteractionEnabled
    }
    func getString() -> String {
        return "The alpha is \(alpha)"
    }
}

/*
 In swift this is often used to break up code in a single file. This makes code easier to read and splits code into sections without needing comments. A perfect example is making a ViewController conform to UITableViewDataSource
 */
class ViewController: UIViewController {
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
}

/*
 Protocol extensions can also be constrained, for example when you want a default implementation for certain objects
 */
extension Array: ValueTypeable { }

extension Array where Element == String {
    func getString() -> String{
        return self.reduce("") { (last, next) -> String in
            if last == "" {
                return next
            } else {
                return "\(last), \(next)"
            }
        }
    }
}

print(["one", "two", "three"].getString())

