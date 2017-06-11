//
//  ChatMessageCell.swift
//  wink
//
//  Created by Hao Wu on 6/7/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    
    static let bubbleBlueColor = UIColor(r: 0, g: 137, b: 249);
    
    
    let textView: UITextView = {
        let tv = UITextView();
        tv.text = "DUMMY TEXT";
        tv.font = UIFont.systemFont(ofSize: 16);
        tv.backgroundColor = UIColor.clear;
        tv.textColor = UIColor.white;
        tv.translatesAutoresizingMaskIntoConstraints = false;
        return tv;
    }();
    
    
    let bubbleView: UIView = {
        let bv = UIView();
        bv.backgroundColor = bubbleBlueColor;
        bv.layer.cornerRadius = 16;
        bv.layer.masksToBounds = true;
        bv.translatesAutoresizingMaskIntoConstraints = false;
        return bv;
    }();
    
    
    let profileImageView: UIImageView = {
        let iv = UIImageView();
        iv.image = UIImage(named: "haowu_profile");
        iv.layer.cornerRadius = 16;
        iv.layer.masksToBounds = true;
        iv.contentMode = .scaleAspectFill;
        iv.translatesAutoresizingMaskIntoConstraints = false;
        return iv;
    }()
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?;
    var bubbleRightAnchor: NSLayoutConstraint?;
    var bubbleLeftAnchor: NSLayoutConstraint?;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        addSubview(bubbleView);
        addSubview(textView);
        addSubview(profileImageView);
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8);
        bubbleRightAnchor?.isActive = true;
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8);
        bubbleLeftAnchor?.isActive = false;
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true;
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200);
        bubbleWidthAnchor?.isActive = true;
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true;
        
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true;
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true;
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true;
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true;
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true;
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true;
        //backgroundColor = UIColor.red;
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true;
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true;
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true;
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true;
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
