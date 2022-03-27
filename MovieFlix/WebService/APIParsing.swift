//
//  APIParsing.swift
//  RSAGrocery
//
//  Created by Weenggs Technology on 04/02/19.
//  Copyright © 2019 Weenggs Technology. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

let kClientSTOREID = 1

let BASE_URL   =  "https://2goae.com/2go-appadmin/api/"
 
typealias CompletionHandler = (_ success:Bool , _ responseData : Any? , _ errorMsg  : String?) -> Void

typealias AddRemoveCouponCompletionHandler = (_ success:Bool , _ responseData : Any? , _ errorMsg  : String? , _ indexPath : IndexPath?) -> Void

class APIParse : NSObject
{
    override init() {
        print("called")
    }
    
   class func checkInternetRechability() -> Bool
    {
        let reachabilityManager = Reachability.init(hostname: "www.google.com")
        
        if ((reachabilityManager?.connection ) != nil)
        {
            if (reachabilityManager?.connection == Reachability.Connection.none)
            {
                //Helper.showAlert(msg: "Please check your internet connection")
                return false
            }
            else
            {
                return true
            }
        }
        return  false
    }
    
    
    //MARK: Call API & Handle response
    
    //Call API for image upload
    
    class func callAPIUploads(url:String,timeOutInterval : Int , methodType : HTTPMethod , params:[String : Any] ,header: HTTPHeaders, isShowLoader : Bool = true,isImage:Bool, completionHandler: @escaping CompletionHandler) {
        print("Service URl : \(url)")
        print("PostParametre : \(params)")
        
        if !(self.checkInternetRechability())
        {
            Helper.hideLoader()
            return
        }
        
        if (isShowLoader)
        {
            Helper.ShowLoader()
        }
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
    
        manager.upload(multipartFormData: {
                (multipartFormData) in
            
            
            if url.contains("providerImageUpload") {
                let profile_picture = params["profile_picture"] as! UIImage
                multipartFormData.append(profile_picture.jpegData(compressionQuality: 0.5)!, withName: "profile_picture", fileName: "file.jpeg", mimeType: "image")
            }else {
                if isImage {
                    let doc_picture = params["doc_files"] as! UIImage
                    let doc_Data = doc_picture.jpegData(compressionQuality: 0.5)!
                    multipartFormData.append(doc_Data, withName: "doc_files", fileName: "file.jpeg", mimeType: "image")
                } else {
                    if let pdfData = params["doc_files"] as? NSData {
                        multipartFormData.append(pdfData as Data, withName: "doc_files", fileName: "sample.pdf", mimeType: "pdf")
                    }
                }
                
            }
        }, to:url,headers:header).responseJSON
        { (responseData) -> Void in
            self.handleResponse(responseData: responseData)
            {
                (success, response, errorMsg) in
                if (isShowLoader)
                {
                  Helper.hideLoader()
                }
                completionHandler(success, response, errorMsg)
            }
        }
    }
    
    //Call API
    class func callAPI(url:String,timeOutInterval : Int , methodType : HTTPMethod , params:[String : Any] ,header: HTTPHeaders, isShowLoader : Bool = true  , completionHandler: @escaping CompletionHandler)
    {
        print("Service URl : \(url)")
        print("PostParametre : \(params.json)")
        
        if !(self.checkInternetRechability())
        {
            Helper.hideLoader()
            return
        }
        
        if (isShowLoader)
        {
            Helper.ShowLoader()
        }
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
        
        if (methodType == .get)
        {
            manager.request(url,parameters: params, headers : header).responseJSON { (responseData) -> Void in
                
                if let _ = responseData.error {
                  print("--------- Error -------")
                  if let responseData = responseData.data {
                    let htmlString = String(data: responseData, encoding: .utf8)
                    print(htmlString!)
                  }
                }
                
                self.handleResponse(responseData: responseData)
                {
                    (success, response, errorMsg) in
                    if (isShowLoader)
                    {
                      Helper.hideLoader()
                    }
                    completionHandler(success, response, errorMsg)
                }
            }
        }
        else
        {
                manager.request(
                    url,
                    method: methodType,
                    parameters : params,encoding : JSONEncoding.default ,  headers : header).responseJSON { (responseData) -> Void in
                        
                        if let _ = responseData.error {
                          print("--------- Error -------")
                          if let responseData = responseData.data {
                            let htmlString = String(data: responseData, encoding: .utf8)
                            print(htmlString!)
                          }
                        }
                        
                        self.handleResponse(responseData: responseData)
                        {
                            (success, response, errorMsg) in
                
                                if (isShowLoader)
                                {
                                  Helper.hideLoader()
                                }
                            
                           
                            
                          
                            completionHandler(success, response, errorMsg)
                    }
            }
        }
    }
    
    
    //Handle Response
class func handleResponse(responseData:AFDataResponse<Any>, completionHandler: @escaping CompletionHandler)
    {
        switch responseData.result {
        case .success(let value):
            let swiftyJsonVar = JSON(value)
            if let  responseDic  = swiftyJsonVar.dictionaryObject
            {
                print("ResponseDic : \(responseDic.json)")
                let errorMsg = responseDic["message"] as? String ?? ""
                if let errorDic  = responseDic["error"] as? Int
                {
                
                    if errorDic == 1
                    {
                        completionHandler(false, nil, responseDic["message"] as? String)
                    } else if errorDic == -1// For token exp.
                    {
//                        let appearance = SCLAlertView.SCLAppearance(
//                            showCloseButton: false
//                        )
//
//                        let alertView = SCLAlertView(appearance: appearance)
//
//                        alertView.addButton("key_login".localizableString()) {
                            completionHandler(false, -1, "")
                        
                        baseVC.stopTimer()
                      
                        if appDelegate.loggedInUser != nil {
                            appDelegate.removeFCMTokenApiCall()
                            
                            UserDefaults.standard.removeObject(forKey: LOGIN_USERDATA)
                            UserDefaults.standard.synchronize()
                            appDelegate.setIntroOrLoginScreen()
                            appDelegate.isGuestUser = true
                            //                        }
                        }
//                        let alertViewResponder: SCLAlertViewResponder = alertView.showNotice("\n"+"key_notice".localizableString(), subTitle: "key_login_required".localizableString(),closeButtonTitle: "key_cancel".localizableString(), animationStyle: .bottomToTop)
//
//                        alertViewResponder.setDismissBlock {
//                            completionHandler(false, -1, responseDic["message"] as? String)
//                        }
                        
                    } else if errorDic == -2 || errorDic == -4 || errorDic == -3 // For account pending
                    {
                     
                        /*UserDefaults.standard.removeObject(forKey: "LoggedInUser")
                        UserDefaults.standard.synchronize()
                        appDelegate.setIntroOrLoginScreen()
                        appDelegate.isGuestUser = true*/
                        
                        baseVC.stopTimer()
                        
                        baseVC.accountStatus(errorDic: errorDic, msg: (responseDic["message"] as? String)!)
                        
                       
                        Helper.hideLoader()
                    } else
                    {
                        completionHandler(true, responseDic, nil)
                    }
                }
                else
                {
                    completionHandler(true, responseDic, nil)
                }
            }
        case .failure(let error):
            print(error)
            if error._code == NSURLErrorTimedOut
            {
                completionHandler(false, nil, "key_something_went_wrong".localizableString())
                return
                
            }
            else
            {
                completionHandler(true, nil, "key_something_went_wrong".localizableString())
                return
            }
        default:
            completionHandler(true, nil, "key_something_went_wrong".localizableString())
        }
       
    }
    
   /* class func uplaodProfileImages(url:String ,data:Data, image : UIImage, header: HTTPHeaders, completionHandler: @escaping CompletionHandler){
        DispatchQueue.main.async {
             Helper.ShowLoader()
            
            
            let UploadUrl:String = url//BASE_URL + "marketplace/uploadFiles"
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let random = String((0..<3).map{ _ in letters.randomElement()! })
            let tmpImgName = "tmp\(random).jpeg"
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(data, withName: "image", fileName: tmpImgName, mimeType: "image/jpeg")
                
            },
            to: UploadUrl,method:HTTPMethod.post, headers : header,encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate()
                        .responseJSON { response in
                            
                            switch response.result {
                            case .success(let value):
                                //                                                if let success = (value as! NSDictionary).object(forKey: "success") as? String {
                                //
                                //                                                }
                                //                                                let url = (value as! NSDictionary).object(forKey: "file") as? String ?? ""
                                //
                                //
                                //                                                print("responseObject: \(value)")
                                APIParse.handleResponse(responseData: response)
                                {
                                    (success, response, errorMsg) in
                                    Helper.hideLoader()
                                    completionHandler(success, response, errorMsg)
                                }
                                
                            case .failure(let responseError):
                                Helper.hideLoader()
                                print("responseError: \(responseError)")
                            }
                        }
                    
                case .failure(let encodingError):
                    Helper.hideLoader()
                    print("encodingError: \(encodingError)")
                }
            })
        }
    }
     
    */
    
    //MARK: set Provider Services API
    
    class func setProviderServices( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)provider/setProviderService"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    
    //MARK: Login & SignUp
    
    class func doLogin( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)provider/login"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    
    //MARK: Signup
    class func doSignUp( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)provider/register"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Change Language
    
    class func changeLanguage( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)provider/changeLanguage"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Change Provider status
    class func changeProviderStatus( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)provider/ChangeOnlineStatus"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: get Availability
    class func getAvailability( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let serviceURL  = "\(BASE_URL)provider/getAvailability"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: set Availability
    class func setAvailability( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let serviceURL  = "\(BASE_URL)provider/setAvailability"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Count Jobs
    class func countJobs( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let serviceURL  = "\(BASE_URL)provider/countJobs"
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
   
    //MARK: Banner
    class func getBanner( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)getBanner"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Category
    class func getCategory( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer " //\(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)getCategory"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: ServiceType
    class func getAllCity( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)getAllCity"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: ServiceType
    class func getServiceType( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL = "\(BASE_URL)provider/getServiceType"
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Edit ServiceType
    class func getEditServiceList( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL = "\(BASE_URL)provider/getServiceList?lang=\(appDelegate.isArabicLanguage ? "ar" : "en")"
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: get Notification
      class func getNotification( postParameter : [String : Any], isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
      {
        let header: HTTPHeaders = [
          "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        let serviceURL = "\(BASE_URL)provider/getNotification"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post, params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
          completionHandler(success, response, errorMsg)
        })
      }
    
    //MARK: Delete ServiceType
    class func deleteServiceList( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/deleteService"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: DoucmentList
    class func getDocumentList( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getDocumentList"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Upload DoucmentList
    class func uploadDocumentApi(postParameter : [String : Any] , isShowLoader: Bool = true,isImage: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
      
        let serviceURL = "\(BASE_URL)provider/docUpload"
        self.callAPIUploads(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, isImage: isImage, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: DoucmentList Upload
    class func documentUpload( postParameter : [String : Any] , completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/documentUpload"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: respond Order
    class func respondOrder(postParameter : [String : Any],isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)respondOrder"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    //MARK: collect Payment
    class func collectPayment(postParameter : [String : Any],isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/collectPayment"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: complete Order
    class func completeOrder(postParameter : [String : Any],isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)completeOrder"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Receipt
    class func getReceipt( postParameter : [String : Any], bookingId: String ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getReceipt/\(bookingId)"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: check Provider Status
    class func checkProviderStatus(postParameter : [String : Any],isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL = "\(BASE_URL)provider/checkProviderStatus"
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    
    //MARK: Total Bookings
    class func getTotalBookings( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getTotalBookingsTemp"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: startOfflineService
    class func startOfflineServiceApi( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/startOfflineService"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: financialReport
    class func financialReport( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)financialReport"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    
    //MARK: SplashList
    class func getSplashList( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getSplashList"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    
    //MARK: Address
    class func getAddress( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)user/getAddress"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: getUserProfile
    class func getUserProfile( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)user/getUserProfile"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header ,isShowLoader: true, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: cancel Reasons
    class func cancelReasons( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getCancelReasons"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: change password
    class func changePassword( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/ChangePassword"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: change password
    class func contactUS( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)user/contact-us"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Change Personal Details
    class func ChangePersonalDetails( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/ChangePersonalDetails"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Get Bank Details
    class func getBankDetails( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getBankDetails"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Set Bank Details
    class func setBankDetails( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/setBankDetails"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: termsOfService
    class func termsOfService(isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        
        var parameter = [String:Any]()
        parameter["lang"] = appDelegate.selectedLanguage?.languageCode
        
        let serviceURL  = "\(BASE_URL)user/pages/terms_and_conditions"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: parameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: privacyPolicy
    class func privacyPolicy(isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        var parameter = [String:Any]()
        parameter["lang"] = appDelegate.selectedLanguage?.languageCode
        
        let serviceURL  = "\(BASE_URL)user/pages/privacy_policy"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: parameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: aboutUs
    class func aboutUs(isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        var parameter = [String:Any]()
        parameter["lang"] = appDelegate.selectedLanguage?.languageCode
        
        let serviceURL  = "\(BASE_URL)user/pages/about_us"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: parameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: FAQ
    class func faqApi(isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        var parameter = [String:Any]()
        parameter["lang"] = appDelegate.selectedLanguage?.languageCode
        
        let serviceURL = "\(BASE_URL)user/pages/faq"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: parameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: aboutUs
    class func refundPolicy(isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        
        var parameter = [String:Any]()
        parameter["lang"] = appDelegate.selectedLanguage?.languageCode
        
        let serviceURL = "\(BASE_URL)user/pages/refund_policy"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: parameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: getCity
    class func getCityApi(postParameter : [String : Any] , isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
      
        let serviceURL  = "\(BASE_URL)user/getCity"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: getCity
    class func searchProvidersApi(postParameter : [String : Any] , isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
      
        let serviceURL = "\(BASE_URL)searchProviders"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: getSloats
    class func getSlotsApi(postParameter : [String : Any] , isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
      
        let serviceURL = "\(BASE_URL)getSloats"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: getAllReviews
    class func getAllReviewsApi(postParameter : [String : Any] , isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
      
        let serviceURL = "\(BASE_URL)provider/getAllReviews"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: upload profile image
    class func uploadProviderImageApi(postParameter : [String : Any] , isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
      
        let serviceURL = "\(BASE_URL)provider/providerImageUpload"
        self.callAPIUploads(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, isImage: true, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: set Token
    class func setTokenApi(isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        var postParameter = [String:Any]()
        postParameter["app_user_id"] = appDelegate.loggedInUser?.provider.id
        postParameter["token"] =  appDelegate.FCMToken
        postParameter["lang"] = appDelegate.selectedLanguage?.languageCode
        postParameter["device_id"] = DEVICE_TOKEN
        
        let serviceURL = "\(BASE_URL)provider/providerToken"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: remove Token
    class func removeDeviceTokenApi(isShowLoader: Bool = true, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        var postParameter = [String:Any]()
        postParameter["app_user_id"] = appDelegate.loggedInUser?.provider.id
        postParameter["token"] = appDelegate.FCMToken
        postParameter["lang"] = appDelegate.selectedLanguage?.languageCode
        postParameter["device_id"] = DEVICE_TOKEN
        
        let serviceURL = "\(BASE_URL)provider/removeProviderToken"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: getProviderService
    class func getProviderService( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getProviderService"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Delete Provider Destination
    class func deleteProviderDestination( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/deleteProviderDestination"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Get Profile
    class func getProfile( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/getProfile"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: Forget Password Api
    class func forgotPassword( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/forgotPassword"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: update online time Api
    class func updateOnlineTime( postParameter : [String : Any] ,isShowLoader: Bool, completionHandler: @escaping CompletionHandler)
    {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(appDelegate.loggedInUser?.token ?? "")"
        ]
        
        let serviceURL  = "\(BASE_URL)provider/updateOnlineTime"
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .post,  params: postParameter, header: header ,isShowLoader: isShowLoader, completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    static func getDeviceName() -> String
    {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        guard let iOSDeviceModelsPath = Bundle.main.path(forResource: "iOSDeviceModelMapping", ofType: "plist") else { return "" }
        guard let iOSDevices = NSDictionary(contentsOfFile: iOSDeviceModelsPath) else { return "" }
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return iOSDevices.value(forKey: identifier) as! String
    }
    
    

}

class Downloader {
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("SuccessResponse: \(response)")
                    print("Success: \(statusCode)")
                }

                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }

            } else {
                print("Failure: %@", error?.localizedDescription ?? "No Data");
            }
        }
        task.resume()
    }
}

