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
    @IBOutlet weak var uiToolBar: UIToolbar!
    
    
    
    var imageSelectedByUser: UIImage?
   
    
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    
    var pickerController = UIImagePickerController()
    let imageSelectedbyUser = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = UIColor.darkGray
        photoLibraryButton.title = "Photo Library"
        cameraButton.title = "Camera"
        imageViewConstraints(imageView: imagePickerView)
        
   
    
    }

    
    func imageViewConstraints(imageView: UIImageView){
        
        let size = CGSize(width: 400, height: 400)
        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeThatFits(size)
        imageView.contentMode = .scaleAspectFit
        let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0)
        let centerX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([centerY, centerX, leadingConstraint, trailingConstraint])
    }

    
    //MARK: Defining text fields and their delegates
    
    func setText() {
    
        if imageSelectedByUser != nil {


            let topTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let bottomTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                topTextField.text = "Top textfield"
                bottomTextField.text = "Bottom textfield"

            let texts = [topTextField, bottomTextField]

            for text in texts {
                text.delegate = self
                text.defaultTextAttributes = textAttributes
                text.textAlignment = .center
                text.sizeToFit()
                text.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(text)
            }
            let topVerticalConstraint = NSLayoutConstraint(item: topTextField, attribute: .top, relatedBy: .equal, toItem: imagePickerView, attribute: .top, multiplier: 1, constant: 100)
            let topHorizontalConstraint = topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            let bottomHorizontalContraint = bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            let bottomVerticalConstraint = NSLayoutConstraint(item: bottomTextField, attribute: .bottom, relatedBy: .equal, toItem: imagePickerView, attribute: .bottom, multiplier: 1, constant: -10)
            
            NSLayoutConstraint.activate([topVerticalConstraint, topHorizontalConstraint, bottomVerticalConstraint, bottomHorizontalContraint])
        }
     
    }
    


    //MARK: TextFields delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //MARK: Keyboard observers
    
    @objc func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = UIEdgeInsets.zero.bottom
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Checking if device has camera built in
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
  
    //MARK: Buttons on UIBarButton
    
    @IBAction func openCamera(_ sender: AnyObject) {
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = false
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //MARK: 1 - ImagePicker
    
    @IBAction func pickImage(_ sender: Any) {
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: 1.2 - ImagePicker Controller
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if let image = info[.originalImage] as? UIImage {
                imagePickerView.image = image
                dismiss(animated: true, completion: nil)
                
                imageSelectedByUser = imagePickerView.image
                setText()
                
            }
        }
    }
    
    class func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        return true
    }
    
}

