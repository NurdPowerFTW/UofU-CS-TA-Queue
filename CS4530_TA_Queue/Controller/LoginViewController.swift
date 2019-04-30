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
        
        
//        let currentUser = UserDefaults.standard.string(forKey: "CurrentUser")
//        if currentUser != nil
//        {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let classVC = storyboard.instantiateViewController(withIdentifier: "ClassVC")
//            self.navigationController?.pushViewController(classVC, animated: true)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        uNameField.placeholder = "username:"
        passField.placeholder = "password:"
    }
    @IBAction func login(_ sender: Any) {
        if uNameField.text?.count != 0 && passField.text?.count != 0
        {
            loginService.sendLoginRequest(username: uNameField.text!, password: passField.text!, url: loginService.LOGIN_API_ADDRESS, type: "POST") { (result, done) in
                if done
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let classVC = storyboard.instantiateViewController(withIdentifier: "ClassVC")
                    self.navigationController?.pushViewController(classVC, animated: true)
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Login Error", message: "Please check your CADE credentials", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    }))
                    self.present(alert,animated: true,completion: nil)
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Empty Username or Password", message: "Please enter your CADE credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert,animated: true,completion: nil)
            
        }
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
