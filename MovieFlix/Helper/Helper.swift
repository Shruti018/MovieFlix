//
//  Helper.swift
//  blueBerryPos
//
//  Created by Weenggs Technology on 15/10/18.
//  Copyright © 2018 Weenggs Technology. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import SVProgressHUD
import SwiftGifOrigin
import PopupDialog

var imageCache = NSCache<AnyObject, AnyObject>.init()

enum BiometricType{
    case touch
    case face
    case none
}


let isiPhone4:Bool = UIScreen.main.bounds.size.height == 480
let isiPhone5:Bool = UIScreen.main.bounds.size.height == 568
let isiPhone6:Bool = UIScreen.main.bounds.size.height == 667
let isiPhone6sPlusOrGreater:Bool = UIScreen.main.bounds.size.height >= 736

let AppVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
let DeviceType = "IOS"
let textFieldBorderColor = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)

var selectedTab = 0

let urlSession =
{
    return URLSession(
        configuration: URLSessionConfiguration.default, delegate: nil,
        delegateQueue: OperationQueue.main)
}()


class Helper
    {
    
    class func getCurrentViewControllers(_ vc: UIViewController) -> UIViewController? {
        if let pvc = vc.presentedViewController {
            return getCurrentViewControllers(pvc)
        }
        else if let svc = vc as? UISplitViewController, svc.viewControllers.count > 0 {
            return getCurrentViewControllers(svc.viewControllers.last!)
        }
        else if let nc = vc as? UINavigationController, nc.viewControllers.count > 0 {
            return getCurrentViewControllers(nc.topViewController!)
        }
        else if let tbc = vc as? UITabBarController {
            if let svc = tbc.selectedViewController {
                return getCurrentViewControllers(svc)
            }
        }
        return vc
    }
    
    class func showWarningToast( msg : String) {
       // Loaf(msg, state: .warning, sender: vc).show()
       
        
        SCLAlertView().showWarning("\n"+"key_warning_title".localizableString(), subTitle: msg,closeButtonTitle: "key_alright".localizableString(),colorStyle: 0xD8AC1F, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: "ic_dialog-info-1"))//info-svgrepo-com
    }
    
    class func showInfoToast( msg : String) {
        //Loaf(msg, state: .info, sender: vc).show()
        SCLAlertView().showInfo("\n"+"key_info".localizableString(), subTitle: msg,closeButtonTitle: "key_ok".localizableString())
    }
    
    class func showSuccessToast( msg : String,completionHandler: @escaping ()-> ()) {
        //Loaf(msg, state: .success, sender: vc).show()
        let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("\n"+"key_success".localizableString(), subTitle: msg,closeButtonTitle: "key_ok".localizableString())
        alertViewResponder.setDismissBlock {
            completionHandler()
        }
        
        
    }
    
    //MARK:- Alert With Multi Button
    class func showAlertWithMultiButton(title: String, message: String, btnTitle1: String, btnTitle2: String, status: Bool, completionHandler: @escaping (Bool)-> ()) {
        
        let alertView = SCLAlertView()
        
        alertView.addButton(btnTitle1) {
            completionHandler(true)
        }
        
        if status {
            
            alertView.showSuccess(title, subTitle: message, closeButtonTitle: btnTitle2, timeout: nil, colorStyle: 0x4152d8, colorTextButton: 0xE07E0A, circleIconImage: nil, animationStyle: .topToBottom)
            
        } else {
            
            alertView.showError(title, subTitle: message, closeButtonTitle: btnTitle2, timeout: nil, colorStyle: 0x4152d8, colorTextButton: 0xE07E0A, circleIconImage: nil, animationStyle: .topToBottom)
        }
    }
    
    class func showErrorToast( msg : String) {
       // Loaf(msg, state: .error, sender: vc).show()
        SCLAlertView().showError("\n"+"key_error".localizableString(), subTitle: msg,closeButtonTitle: "key_ok".localizableString())
    }
    
    class func showNoticeAlert(vc: UIViewController) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("key_login".localizableString()) {
            UserDefaults.standard.removeObject(forKey: "LoggedInUser")
            UserDefaults.standard.synchronize()
            appDelegate.setIntroOrLoginScreen()
        }
        
        vc.navigationController?.popViewController(animated: true)
        
//        let alertViewResponder: SCLAlertViewResponder = alertView.showNotice("\n"+"key_notice".localizableString(), subTitle: "key_login_required".localizableString(),closeButtonTitle: "key_cancel".localizableString(), animationStyle: .bottomToTop)
//        
//        alertViewResponder.setDismissBlock {
//
//        }
    }
    
        class func isValidEmail(email:String) -> Bool
        {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
    
       class func isValidPhone(value: String) -> Bool {
            let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$";
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: value)
            return result
        }
    
        class func saveDataToUserDefaults(dic:[String:Any], key:String)
        {
            let archievedObj = NSKeyedArchiver.archivedData(withRootObject: dic)
            UserDefaults.standard.set(archievedObj, forKey: key)
        }
    
        class  func removeUserDefault (key : String)
        {
            
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
        }
    
        class func getDataFromUserDefaults(key:String) -> [String:Any]?
        {
            if let data = UserDefaults.standard.object(forKey: key)
            {
                let dic = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
                return (dic as! [String : Any])
            }
            else
            {
                return nil
            }
        }
   
    
    
   class func ShowLoader()
    {
        DispatchQueue.main.async
        {
        //SVProgressHUD.m line number:- 323 for duration,hudWidth,hudHeight:- 472
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.1))
        //let loaderGif = UIImage.gif(name: "loaderGIF") ?? UIImage()
        if appDelegate.isArabicLanguage {
            SVProgressHUD.setFont(UIFont(name: TAJAWAL_MEDIUM, size: 12.0)!)
        } else {
            SVProgressHUD.setFont(UIFont(name: TAJAWAL_MEDIUM, size: 15.0)!)
        }
        //SVProgressHUD.setImageViewSize(CGSize(width: 50, height: 50))
        SVProgressHUD.setForegroundColor(themeColor)
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setFadeInAnimationDuration(0)
        SVProgressHUD.setFadeOutAnimationDuration(0)
        
        SVProgressHUD.show()
        //SVProgressHUD.show(loaderGif, status: "key_loading".localizableString())

    }
        
    }
    
    class func openCongratulationPopup(vc: UIViewController, image: UIImage, intro: String, title: String, isSetHS: Bool,backgroundColor: UIColor = .clear, isSusp: Bool = false, isOKHide: Bool = false, btnOkAction: @escaping YesButtonAction) {
        let congratulationVC = CongratulationVC(nibName: "CongratulationVC", bundle: nil)
        congratulationVC.image = image
        congratulationVC.intro = intro
        congratulationVC.strTitle = title
        congratulationVC.isSetHome = isSetHS
        congratulationVC.parentView = vc
        congratulationVC.isSuspended = isSusp
        congratulationVC.okButtonAction = btnOkAction
        congratulationVC.okBtnHide = isOKHide
        congratulationVC.view.backgroundColor = backgroundColor
        
        addDailogToPopup(presentView: vc, dialogView: congratulationVC)
    }
   
    class func openConfirmationPopup(vc: UIViewController, data: [String:Any] , btnYesAction: @escaping YesButtonAction) {
        let confirmationVC = ConfirmationDialog(nibName: "ConfirmationDialog", bundle: nil)
        confirmationVC.data = data
        confirmationVC.yesButtonAction = btnYesAction
        addDailogToPopup(presentView: vc, dialogView: confirmationVC)
    }
    
    class func addDailogToPopup(presentView: UIViewController, dialogView: UIViewController) {
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled = false
        ov.opacity = 0.4
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = .clear
        pcv.cornerRadius  = 12
        // Create the dialog
        let popup = PopupDialog(viewController: dialogView, transitionStyle: .zoomIn, tapGestureDismissal: false, panGestureDismissal: false)
        
        let viewController = presentView
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController
        currentViewController?.dismiss(animated: true, completion: nil)
        // Present dialog
        if viewController.presentedViewController == nil {
            currentViewController?.present(popup, animated: true, completion: nil)
        } else {
            viewController.present(popup, animated: true, completion: nil)
        }
        
//        presentView.present(popup, animated: true, completion: nil)
    }
   
    class func hideLoader()
    {
        DispatchQueue.main.async
        {
            SVProgressHUD.dismiss()
            //SwiftLoader.hide()
        }
    }
    
    class func generateImageNameFromDate() -> String
    {
        let dtFormatter: DateFormatter = DateFormatter()
        dtFormatter.dateFormat="MMddyyHHmmss_SSSS"
        let imageName = dtFormatter.string(from: NSDate() as Date)
        let imageFullName = "img_" + imageName + ".png" as NSString
        return imageFullName as String
    }
    
    class func daysBetween(start: Date, end: Date) -> Int
    {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
 
    class func getString(object: Any?) -> String {
        if (object is NSNull) || (object == nil) {
            return ""
        }else{
            return object as! String
        }
    }
    
    class func openURLIntoBrowser(strURL: String) {
        if let urlString = (strURL).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            guard let url = URL(string: urlString) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func setNotificationCount(badgeButton: SSBadgeButton) {
        badgeButton.badge = "\(appDelegate.notificationCount)"
        if appDelegate.notificationCount == 0 {
            badgeButton.badgeLabel.isHidden = true
        } else {
            badgeButton.badgeLabel.isHidden = false
        }
    }
    
    class func convertDateForStep(orignalForamt: String, desiredFormat: String, strDate: String) -> String {
        let dt = DateFormatter()
        dt.dateFormat = orignalForamt
        dt.timeZone = NSTimeZone.local
        let date = dt.date(from: strDate)
        
        dt.dateFormat = desiredFormat
        
        return dt.string(from: date!)
    }
    
    //MARK:- Add or Remove Highlight selected TextField
    
    static func addTextFieldUnderline(_ textField: UITextField,_ mainView: UIView) {
        
        let view = mainView.viewWithTag(textField.tag+1)
        view?.backgroundColor = themeColor
        view?.transform = CGAffineTransform(scaleX: 1.0, y: 2.0);
    }
    
    static func removeTextFieldUnderline(_ textField: UITextField,_ mainView: UIView) {
        
        let view = mainView.viewWithTag(textField.tag+1)
        view?.backgroundColor = .black
        view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
    }
    
    static func endOfTheMonth(selectedDate : Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let range = calendar.range(of: .day, in: .month, for: selectedDate)!
        components.day = range.upperBound - 1
        return calendar.date(from: components)!
    }
    
    //MARK:- Change Date Formate
    static func changeDateFormate(selectedDate: String, currentDateFormate: String, requiredDateFormate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentDateFormate
        let date = dateFormatter.date(from: selectedDate)
        dateFormatter.dateFormat = requiredDateFormate
        dateFormatter.timeZone = NSTimeZone.local
        let localTime = dateFormatter.string(from: date ?? Date())
        return localTime
    }
}


func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
    guard let info = Bundle.main.infoDictionary,
        let currentVersion = info["CFBundleShortVersionString"] as? String,
        let identifier = info["CFBundleIdentifier"] as? String,
        let url = URL(string: "https://itunes.apple.com/us/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
    }
//    log.debug(currentVersion)
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    config.urlCache = nil
    
    let session = URLSession.init(configuration: config)
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Content-Type", forHTTPHeaderField: "application/json")
    
    
    let task = session.dataTask(with: request) { (data, response, error) in
        do {
            if let error = error { throw error }
            guard let data = data else { throw VersionError.invalidResponse }
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
           // print("Json :\(json)")
            guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String , let trackUrl  = result["trackViewUrl"] as? String  else {
                throw VersionError.invalidResponse
            }
            
            iTunesLink = trackUrl
            print("AppStore URL Link : \(iTunesLink)")
            print("App version(current) : ",currentVersion)
            print("App version(live) : ",version)

            completion(version > currentVersion, nil)
        } catch {
            completion(nil, error)
        }
    }
    task.resume()
    return task
}



enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

func isIphoneXOrBigger() -> Bool {
    // 812.0 on iPhone X, XS.
    // 896.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height >= 812
}

func isIphone5OrLower() -> Bool {
    // 812.0 on iPhone X, XS.
    // 896.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height <= 568.0
}

class coloredUIImageView: UIImageView{
    override func layoutSubviews() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = themeColor
    }
}




class coloredUIButton: UIButton{
    override func layoutSubviews() {
        
        let image = self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.tintColor = themeColor
        //        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        //        self.tintColor = themeColor
    }
    
}

class ContentSizedCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: collectionViewLayout.collectionViewContentSize.height)
    }
}

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension Double
{
    func roundTo(places: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter.string(from: self as NSNumber)!
    }
    
    func roundToDouble(places: Int) -> Double {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let formattedAmount = formatter.string(from: self as NSNumber)!
        return Double(formattedAmount) ?? 0.00

        }
    
    
}
//568.0

extension UITabBarController {
    func getSelectedTabIndex() -> Int? {
        if let selectedItem = self.tabBar.selectedItem {
            return self.tabBar.items?.firstIndex(of: selectedItem)
        }
        return nil
    }
}

class FlippedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        if appDelegate.isArabicLanguage {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.transform = CGAffineTransform(scaleX: +1, y: 1)
        }
    }
    
}

class TintImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
    }
    
}

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
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
