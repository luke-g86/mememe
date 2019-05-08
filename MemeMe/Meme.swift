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
    
    let topText: UITextView
    let bottomText: UITextView
    let originalImage: UIImage
    let memedImage: UIImage
    

    init(topText: UITextView, bottomText: UITextView, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
