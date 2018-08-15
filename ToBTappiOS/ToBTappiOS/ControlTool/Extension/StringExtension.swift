//
//  StringExtension.swift
//  Test000
//
//  Created by TapplockiOS on 2018/4/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

let nameLenthMax = 10

let passwordLenthMax = 20

let passwordLenthMin = 8

extension String {

    //XX:XX:XX:XX => XXXXXXXX
    var macValue: String {
        get {
            var mac = self.replacingOccurrences(of: ":", with: "")
            mac = mac.uppercased()
            return mac
        }
    }
    //XXXXXXXX => XX:XX:XX:XX
    var macText: String {
        get {
            let mac = macValue.inserting(separator: ":", every: 2)
            
            let arrr = mac.components(separatedBy: ":")
            if arrr.count != 6 {
                return ""
            }
            var xmac = arrr[5] + ":" + arrr[4] + ":" + arrr[3] + ":" + arrr[2] + ":" + arrr[1] + ":" + arrr[0]
            xmac = xmac.uppercased()
            return xmac
            
        }
    }
    //XXXXXXXX => [XX,XX,XX,XX]
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: count, by: 2).forEach {
            result.append(String(characters[$0..<min($0 + 2, count)]))
        }
        return result
    }
    
    // MARK: 判断是否是数字
    var isPurnInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    
    // MARK: 从字符串中提取数字
    var getIntFromStr: String? {
        let scanner = Scanner(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        scanner.scanInt(&number)
        return String(number)
    }
    
    // MARK: 交换
    func exchangeSequence() -> String {
        let front = self[0...1]
        let behind = self[2...3]
        return behind + front
    }
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
         
            case 0x3030, 0x00AE, 0x00A9,
                 0x1D000...0x1F77F,
                 0x2100...0x27BF,
                 0xFE00...0xFE0F,
                 0x1F900...0x1F9FF:
                print(scalar.value)
                return true
            default:
                continue
            }
        }
        return false
    }
    
    var isMail: Bool {
        get {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest.evaluate(with: self)
        }
    }
   
    
    var nameOverlength: Bool {
        return self.length > nameLenthMax
    }
    
    var passwordOverlength: Bool {
        return self.length > passwordLenthMax
    }
    
    var passwordTooShort: Bool {
        return self.length < passwordLenthMin
    }
        
    // 字符串转时间错
    var timeStamp: Int {
        let datefmatter = DateFormatter()
        datefmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = datefmatter.date(from: self)
        let dateStam = date!.timeIntervalSince1970
        return Int(dateStam)
    }

    
}

// 进制转换
extension String {
    
    // "02A9BC" 转 16进制data
    func hexadecimal() -> Data! {
        var data = Data(capacity: self.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
    }
    
    // 16进制转10
    var hexToInt: Int? {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    // 2进制转10进制
    var binToDec: Int? {
        var sun: Int = 0
        for c in self {
            let str = String(c)
            sun = sun * 2 + Int(str)!
        }
        return sun
    }
    
    // 10进制转其他进制
    func decimalConver(rax: Int = 16) -> String? {
        let sum = Int(self)
        if sum != nil {
            return String(sum!,radix: rax)
        }
        return nil
    }
    
    // 转字符串补0
    func hexadecimalSupplement() -> String {
        if self.length == 1 {
            return "0" + self
        }
        return self
    }
}

// 字符串操作
extension String {
    
    var length: Int {
        var a = 0
        for _ in self {
            a = a + 1
        }
        return a
    }
    
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0 + n, count)])
            if $0 + n < count {
                result += separator
            }
        }
        return result
    }
    
    subscript(_ r: CountableRange<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    //[0...3]
    subscript(_ range: CountableClosedRange<Int>) -> String {
        get {
            return self[range.lowerBound..<range.upperBound + 1]
        }
    }
    
    func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: startIndex + length)
        return String(self[start..<end])
    }
    
    subscript(i: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
}


public extension String {
 
    
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toInt() -> Int? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
}

/// Add the `inserting` and `removing` functions
private extension OptionSet where Element == Self {
    /// Duplicate the set and insert the given option
    func inserting(_ newMember: Self) -> Self {
        var opts = self
        opts.insert(newMember)
        return opts
    }
    
    /// Duplicate the set and remove the given option
    func removing(_ member: Self) -> Self {
        var opts = self
        opts.remove(member)
        return opts
    }
}
private enum ThreadLocalIdentifier {
    case dateFormatter(String)
    
    case defaultNumberFormatter
    case localeNumberFormatter(Locale)
    
    var objcDictKey: String {
        switch self {
        case .dateFormatter(let format):
            return "SS\(self)\(format)"
        case .localeNumberFormatter(let l):
            return "SS\(self)\(l.identifier)"
        default:
            return "SS\(self)"
        }
    }
}

private func threadLocalInstance<T: AnyObject>(_ identifier: ThreadLocalIdentifier, initialValue: @autoclosure () -> T) -> T {
    #if os(Linux)
    var storage = Thread.current.threadDictionary
    #else
    let storage = Thread.current.threadDictionary
    #endif
    let k = identifier.objcDictKey
    
    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }
    
    return instance
}

private func dateFormatter(_ format: String) -> DateFormatter {
    return threadLocalInstance(.dateFormatter(format), initialValue: {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }())
}

private func defaultNumberFormatter() -> NumberFormatter {
    return threadLocalInstance(.defaultNumberFormatter, initialValue: NumberFormatter())
}




