//
//  PreviewViewController.swift
//  MemeMe
//
//  Created by Lukasz on 26/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    
    var memedImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = memedImage
    }
    
}
