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
    
    
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    
    var pickerController = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        photoLibraryButton.title = "Photo Library"
        cameraButton.title = "Camera"
//
//        let newView = UIView()
//        newView.backgroundColor = UIColor.red
//        newView.sizeToFit()
//        view.addSubview(newView)
//
//        newView.translatesAutoresizingMaskIntoConstraints = false
//        let horizontalConstraint = newView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        let verticalConstraint = newView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        let widthConstraint = newView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
//        let heightConstraint = newView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
//        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    
        
        
        defininingTopText()
        definingBottomText()
        resizeImageViewToImageSize(imagePickerView)
        
    }

    func resizeImageViewToImageSize(_ imageView:UIImageView) {
//        let widthRatio = imageView.bounds.size.width / imageView.image!.size.width
//        let heightRatio = imageView.bounds.size.height / imageView.image!.size.height
//        let scale = min(widthRatio, heightRatio)
//        let imageWidth = scale * imageView.image!.size.width
//        let imageHeight = scale * imageView.image!.size.height
//        print("\(imageWidth) - \(imageHeight)")
//
//        imageView.frame = CGRect(x: 0,
//                                 y: 70,
//                                 width: imageWidth,
//                                 height: imageHeight)
//        imageView.center.x = view.center.x
        let screenSize = UIScreen.main.bounds
        imageView.frame.size.width = screenSize.width
        imageView.frame.size.height = screenSize.height
        let leadingConstraints = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([leadingConstraints])
    }
    
    //MARK: Defining text fields and their delegates
    
    func defininingTopText() {
        let topTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        topTextField.text = "This is the top text of your Meme"
        topTextField.defaultTextAttributes = textAttributes
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        topTextField.textAlignment = .center
        
        topTextField.sizeToFit()
        topTextField.delegate = self
        
        view.addSubview(topTextField)
        
        let horizontalConstraint = topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = topTextField.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func definingBottomText() {
        
        let bottomTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bottomTextField.defaultTextAttributes = textAttributes
        bottomTextField.text = "This is the bottom text"
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
        
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomTextField)
        
        let horizontalContraint = bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = NSLayoutConstraint(item: bottomTextField, attribute: .bottom, relatedBy: .equal, toItem: uiToolBar, attribute: .topMargin, multiplier: 1, constant: -10)
        NSLayoutConstraint.activate([horizontalContraint, verticalConstraint])
        
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

