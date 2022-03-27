//
//  APIParsing.swift
//  MovieFlix
//
//  Created by Shruti on 25/03/22.
//

import Foundation
import Alamofire

let BASE_URL = "https://api.themoviedb.org/3/movie/"
let IMG_URL = "https://image.tmdb.org/t/p/"
 
typealias CompletionHandler = (_ success:Bool , _ responseData : Any? , _ errorMsg  : String?) -> Void

class APIParse : NSObject
{
    
    func apiNowPlaying(completion : @escaping (NowPlayingModel) -> ()) {
        APIParse.now_playing { success, responseData, errorMsg in
            if success {
                do{
                    if let jsonResponse = responseData as? [String : Any] {
                        let jsonData = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let dataModel = try JSONDecoder().decode(NowPlayingModel.self, from: jsonData)
                        completion(dataModel)
                       
                    }
                }catch {
                    
                }
            }
        }
    }
    
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
    class func callAPI(url:String,timeOutInterval : Int , methodType : HTTPMethod , params:[String : Any] ,header: HTTPHeaders, isShowLoader : Bool = true  , completionHandler: @escaping CompletionHandler)
    {
        print("Service URl : \(url)")
        print("PostParametre : \(params.json)")
        
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
            if let  responseDic  = value as? [String: Any]
            {
                print("ResponseDic : \(responseDic.json)")
                let errorMsg = responseDic["message"] as? String ?? ""
                if let errorDic  = responseDic["error"] as? Int
                {
                    print("something went wrong", errorMsg, errorDic)
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
                print("something went wrong")
                return
                
            }
            else
            {
                print("something went wrong")
                return
            }
        default:
           print("something went wrong")
        }
       
    }

  
    
    //MARK: now playing
    
    class func now_playing(completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: [String:Any](), header: HTTPHeaders() , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }
    
    //MARK: get Videos
    class func getVideos(completionHandler: @escaping CompletionHandler)
    {
        
        let serviceURL  = "\(BASE_URL)209112/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        self.callAPI(url: serviceURL, timeOutInterval: 10, methodType: .get,  params: [String:Any](), header: HTTPHeaders() , completionHandler: { (success, response, errorMsg) in
            completionHandler(success, response, errorMsg)
        })
    }

}
