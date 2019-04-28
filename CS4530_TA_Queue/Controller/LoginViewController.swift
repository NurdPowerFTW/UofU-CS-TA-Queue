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
        navigationItem.title = "Login Page"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @IBAction func login(_ sender: Any) {
//        if uNameField.text?.count != 0 && passField.text?.count != 0
//        {
            //TODO: fix the hard coded usname/password
            loginService.sendLoginRequest(username: "u1169036", password: "81018050aB@!", url: loginService.LOGIN_API_ADDRESS, type: "POST") { (result, done) in
                if done
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let classVC = storyboard.instantiateViewController(withIdentifier: "ClassVC")
                    self.navigationController?.pushViewController(classVC, animated: true)
                    
                }
                else
                {
                    self.createAlert(title: "Login Error", message: result)
                }
                
            }
//        }
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
