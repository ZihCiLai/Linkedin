//
//  WebViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    typealias block = (String)->Void
    var token: block!

    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Constants
    let linkedInKey = "your linked key"
    let linkedInSecret = "your linked secret"
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        startAuthorization()
    }
    
    func startAuthorization() {
        let responseType = "code"
        
        // 重新導向URL。
        let redirectURL = "https://com.zihci.linkedin.oauth/zihci".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        // 以現在時間製作字符串.
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // 使用權限。
        let scope = "r_basicprofile"
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print("authorizationURL:", authorizationURL)
        
        if let url = URL(string: authorizationURL) {
            let request = NSURLRequest(url: url)
            webView.loadRequest(request as URLRequest)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.url!
        
        if url.host == "com.zihci.linkedin.oauth" {
            if url.absoluteString.range(of: "code") != nil {
                let urlParts = url.absoluteString.components(separatedBy: "?")
                
                let code = urlParts[1].components(separatedBy: "=")[1]
                print("code:", code)
                requestForAccessToken(code)
            }
        }
        return true
    }
    
    func requestForAccessToken(_ authorizationCode: String) {
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.zihci.linkedin.oauth/zihci".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        let postData = postParams.data(using: String.Encoding.utf8)
        
        guard let url = URL(string: accessTokenEndPoint) else {
            return
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("statusCode", statusCode)
            guard statusCode == 200 else { return }
            if let data = data {
                do {
                    let json =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let dictionary = json as? [String: Any] {
                        guard let token = dictionary["access_token"] as? String else { return }
                        self.token(token)
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } catch  {
                    print("data to jsonToken error!")
                }
            }
        }
        task.resume()
    }
    
    func respondToken(name: @escaping block) {
        self.token = name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
