//
//  LoginViewController.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/22/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var loginService = WebService()
    @IBOutlet weak var uNameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func login(_ sender: Any) {
        if uNameField.text?.count != 0 && passField.text?.count != 0
        {
            loginService.sendLoginRequest(username: uNameField.text!, password: passField.text!, url: loginService.LOGIN_API_ADDRESS, type: "POST") { (result, done) in
//                if done
//                {
                    print(result)
//                }
//                else
//                {
                
//                }
                
            }
        }
    }
    
    private func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
