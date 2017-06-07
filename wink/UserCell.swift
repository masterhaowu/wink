//
//  UserCell.swift
//  wink
//
//  Created by Hao Wu on 6/4/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit;
import Firebase;

class UserCell: UITableViewCell {
    
    
    static var imageRadius: CGFloat = 24
    
    var message: Message? {
        didSet{
            
            setupNameAndProfileImage();
            
            self.detailTextLabel?.text = message?.text;
            
            if let secondsInt = message?.timestamp {
                let seconds = Double(secondsInt);
                let timestampdate: NSDate = NSDate(timeIntervalSince1970: seconds);
                
                //let timestampInt: Int = (message?.timestamp)!;
                
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "MM/dd/yy";
                
                
                //self.timeLabel.text = timestampdate.description;
                self.timeLabel.text = dateFormatter.string(from: (timestampdate as Date));
            }

            
        }
    };
    
    
    private func setupNameAndProfileImage() {
        
        
        
        if let id = message?.chatPartnerID() {
            let ref = Database.database().reference().child("users").child(id);
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    self.textLabel?.text = dictionary["name"] as? String;
                    
                    if let profilePictureUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profilePictureUrl);
                    }
                }
                
            }, withCancel: nil);
        }
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "haowu_profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel();
        //label.text = "HH:MM:SS";
        label.font = UIFont.systemFont(ofSize: 12);
        label.textColor = UIColor.lightGray;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier);
        
        addSubview(profileImageView);
        addSubview(timeLabel);
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true;
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true;
        profileImageView.widthAnchor.constraint(equalToConstant: UserCell.imageRadius * 2).isActive = true;
        profileImageView.heightAnchor.constraint(equalToConstant: UserCell.imageRadius * 2).isActive = true;
        
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true;
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true;
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true;
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true;
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
