//
//  ChatMessageCell.swift
//  wink
//
//  Created by Hao Wu on 6/7/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView();
        tv.text = "DUMMY TEXT";
        tv.font = UIFont.systemFont(ofSize: 16);
        tv.translatesAutoresizingMaskIntoConstraints = false;
        return tv;
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        addSubview(textView);
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true;
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true;
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true;
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true;
        //backgroundColor = UIColor.red;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
