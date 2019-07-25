//
//  Meme.swift
//  MemeMe
//
//  Created by Lukasz on 08/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    let topText: UITextField
    let bottomText: UITextField
    let originalImage: UIImage
    let memedImage: UIImage
    var memesArray = MemeData.arrayOfMemes
    
    static var memeTable = [MemeData]()

    init(topText: UITextField, bottomText: UITextField, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
        
    }
}

