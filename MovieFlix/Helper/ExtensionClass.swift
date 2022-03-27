//
//  ExtensionClass.swift
//  RSAGrocery
//
//  Created by Weenggs Technology on 09/02/19.
//  Copyright © 2019 Weenggs Technology. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import LocalAuthentication

extension UIButton
{
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    
}




extension UILabel
{
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func setBorder(){
        self.layer.borderColor = UIColor.init(red: 100/255, green: 138/255, blue: 203/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
    
    func setAlignment() {
        if appDelegate.selectedLanguage?.languageCode == "ar"
        {
            self.textAlignment = .right
        } else {
            self.textAlignment = .left
        }
    }
    
    
    func setLineSpacing(lineSpacing: CGFloat = 4.0,textAlignment: NSTextAlignment = appDelegate.isArabicLanguage ? .right : .left) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        //paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = textAlignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func setUnderLineWith(_ underLineColor: UIColor, textColor: UIColor) {
        // Colored Underline Label
        let labelString = self.text ?? ""
        let textColor: UIColor = textColor
        let underLineColor: UIColor = underLineColor
        let underLineStyle = NSUnderlineStyle.single.rawValue
        
        let labelAtributes:[NSAttributedString.Key : Any]  = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.underlineStyle: underLineStyle,
            NSAttributedString.Key.underlineColor: underLineColor
        ]
        
        let underlineAttributedString = NSAttributedString(string: labelString,
                                                           attributes: labelAtributes)
        
        self.attributedText = underlineAttributedString
    }
}



extension UITextField
{
    enum Direction
    {
        case Left
        case Right
    }
    
    func AddImage(direction:Direction,imageName:String,Frame:CGRect,backgroundColor:UIColor)
    {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        View.addSubview(imageView)
        
        if Direction.Left == direction
        {
            self.leftViewMode = .always
            self.leftView = View
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}






extension String
{
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func setInterNationPhonePattern() -> String
    {
        return self.applyPatternOnNumbers(pattern: "(###) ###-####", replacmentCharacter: "#")
    }
    func onlyDigits() -> String
    {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    /*func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }*/
    
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date
    {
        
        let tz = String(self[NSRange(location: 19, length: 5)])
        
        let sign = tz[..<1] //String(tz.prefix(1))
        
        var hh = Int(tz[NSRange(location: 1, length: 2)])! * 60 * 60
        let mm = Int(tz[NSRange(location: 3, length: 2)])! * 60
        
        if (sign == "-") {
            hh = (hh + mm) * -1
        } else {
            hh = hh + mm
        }
        
        let time = Double(self[NSRange(location: 6, length: 10)])!
        
        let date1 = Date(timeIntervalSince1970:time)
        
        let date2 = date1.addingTimeInterval(TimeInterval(hh))
        
        let result = date2
        
        return result
    }
    
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
    
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func underline() ->  NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
          //  attributedText = attributedString
    }
    
    func underlineWithColor( _ color : UIColor) ->  NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor , value: color, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
          //  attributedText = attributedString
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return ceil(boundingBox.height)
    }

  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.width)
   }
    
    func localizableString() -> String {
            return appDelegate.selectedLanguage?.text[self] ?? self
        }
    
    

      //MARK:- Convert UTC To Local Date by passing date formats value
      func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat

        return dateFormatter.string(from: dt ?? Date())
      }
    
    func serverToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date ?? Date())
        return timeStamp
    }
    
    func serverToLocalOnlyDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date ?? Date())
        return timeStamp
    }
    
      //MARK:- Convert Local To UTC Date by passing date formats value
      func localToUTC(incomingFormat: String, outGoingFormat: String) -> String
      {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat

        return dateFormatter.string(from: dt ?? Date())
      }
    
    func stringToDecToInt() -> Int{
        let pointStr = self
        let pointDec = Decimal(string: pointStr)
        let decimalToIntPoint = NSDecimalNumber(decimal: pointDec ?? 0.0).intValue
        return decimalToIntPoint
    }
}

extension Double {
    func roundupDecimal() -> String {
        return String(format: "%.2f",self)
    }
}

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension Date
{
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension UIImageView{
    func loadImageFrom(url: String, placeHolderStr:String = ""){
        
        let base : String = url

        let imageURL = base.removingPercentEncoding
        if let urlString = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            SDImageCache.shared.config.maxDiskSize = 60 * 60 * 24 * 7
           // self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: URL(string: urlString)) { (image, error, cacheType, url) in
                if error != nil{
                    self.image = UIImage(named: placeHolderStr)
                }else{
                    self.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    func loadProfileImage(url: String, dominantColor:String = ""){
        let base : String = url
  
        let imageURL = base.removingPercentEncoding
        if let urlString = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            SDImageCache.shared.config.maxDiskSize = 60 * 60 * 24 * 7
           // self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: URL(string: urlString)) { (image, error, cacheType, url) in
                if image != nil{
                    self.backgroundColor = UIColor.clear
                }else{
                    self.image = UIImage(named: "ic_profile-user")
                }
            }
        }
    }
    func flipImageView(){
        if appDelegate.isArabicLanguage {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.transform = CGAffineTransform(scaleX: +1, y: 1)
        }
    }
    
    func loadProfileImageFrom(url: String, dominantColor:String = ""){

        let base : String = url
        
        let imageURL = base.removingPercentEncoding
        if let urlString = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            SDImageCache.shared.config.maxDiskSize = 60 * 60 * 24 * 7
           // self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: URL(string: urlString)) { (image, error, cacheType, url) in
                if error != nil{
                    self.image = UIImage(named: "ic_profile_placeholder")
                    self.contentMode = .scaleAspectFit
                }else{
                    self.backgroundColor = UIColor.clear
                }
            }
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
}



extension UIView
{
    func applyShadowAndRadiusToAllSide(){
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 4.0
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }
    
    func fadeIn(withDuration duration: TimeInterval = 0.5)
       {
           UIView.animate(withDuration: duration, animations: {
               self.alpha = 1.0
           })
       }

       /// Fade out a view with a duration
       ///
       /// - Parameter duration: custom animation duration
       func fadeOut(withDuration duration: TimeInterval = 0.5) {
           UIView.animate(withDuration: duration, animations: {
               self.alpha = 0.0
           })
       }
    
    func setcustomBorder(_ color : UIColor , width : CGFloat = 1.0 , withCornerRadius :Bool = true , cornerRadius : CGFloat = 5.0)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        if withCornerRadius
        {
            self.layer.cornerRadius = cornerRadius
        }
        
    }
    
    func applyCustomShadow()
    {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.24).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 2.0
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
        
    }
    
    func applyTopShadow(_ radius : CGFloat)
    {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.layer.cornerRadius = radius
        
    }
    
    func applyCustomShadowWithRadius(_ radius : CGFloat)
    {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.layer.cornerRadius = radius
    }
    
    func applyCustomeShadowToCell()
    {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.24).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 4.0
        self.layer.shadowRadius = 0.5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0.0
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func applyLightCustomShadow()
      {
          self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
          self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
          self.layer.shadowOpacity = 1.0
          self.layer.shadowRadius = 3.0
          self.layer.masksToBounds = false
          
      }
    
    func removeLightCustomShadow()
      {
          self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
          self.layer.shadowOpacity = 0
          self.layer.shadowRadius = 0
          self.layer.masksToBounds = false
          
      }
    
    
    func addDashedBorder( _ color : UIColor ,  _ cornerRadius : CGFloat)
    {

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
        }
    
    func setViewColorAndBorder()
    {
        self.layer.backgroundColor = UIColor.init(red: 100/255, green: 138/255, blue: 203/255, alpha: 0.15/1).cgColor
        self.layer.borderColor = UIColor.init(red: 100/255, green: 138/255, blue: 203/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }
    
    func RemoveViewColorAndBorder()
    {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    func customeBorder()
    {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.init(red: 98/255, green: 135/255, blue: 199/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 7
    }

    
}

extension Int
{
    init(_ bool:Bool) {
        self = bool ? 1 : 0
    }
}

extension UIRefreshControl {
    func manualRefersh(in tableView: UITableView)
    {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
    func manualRefershCollection(in collectionView: UICollectionView)
    {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        collectionView.setContentOffset(offsetPoint, animated: true)
    }
}

@objc extension CALayer
{
    
    //Apply shadow to UITabbar
    @objc func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
            //            shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 20).cgPath
        }
    }
}

extension Locale
{
    static var preferredLanguage: String
    {
        get {
            return self.preferredLanguages.first ?? "en"
        }
        set {
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
}

extension String
{
   /* var localized: String
    {
        var result: String
        let languageCode = Locale.preferredLanguage //en-US
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        if let path = path, let locBundle = Bundle(path: path)
        {
            result = locBundle.localizedString(forKey: self, value: nil, table: nil)
        }
        else
        {
            result = NSLocalizedString(self, comment: "")
        }
        return result
    }*/
    
    var htmlToAttributedString: NSAttributedString? {
          guard let data = data(using: .utf8) else { return NSAttributedString() }
          do {
              return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
          } catch {
              return NSAttributedString()
          }
      }
      var htmlToString: String {
          return htmlToAttributedString?.string ?? ""
      }
    
    func currencyInputFormatting() -> String
    {
         
         var number: NSNumber!
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
        // formatter.locale = Locale(identifier: "es_ES")
         formatter.currencySymbol = "$"
         formatter.maximumFractionDigits = 2
         formatter.minimumFractionDigits = 2
        formatter.usesGroupingSeparator = false
         var amountWithPrefix = self
         
         // remove from String: "$", ".", ","
         let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
         amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
         
         let double = (amountWithPrefix as NSString).doubleValue
         number = NSNumber(value: (double / 100))
         
         // if first number is 0 or all numbers were deleted
         guard number != 0 as NSNumber else {
             return "$0.00"
         }
         
         return formatter.string(from: number)!
     }
    
    func decimalFormatting() -> String
       {
           var number: NSNumber!
           let formatter = NumberFormatter()
           formatter.numberStyle = .none
           formatter.maximumFractionDigits = 2
           formatter.minimumFractionDigits = 2
           
           var amountWithPrefix = self
           
           // remove from String: "$", ".", ","
           let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
           amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
           
           let double = (amountWithPrefix as NSString).doubleValue
           number = NSNumber(value: (double / 100))
           
           // if first number is 0 or all numbers were deleted
           guard number != 0 as NSNumber else {
               return "0.00"
           }
           print("Decimal Format : \(formatter.string(from: number)!)")
           return formatter.string(from: number)!
       }
    
    func removeFormatAmount() -> Double
    {
        let formatter = NumberFormatter()
        
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.number(from: self) as! Double? ?? 0
    }

    
    func isBlankOrEmpty() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
    
    func trimmSpace()->String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


extension NSMutableAttributedString
{
    @discardableResult func bold(_ text: String , fontSize : Int  , fontColor : UIColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)) -> NSMutableAttributedString
    {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: TAJAWAL_BOLD, size: CGFloat(fontSize))! , NSAttributedString.Key.foregroundColor :fontColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String , fontSize : Int , fontColor : UIColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)) -> NSMutableAttributedString
    {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: TAJAWAL, size: CGFloat(fontSize))!, NSAttributedString.Key.foregroundColor : fontColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func Light(_ text: String , fontSize : Int , fontColor : UIColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)) -> NSMutableAttributedString
    {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: TAJAWAL_LIGHT, size: CGFloat(fontSize))!, NSAttributedString.Key.foregroundColor : fontColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func medium(_ text: String , fontSize : Int , fontColor : UIColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)) -> NSMutableAttributedString
    {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: TAJAWAL_MEDIUM, size: CGFloat(fontSize))!, NSAttributedString.Key.foregroundColor : fontColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func SuperScript(_ text: String , _ fontName : String ,  fontSize : Int , fontColor : UIColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0) , basepoint : Int = 4) -> NSMutableAttributedString
    {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: CGFloat(fontSize))!, NSAttributedString.Key.foregroundColor : fontColor , NSAttributedString.Key.baselineOffset : basepoint ]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func CustomFontApply(_ text: String , fontname : String , fontSize : Int  , fontColor : UIColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)) -> NSMutableAttributedString
    {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontname, size: CGFloat(fontSize))! , NSAttributedString.Key.foregroundColor :fontColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func AttachImage(_ imageName: String ) -> NSMutableAttributedString
    {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds =  CGRect(x: 2, y: -5, width: 20, height: 20)
        
        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        
        append(attachmentString)
        
        
        return self
    }
    
    
    func setAttachmentsAlignment(_ alignment: NSTextAlignment)
    {
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: self.length), options: .longestEffectiveRangeNotRequired) { (attribute, range, stop) -> Void in
            if attribute is NSTextAttachment {
                let paragraphStyle = NSMutableParagraphStyle()
                
                paragraphStyle.alignment = alignment
                self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            }
        }
    }
    
    func setColorForText(textForAttribute: String, withColor color: UIColor,font:UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }

}

extension CGFloat {
    func xx_rounded(_ rule: FloatingPointRoundingRule = .down, toDecimals decimals: Int = 2) -> CGFloat {
        let multiplier = CGFloat(pow(10.0, CGFloat(decimals)))
        return (self * multiplier).rounded(.down) / multiplier
    }
}

extension CGSize {
    func xx_rounded(rule: FloatingPointRoundingRule = .down, toDecimals: Int = 2) -> CGSize {
        return CGSize(
            width: width.xx_rounded(rule, toDecimals: toDecimals),
            height: height.xx_rounded(rule, toDecimals: toDecimals)
        )
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String , _ isBold : Bool = true) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        if (isBold)
        {
        messageLabel.font = UIFont.init(name: TAJAWAL_BOLD, size: 17.0)!
        }
        else
        {
            messageLabel.font = UIFont.init(name: TAJAWAL, size: 17.0)!

        }
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


extension UITableView{

    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil{
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }else{
            return activityIndicatorView
        }
    }

    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
        indicatorView().isHidden = false
    }

    func stopLoading(){
        indicatorView().stopAnimating()
        indicatorView().isHidden = true
    }
}


extension UIApplication {

    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
                let tag = 3848245

                let keyWindow = UIApplication.shared.connectedScenes
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows.first

                if let statusBar = keyWindow?.viewWithTag(tag) {
                    return statusBar
                } else {
                    let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                    let statusBarView = UIView(frame: height)
                    statusBarView.tag = tag
                    statusBarView.layer.zPosition = 999999

                    keyWindow?.addSubview(statusBarView)
                    return statusBarView
                }

            } else {

                if responds(to: Selector(("statusBar"))) {
                    return value(forKey: "statusBar") as? UIView
                }
            }
            return nil
      }
    
    var visibleViewController: UIViewController? {

        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }

        return getVisibleViewController(rootViewController)
    }

    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {

        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }

        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }

        return rootViewController
    }
}


extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 1.0
        pulse.toValue = 1.05
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 2
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    public func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
                       }, completion: nil)
    }
    
    func setImageEdgeInsets(topEn:CGFloat = 0, leftEn:CGFloat = 0, bottomEn:CGFloat = 0, rightEn:CGFloat = 0, topAr:CGFloat = 0, leftAr:CGFloat = 0, bottomAr:CGFloat = 0, rightAr:CGFloat = 0) {
        if appDelegate.isArabicLanguage {
            self.imageEdgeInsets = UIEdgeInsets(top: topAr, left: leftAr, bottom: bottomAr, right: rightAr)
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: topEn, left: leftEn, bottom: bottomEn, right: rightEn)
        }
    }
    
    func setTitleEdgeInsets(topEn:CGFloat = 0, leftEn:CGFloat = 0, bottomEn:CGFloat = 0, rightEn:CGFloat = 0, topAr:CGFloat = 0, leftAr:CGFloat = 0, bottomAr:CGFloat = 0, rightAr:CGFloat = 0) {
        if appDelegate.isArabicLanguage {
            self.titleEdgeInsets = UIEdgeInsets(top: topAr, left: leftAr, bottom: bottomAr, right: rightAr)
        } else {
            self.titleEdgeInsets = UIEdgeInsets(top: topEn, left: leftEn, bottom: bottomEn, right: rightEn)
        }
    }
    
    func setEdgeInsets(topEn:CGFloat = 0, leftEn:CGFloat = 0, bottomEn:CGFloat = 0, rightEn:CGFloat = 0, topAr:CGFloat = 0, leftAr:CGFloat = 0, bottomAr:CGFloat = 0, rightAr:CGFloat = 0) {
        if appDelegate.isArabicLanguage {
            self.contentEdgeInsets = UIEdgeInsets(top: topAr, left: leftAr, bottom: bottomAr, right: rightAr)
        } else {
            self.contentEdgeInsets = UIEdgeInsets(top: topEn, left: leftEn, bottom: bottomEn, right: rightEn)
        }
    }
    
}


extension UITextField
{
    func setAlignment() {
        if appDelegate.isArabicLanguage
           {
               self.textAlignment = .right
           } else {
               self.textAlignment = .left
           }
       }
    
}

extension UITextView
{
    func setAlignment() {
           if appDelegate.isArabicLanguage
           {
               self.textAlignment = .right
           } else {
               self.textAlignment = .left
           }
       }
}

extension UIButton
{
    func setAlignment()
    {
           if appDelegate.isArabicLanguage
           {
               self.titleLabel?.textAlignment = .right
           }
           else
           {
               self.titleLabel?.textAlignment = .left
           }
    }
    
    func setTitleAlignment()
    {
           if appDelegate.isArabicLanguage
           {
               self.contentHorizontalAlignment = .right
           }
           else
           {
               self.contentHorizontalAlignment = .left
           }
    }
    
    func flipButton() {
        if appDelegate.isArabicLanguage {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.transform = CGAffineTransform(scaleX: +1, y: 1)
        }
    }
}


extension UIImage {
    func flipImage() -> UIImage{
       
        if appDelegate.isArabicLanguage {
            if #available(iOS 10.0, *){
                let flippedImage = self.withHorizontallyFlippedOrientation()
                return flippedImage
            }
        }else{
            return self
        }
        return self
    }
}

extension UIViewController {
  var topMostViewController : UIViewController {

    if let presented = self.presentedViewController {
      return presented.topMostViewController
    }

    if let navigation = self as? UINavigationController {
      return navigation.visibleViewController?.topMostViewController ?? navigation
    }

    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController ?? tab
    }

    return self
  }
}

extension UIApplication {
  var topMostViewController : UIViewController? {
    return self.keyWindow?.rootViewController?.topMostViewController
  }
}

class CustomUITextField: UITextField {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
   }
}

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField() {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = UIColor.white.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = UIColor.white
        @unknown default: break
        }
    }
}

class TextFieldCustom: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
   
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class SSBadgeButton: UIButton {
    
    var badgeLabel = PaddingLabel()
    
    var badge: String? {
        didSet {
            addBadgeToButon(badge: badge ?? "")
        }
    }
    
    public var badgeBackgroundColor = UIColor.init(hexString: "#fea026") {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.init(name: TAJAWAL_BOLD, size: 13.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgeToButon(badge: nil)
    }
    
    func addBadgeToButon(badge: String?) {
        badgeLabel.padding(0, -4, 0, 0)
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 4.0)
        let width = max(height, Double(badgeSize.width) + 4.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 12 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
           if appDelegate.isArabicLanguage {
                    let x = 6
                    let y = CGFloat(-(height / 2.0)) + 16
                    badgeLabel.frame = CGRect(x: CGFloat(x), y: y, width: CGFloat(width), height: CGFloat(height))
                }else {
                    let x = self.frame.width - CGFloat((width)) - 5
                    let y = CGFloat(-(height / 2.0)) + 16
                    badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
                }
                
            
            
            
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != "0" ? false : true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
       self.addBadgeToButon(badge: nil)
    }
}

class PaddingLabel: UILabel {
    
    var insets = UIEdgeInsets.zero

    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
        return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}

extension NSAttributedString {

    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }

        self.init(attributedString: attr)
    }

}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension Int {
    func format(digit: Int) -> String {
        return String(format: "%.\(digit)d", self)
    }
}

extension Double {
    func format(digit: Int) -> String {
        return String(format: "%.\(digit)f", self)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class CustomDashedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    @IBInspectable var topSideCorner: Bool = false


    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            if topSideCorner
            {
                dashBorder.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath

            }
            else
            {
                dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

            }
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
