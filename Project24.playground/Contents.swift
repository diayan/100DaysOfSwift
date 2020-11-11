import UIKit
import PlaygroundSupport

let name = "Taylor"

for letter in name  {
    print("Give me \(letter)")
}

//let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String{
   subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]


let password = "12345"

password.hasPrefix("123")
password.hasSuffix("456")


//extension to delete prefixes
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        
        return String(self.dropFirst(prefix.count))
    }
}

//extension to delete suffixes
extension String {
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        
        return String(self.dropLast(suffix.count))
    }
}

let weather = "it is going to rain"

weather.deleteSuffix("rain")

//extension to capitalize every first letter of of a string
extension String {
    var capitalizeFirst: String {
        guard let firstLeter = self.first else { return "" }
        
        return firstLeter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalizeFirst)

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Rubi", "Swift"]
languages.contains("Swift")

//containsAny Extension
extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)


//this does the same thing as the containsAny extension above
languages.contains(where: input.contains)




//Formatting strings using NSAttributedString
let string = "This is a test string"

let attribute: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.orange,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attribute)



let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))



