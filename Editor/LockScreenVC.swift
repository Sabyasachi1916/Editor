//
//  LockScreenVC.swift
//  Editor
//
//  Created by Sabya on 19/06/20.
//  Copyright © 2020 Applikatur AB. All rights reserved.
//

import UIKit
import LocalAuthentication

class LockScreenVC: UIViewController {
    let context = LAContext()
        var error: NSError?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.validateUser()
        }
        

    func validateUser(){
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                print(error?.localizedDescription ?? "")
                self.checkPasscode()
                return
            }
            let reason = "Face ID authentication"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
                guard isAuthorized == true else {
                    if error?.localizedDescription ?? "" == "Application retry limit exceeded."{
                        self.checkPasscode()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "MoveToDocumentVC", sender: nil)
                }
                
            }
        }

        func checkPasscode(){
                    guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    let reason = "Passcode authentication"
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { isAuthorized, error in
                        guard isAuthorized == true else {
                            print(error?.localizedDescription ?? "")
                            return
                        }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "MoveToDocumentVC", sender: nil)
                    }
                }
        }
    }
