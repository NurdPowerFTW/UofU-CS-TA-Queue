//
//  ClassViewController.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/25/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController {

    var fetchService = WebService()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Courses"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let manager = Manager.shared()
        let currentUser = manager.users![UserDefaults.standard.string(forKey: "CurrentUser")!]
        let url = WebService.shared.FECTH_USER_INO_API_ADDRESS + currentUser!.uName + "/courses"
        fetchService.sendCollectUserInfoRequest(url: url, type: "GET") { (result, done) in
            if done {
                
            }
            else
            {
                
            }
        }
    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
