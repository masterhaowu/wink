//
//  ChatFileController.swift
//  wink
//
//  Created by Hao Wu on 6/3/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID";
    
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name;
            
            observeMessages();
        }
    };
    
    var messages = [Message]();
    
    
    func observeMessages() {
        
        messages.removeAll();
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return;
        }
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid);
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key;
            let messageRef = Database.database().reference().child("messages").child(messageID);
            messageRef.observeSingleEvent(of: .value, with: { (messageSnapShot) in
                
                guard let dictionary = messageSnapShot.value as? [String: AnyObject] else {
                    return;
                }
                
                let message = Message();
                //message.setValuesForKeys(dictionary);
                message.fromID = dictionary["fromID"] as? String;
                message.toID = dictionary["toID"] as? String;
                message.text = dictionary["text"] as? String;
                message.timestamp = dictionary["timestamp"] as? Int;
                
                
                if message.chatPartnerID() == self.user?.id {
                    self.messages.append(message);
                    
                    DispatchQueue.main.async {
                        //without dispatch, this will crash because of background thread
                        self.collectionView?.reloadData();
                    }
                }
                
                

                
            }, withCancel: nil);
            
            
        }, withCancel: nil);
        
    }
    
    
    lazy var inputTextField: UITextField = {
        let textFiled = UITextField();
        textFiled.placeholder = "Enter message...";
        textFiled.translatesAutoresizingMaskIntoConstraints = false;
        textFiled.delegate = self;
        return textFiled;
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0);
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0);
        collectionView?.alwaysBounceVertical = true;
        collectionView?.backgroundColor = UIColor.white;
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID);
        
        collectionView?.collectionViewLayout = UICollectionViewFlowLayout();
        
        collectionView?.keyboardDismissMode = .interactive;
        
        //setupKeyboardObservers();
        //setupInputComponents();
    }
    
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView();
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50);
        containerView.backgroundColor = UIColor.white;
        
        
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
        containerView.addSubview(self.inputTextField);
        
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true;
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true;
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true;
        
        
        let separatorLineView = UIView();
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false;
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220);
        containerView.addSubview(separatorLineView);
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true;
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true;
        separatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true;
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true;
        return containerView;
    }()
    
    
    override var inputAccessoryView: UIView? {
        get {

            return inputContainerView;
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true;
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("+++numberOfItems+++");
        return messages.count;
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("+++cellForItemAt+++");
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell;
        
        let message = messages[indexPath.item];
        cell.textView.text = message.text;
        
        setupCell(cell: cell, message: message);
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32;
        //cell.backgroundColor = UIColor.blue;
        return cell;
    }
    
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl);
        }
        
        
        if message.fromID == Auth.auth().currentUser?.uid {
            //outgoing message
            cell.bubbleView.backgroundColor = ChatMessageCell.bubbleBlueColor;
            cell.textView.textColor = UIColor.white;
            cell.bubbleRightAnchor?.isActive = true;
            cell.bubbleLeftAnchor?.isActive = false;
            cell.profileImageView.isHidden = true;
        } else {
            //imcoming message
            cell.bubbleView.backgroundColor = UIColor(r: 240, g:240, b:240);
            cell.textView.textColor = UIColor.black;
            cell.bubbleRightAnchor?.isActive = false;
            cell.bubbleLeftAnchor?.isActive = true;
            cell.profileImageView.isHidden = false;
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80;
        
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 16;
        }
        
        let width = UIScreen.main.bounds.width;
        
        return CGSize(width: width, height: height);
    }
    
    
    private func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000);
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin);
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil);
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout();
    }
    
    
    
    func handleSend() {
        let ref = Database.database().reference().child("messages");
        let childRef = ref.childByAutoId();
        let toID = user?.id;
        let fromID = Auth.auth().currentUser?.uid;
        let timestamp: Int = Int(NSDate().timeIntervalSince1970);
        let values = ["text": inputTextField.text!, "toID": toID!, "fromID": fromID!, "timestamp": timestamp] as [String : Any];
        //childRef.updateChildValues(values);
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!);
                return;
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID!);
            let messageID = childRef.key;
            userMessagesRef.updateChildValues([messageID: 1]);
            
            let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toID!);
            recipientUserMessageRef.updateChildValues([messageID: 1]);
            
            self.inputTextField.text = nil;
        }
        
    }
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        NotificationCenter.default.removeObserver(self);
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect;
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double;
        
        containerBottomAnchor?.constant = -keyboardFrame!.height;
        UIView.animate(withDuration: keyboardDuration!) { 
            self.view.layoutIfNeeded();
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double;
        containerBottomAnchor?.constant = 0;
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded();
        }
    }
    
    
    var containerBottomAnchor: NSLayoutConstraint?;
    
    /*
    func setupInputComponents() {
        
        
        let containerView = UIView();
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        containerView.backgroundColor = UIColor.white;
        
        view.addSubview(containerView);
        //containerView.backgroundColor = UIColor.brown;
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        containerBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor);
        containerBottomAnchor?.isActive = true;
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
    */
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //activate button call by pressing enter
        handleSend();
        return true;
    }
    
}
