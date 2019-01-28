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


@objcMembers
class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
      AWSAuthUIViewController.presentViewController(with:
          self.navigationController!, configuration: nil)
          { (provider, error) in
          if error == nil {
              print("success")
          }
          else {
              print(error?.localizedDescription ?? "no value")
          }
      }
    }
    else {
      createNote()
    }
  }
  
  func createNote() {
    guard let note = Note() else { return }
    note._userId = AWSIdentityManager.default().identityId
    note._noteId = "123"
    note._content = "Text for my note"
    note._creationDate = Date().timeIntervalSince1970 as NSNumber
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    note._title = "My note on \(df.string(from: Date()))"
    saveNote(note : note)
    
  }
  
  func saveNote(note: Note) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    dbObjMapper.save(note) { (error) in
      print (error?.localizedDescription ?? "no error")
    }
  }
  
  func loadNote(noteID : String) {
    let dbObjMapper = AWSDynamoDBObjectMapper.default()
    if let hashKey = AWSIdentityManager.default().identityId {
      dbObjMapper.load(Note.self, hashKey: hashKey, rangeKey: noteID) { (model, error) in
        if let note = model as? Note {
          print (note._content ?? "no content")
        }
      }
    }
  }
}

