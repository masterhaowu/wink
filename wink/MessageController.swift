//
//  ViewController.swift
//  wink
//
//  Created by Hao Wu on 5/16/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //let ref = Database.database().reference()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //let image = UIImage(named: "create_message")
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage));
        
        checkUserLoggedIn()
        
        
    }
    
    
    func checkUserLoggedIn()
    {
        // if user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        } else {
            fetchUserDataAndSetupNavbarTitle();
        }

    }
    
    
    func fetchUserDataAndSetupNavbarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //print("check uid")
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print("ready to set title");
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String;
                
                let user = User();
                user.name = dictionary["name"] as? String;
                user.email = dictionary["email"] as? String;
                user.profileImageUrl = dictionary["profileImageUrl"] as? String;
                
                self.setupNavbarWithUser(user: user);
                
            }
            
            
            
        }, withCancel: nil);

    }
    
    
    
    func setupNavbarWithUser(user: User) {
        
        let titleView = UIView();
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40);
        
        let containerView = UIView();
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        titleView.addSubview(containerView);
        
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true;
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true;
        
        
        //titleView.backgroundColor = UIColor.black;
        let profileImageView = UIImageView();
        profileImageView.contentMode = .scaleAspectFill;
        profileImageView.layer.cornerRadius = 20;
        profileImageView.clipsToBounds = true;
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl);
           
        }
        containerView.addSubview(profileImageView);
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true;
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true;
 
        let nameLabel = UILabel();
        nameLabel.text = user.name;
        containerView.addSubview(nameLabel);
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true;
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true;
        nameLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true;
        
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)));
        
        self.navigationItem.titleView = titleView;
        //self.navigationItem.title = user.name;
        
    }
    
    
    func showChatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewLayout());
        navigationController?.pushViewController(chatLogController, animated: true);
    }
    
    
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        
        loginController.messageController = self;
        
        present(loginController, animated: true, completion: nil)
        
        
    }




}

