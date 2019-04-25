//
//  ViewController.swift
//  MemeMe
//
//  Created by Lukasz on 11/04/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    

    let textAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 3.0
    ]
    
    
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoLibraryButton.title = "Photo Library"
        cameraButton.title = "Camera"
        
        let newView = UIView()
        newView.backgroundColor = UIColor.red
        newView.sizeToFit()
        view.addSubview(newView)
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = newView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = newView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = newView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        let heightConstraint = newView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    
        
        
        defininingTopText()
        definingBottomText()
      
  
        
    }

    func resizeImageViewToImageSize(_ imageView:UIImageView) {
        let widthRatio = imageView.bounds.size.width / imageView.image!.size.width
        let heightRatio = imageView.bounds.size.height / imageView.image!.size.height
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * imageView.image!.size.width
        let imageHeight = scale * imageView.image!.size.height
        print("\(imageWidth) - \(imageHeight)")
        
        imageView.frame = CGRect(x: 0,
                                 y: 70,
                                 width: imageWidth,
                                 height: imageHeight)
        imageView.center.x = view.center.x
    }
    
    //MARK: Defining text fields and their delegates
    
    func defininingTopText() {
        let topTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        topTextField.text = "This is the top text of your Meme"
        topTextField.textColor = UIColor.black
        topTextField.textColor?.setStroke()
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = textAttributes
        topTextField.sizeToFit()
        topTextField.delegate = self
        
        view.addSubview(topTextField)
        
        let horizontalConstraint = topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = topTextField.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func definingBottomText() {
        
        let screenBounds = view.safeAreaLayoutGuide.layoutFrame
        let bottomTextField = UITextField(frame: CGRect(x: screenBounds.width/2, y: screenBounds.height - 100, width: 100, height: 100))
        bottomTextField.defaultTextAttributes = textAttributes
        bottomTextField.text = "This is the bottom text"
        bottomTextField.textAlignment = .center
        
        bottomTextField.translatesAutoresizingMaskIntoConstraints = true
        
        
        
        view.addSubview(bottomTextField)
        
        let horizontalContraint = bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = bottomTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([horizontalContraint, verticalConstraint])
        
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    

    //MARK: Checking if device has camera built in
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
  
    //MARK: Buttons on UIBarButton
    
    @IBAction func openCamera(_ sender: AnyObject) {
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = false
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pickImage(_ sender: Any) {
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: ImagePicker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imagePickerView.image = image
                dismiss(animated: true, completion: nil)
            }
        }
        resizeImageViewToImageSize(imagePickerView)
    }
    
    class func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        return true
    }
    
    func defininingConstraints() {
        let newView = UIView()
        newView.backgroundColor = UIColor.white
        view.addSubview(newView)
        
        let horizontalContraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.topMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1, constant: 0)
    }
    
}

