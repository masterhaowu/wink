//
//  ChatFileController.swift
//  wink
//
//  Created by Hao Wu on 6/3/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name;
        }
    };
    
    
    lazy var inputTextField: UITextField = {
        let textFiled = UITextField();
        textFiled.placeholder = "Enter message...";
        textFiled.translatesAutoresizingMaskIntoConstraints = false;
        textFiled.delegate = self;
        return textFiled;
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        collectionView?.backgroundColor = UIColor.white;
        
        
        setupInputComponents();
    }
    
    
    
    func handleSend() {
        let ref = Database.database().reference().child("messages");
        let childRef = ref.childByAutoId();
        let toID = user?.id;
        let fromID = Auth.auth().currentUser?.uid;
        let timestamp: Int = Int(NSDate().timeIntervalSince1970);
        let values = ["text": inputTextField.text!, "toID": toID!, "fromID": fromID!, "timestamp": timestamp] as [String : Any];
        childRef.updateChildValues(values);
    }
    
    
    func setupInputComponents() {
        
        
        let containerView = UIView();
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(containerView);
        //containerView.backgroundColor = UIColor.brown;
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        
        
        let sendButton = UIButton(type: .system);
        sendButton.setTitle("Send", for: .normal);
        sendButton.translatesAutoresizingMaskIntoConstraints = false;
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside);
        containerView.addSubview(sendButton);
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true;
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true;
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true;
        
        //let inputTextField = UITextField();
        //inputTextField.placeholder = "Enter message...";
        //inputTextField.translatesAutoresizingMaskIntoConstraints = false;
        containerView.addSubview(inputTextField);
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true;
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true;
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true;
        
        
        let separatorLineView = UIView();
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false;
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220);
        containerView.addSubview(separatorLineView);
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true;
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true;
        separatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true;
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true;
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //activate button call by pressing enter
        handleSend();
        return true;
    }
    
}
