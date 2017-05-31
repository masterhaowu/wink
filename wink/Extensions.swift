//
//  Extensions.swift
//  wink
//
//  Created by Hao Wu on 5/31/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        
        //check cache for images first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
                
                //self.image = UIImage(data: data!)
                //cell.profileImageView.image = UIImage(data: data!)
                //cell.imageView?.image = UIImage(data: data!)
            }
        }).resume()


    }
    
}
