//
//  ViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var token: String!

    @IBOutlet weak var tokenControl: UISegmentedControl!
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var btnGetProfileInfo: UIButton!
    
    @IBOutlet weak var btnOpenProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnOpenProfile.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleStorageBTNMode()
        checkForExistingAccessToken()
    }
    
    // MARK: IBAction Functions

    @IBAction func tokenHandle(_ sender: UISegmentedControl) {
        let select = sender.selectedSegmentIndex
        self.tokenHandle(isSave: select == 0)
    }
    
    @IBAction func getProfileInfo(_ sender: AnyObject) {
        if let accessToken = token {
            access(accessToken: accessToken)
        }
    }
    
    
    @IBAction func openProfileInSafari(_ sender: UIButton) {
        let profileURL = URL(string: sender.title(for: .selected)!)
        print("profileURL:", profileURL ?? "nil")
        UIApplication.shared.openURL(profileURL!)
    }
    
    func tokenHandle(isSave: Bool) {
        if isSave {
            UserDefaults.standard.set(token, forKey: "token")
        } else {
            UserDefaults.standard.removeObject(forKey: "token")
            token = nil
        }
        handleStorageBTNMode()
        checkForExistingAccessToken()
    }
    
    func handleStorageBTNMode() {
        let storageToken = UserDefaults.standard.value(forKey: "token")
        let isTokenInStorage = storageToken != nil
        
        self.token = storageToken != nil ? storageToken as! String:self.token
        
        tokenControl.setEnabled(self.token != nil, forSegmentAt: 0)
        tokenControl.setEnabled(isTokenInStorage, forSegmentAt: 1)
    }
    
    /// Button isEnabled configure
    func checkForExistingAccessToken() {
        if token != nil {
            btnGetProfileInfo.isEnabled = true
        } else {
            btnGetProfileInfo.isEnabled = false
        }
    }
    
    func access(accessToken: String) {
        
        // Basic Profile Fields "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
        // Defatul Profile Field
        guard let url = URL(string: "https://api.linkedin.com/v1/people/~?format=json") else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        // add access token for HTTP header
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            print("Response:", response ?? "nil")
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        print("json:", json)
                        guard let dictionary = json as? [String: Any] else { return }
                        
                        if let lastName = dictionary["lastName"] as? String,
                            let firstName = dictionary["firstName"] as? String,
                            let headline = dictionary["headline"] as? String,
                            let id = dictionary["id"] as? String {
                            print("lastName:", lastName, "firstName:", firstName, "headline:", headline, "id:", id)
                        }
                        if let url = dictionary["siteStandardProfileRequest"] as? [String: Any], let profile = url["url"] as? String {
                            print("profile url:", profile)
                            DispatchQueue.main.async {
                                self.btnOpenProfile.setTitle(profile, for: .selected)
                                self.btnOpenProfile.setTitle("OpenProfileUrl", for: .normal)
                                self.btnOpenProfile.isHidden = false
                            }
                        }
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb" {
            if let vc =  segue.destination as? WebViewController {
                vc.respondToken(name: { (token) in
                    self.token = token
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

