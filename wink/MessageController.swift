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
    
    var cellID = "cellID";
    var messages = [Message]();
    var messagesDict = [String: Message]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //let ref = Database.database().reference()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        //let image = UIImage(named: "create_message")
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage));
        
        checkUserLoggedIn();
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID);
        
        observeMessages();
        
        
    }
    
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages");
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message();
                message.text = dictionary["text"] as? String;
                message.fromID = dictionary["fromID"] as? String;
                message.toID = dictionary["toID"] as? String;
                message.timestamp = dictionary["timestamp"] as? Int;
                
                //self.messages.append(message);
                if let toID = message.toID {
                    self.messagesDict[toID] = message;
                    self.messages = Array(self.messagesDict.values);
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        if let val1 = message1.timestamp, let val2 = message2.timestamp {
                            return val1 > val2;
                        }
                        return true;
                    })
                }
                
                
                DispatchQueue.main.async {
                    //without dispatch, this will crash because of background thread
                    self.tableView.reloadData()
                }

                
            }
            
        }, withCancel: nil)
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
        
        
        //titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)));
        
        self.navigationItem.titleView = titleView;
        //self.navigationItem.title = user.name;
        
    }
    
    
    func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewLayout());
        chatLogController.user = user;
        navigationController?.pushViewController(chatLogController, animated: true);
    }
    
    
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messageController = self;
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID");
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell;
        
        let message = messages[indexPath.row];
        cell.message = message;
        
//        if let toID = message.toID {
//            let ref = Database.database().reference().child("users").child(toID);
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                if let dictionary = snapshot.value as? [String: Any] {
//                    cell.textLabel?.text = dictionary["name"] as? String;
//                    
//                    if let profilePictureUrl = dictionary["profileImageUrl"] as? String {
//                        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profilePictureUrl);
//                    }
//                }
//                
//            }, withCancel: nil);
//        }
//        
//        cell.detailTextLabel?.text = message.text;
        
        
        return cell;
    }




}

