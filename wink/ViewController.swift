//
//  ViewController.swift
//  wink
//
//  Created by Hao Wu on 5/16/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        
    }
    
    func handleLogout() {
        
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
        
        
    }




}

