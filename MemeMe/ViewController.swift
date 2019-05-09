//
//  ViewController.swift
//  MemeMe
//
//  Created by Lukasz on 11/04/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
//    @IBOutlet weak var imagePickerView: UIImageView!
    
    var imagePickerView = UIImageView()
    var imageSelectedByUser: UIImage?
    var pickerController = UIImagePickerController()
    var imageSelectedbyUser = UIImage()
    let toolBar = UIToolbar()
    let navBar = UINavigationBar()
    var toolBarHeight = CGFloat()
    let camButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: nil, action: nil)
    let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: nil, action: nil)
    var imageViewHeightConstraint = NSLayoutConstraint()
    var imageViewWidthConstraint = NSLayoutConstraint()
    let topTextField = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let bottomTextField = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    
    //MARK: Text attributes
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray
        view.updateConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        view.addSubview(navBar)
        toolbarCreation()
        imageViewSetup()
        
        
        
        print("toolbar height: \(toolBar.frame.size.height)")
       
    }

    func save() {
        let meme = Meme(topText: topTextField, bottomText: bottomTextField, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }

    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//        vc.completionWithItemsHandler = {save()}
        present(vc, animated: true)
        
    }
    
    //MARK: Checking if device has camera built in
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    func toolbarCreation() {
        
        toolBar.sizeToFit()
        let photoLibraryButton = UIBarButtonItem(title: "Photo Library", style: UIBarButtonItem.Style.plain, target: self, action: #selector(pickImage(_:)))
        let flexiSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
        camButton.target = self
        camButton.action = #selector(openCamera(_:))
        shareButton.target = self
        shareButton.action = #selector(shareTapped)
        shareButton.isEnabled = false
        
        var items = [UIBarButtonItem]()
        items.append(photoLibraryButton)
        items.append(flexiSpace)
        items.append(camButton)
        items.append(flexiSpace)
        items.append(shareButton)
        
        toolBar.setItems(items, animated: true)
        
        view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBarHeight = toolBar.frame.size.height
        
        let bottomConstraint = toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        let leadingConstaint = toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
        let trailingConstraint = toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([bottomConstraint, leadingConstaint, trailingConstraint])
    }

    
    func imageViewSetup(){
        
        let imageView = imagePickerView
        
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
    
        let centerX = imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0)
        let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: -toolBarHeight/2)
        NSLayoutConstraint.activate([centerX, centerY])
    }
    
    func updateConstraintsToImage(image: UIImage, imageView: UIImageView) {
        
        let widthProportion = view.bounds.width / image.size.width
        let heightProportion = view.bounds.height / image.size.height
        let imageViewWidthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        let imageViewHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)

        
        if widthProportion < heightProportion {
            imageViewWidthConstraint.constant = view.bounds.width
            imageViewHeightConstraint.constant = image.size.height * widthProportion
        } else {
            imageViewHeightConstraint.constant = image.size.height
            imageViewWidthConstraint.constant = view.bounds.width
        }
        NSLayoutConstraint.activate([imageViewWidthConstraint, imageViewHeightConstraint])

        shareButton.isEnabled = true
    }

//    func save(_ memedImage: UIImage) {
//        let meme = Meme(topText: topTextField, bottomText: bottomTextField, originalImage: imagePickerView.image!, memedImage: memedImage)
//    }
//
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        
        return memedImage
    }
    
    //MARK: Defining text fields and their delegates
    
    func setText() {
    
        if imagePickerView.image != nil {
            
           
            let texts = [topTextField, bottomTextField]

        for text in texts {
                text.delegate = self
                text.backgroundColor = UIColor.clear
                text.typingAttributes = textAttributes
                text.textAlignment = .center
                text.textContainer.maximumNumberOfLines = 2
                text.textContainer.lineBreakMode = .byWordWrapping
                text.autoresizingMask = .flexibleHeight
              
                text.sizeToFit()
                text.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(text)
            
            }
            topTextField.text = "Top text"
            bottomTextField.text = "Bottom text"
            
            
            let widthTopText = NSLayoutConstraint(item: topTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.width - 50)
            let heightTopText = NSLayoutConstraint(item: topTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            let centerTopText = NSLayoutConstraint(item: topTextField, attribute: .centerX, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0)
            let downToText = NSLayoutConstraint(item: topTextField, attribute: .top, relatedBy: .equal, toItem: imagePickerView, attribute: .top, multiplier: 1, constant: 0)
            let widthBottomText = NSLayoutConstraint(item: bottomTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.width - 50)
            let heightBottomText = NSLayoutConstraint(item: bottomTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            let centerBottomText = NSLayoutConstraint(item: bottomTextField, attribute: .centerX, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0)
            let upToText = NSLayoutConstraint(item: bottomTextField, attribute: .bottom, relatedBy: .equal, toItem: imagePickerView, attribute: .bottom, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([widthTopText, heightTopText, centerTopText, downToText, widthBottomText, heightBottomText, centerBottomText, upToText])
            
        }
    }
    
    //MARK: TextFields delegates
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    

    //MARK: Buttons on UIBarButton
    
    @objc func openCamera(_ sender: AnyObject) {
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = false
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //MARK: 1 - ImagePicker
    
    @objc func pickImage(_ sender: Any) {
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
                updateConstraintsToImage(image: image, imageView: imagePickerView)
                dismiss(animated: true, completion: nil)
                
                setText()
            }
        }
    }
    
    class func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        return true
    }
    
}

