//
//  ViewController.swift
//  Notes
//
//  Created by Craig Booker on 1/25/19.
//  Copyright © 2019 Arcadia Softworks. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSCore
import AWSDynamoDB


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func doBtnLogout(_ sender: Any) {
    AWSSignInManager.sharedInstance().logout { (value, error) in
      self.checkForLogin()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkForLogin()
    
  }
  
  func checkForLogin() {
    if !AWSSignInManager.sharedInstance().isLoggedIn {
      AWSAuthUIViewController.presentViewController(with: self.navigationController!,
                                                    configuration: nil) { (provider, error) in
                                                      if error == nil {
                                                        print("success")
                                                      }
                                                      else {
                                                        print(error?.localizedDescription ?? "no value")
                                                      }
      }
    }
  }
  

}

