//
//  GenerateMemeViewController.swift
//  MemeMe
//
//  Created by Lukasz on 11/04/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit

class GenerateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let pickerController = UIImagePickerController()
    var memedImage: UIImage?
    let toolBar = UIToolbar()
    var toolBarHeight = CGFloat()
    let camButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: nil, action: nil)
    let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: nil, action: nil)
    var bottomTextTouch = false
    var background = UIColor.darkGray
   

    //MARK: Text attributes
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToDisplay = memedImage {
            imageView.image = imageToDisplay
            updateConstraintsToImage(image: imageToDisplay)
        }

        view.backgroundColor = background
        toolbarCreation()
        saveButton.isEnabled = false
    }
    
    //MARK: Creating toolbar with action buttons
    
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
    
    @IBAction func saveTapped(_ sender: AnyObject){
        save()
    }
    
    func save() {
       
        var usersMeme = Meme(topText: topText, bottomText: bottomText, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        let memeToBeSaved = MemeData(context: PersistanceService.context)
        memeToBeSaved.topText = usersMeme.topText.text
        memeToBeSaved.bottomText = usersMeme.bottomText.text
        let data = usersMeme.originalImage.jpegData(compressionQuality: 0)! as NSData
        memeToBeSaved.originalImage = data
        memeToBeSaved.memedImage = usersMeme.memedImage.jpegData(compressionQuality: 0)! as NSData
        usersMeme.memesArray.append(memeToBeSaved)
        PersistanceService.saveContext()
        
        NotificationCenter.default.post(name: NSNotification.Name("tableReload"), object: nil)
        
        goBack()
    }
    
    func goBack(){
        _ = navigationController?.popToRootViewController(animated: true)
    }

    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        vc.completionWithItemsHandler = {(activity, success, items, error) in
                if (success)
                {
                    self.save()
                }
            }
        present(vc, animated: true)
        
    }
    
    //MARK: View actions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let selectedImage = imageView.image else {
            return
        }
        DispatchQueue.main.async {
            self.updateConstraintsToImage(image: selectedImage)
        }
    }
    
    //MARK: Updating constraints for portrait / landscape images
    
    func updateConstraintsToImage(image: UIImage) {
        
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height - toolBarHeight

        let widthProportion = viewWidth / image.size.width
        let heightProportion = viewHeight / image.size.height
        
        if widthProportion < heightProportion {
            imageViewWidthConstraint.constant = viewWidth
            imageViewHeightConstraint.constant = image.size.height * widthProportion
        } else {
            imageViewHeightConstraint.constant = viewHeight
            imageViewWidthConstraint.constant = image.size.width * heightProportion
        }
        NSLayoutConstraint.activate([imageViewWidthConstraint, imageViewHeightConstraint])
        
        shareButton.isEnabled = true
        saveButton.isEnabled = true
    }

    //MARK: Creating graphics
    
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        let screenShotArea = CGRect(x: -imageView.frame.minX, y: -imageView.frame.minY, width: view.bounds.size.width, height: view.bounds.size.height)
        view.drawHierarchy(in: screenShotArea, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        toolBar.isHidden = false

        return memedImage
    }

    //MARK: Defining text fields and their delegates
    // If there's already set and saved text it might be used
    func setText(_ topText: String? = nil, _ bottomText: String? = nil) {
        // Setting default values for text
        if ((topText != nil) && (bottomText != nil)){
            self.topText.text = topText
            self.bottomText.text = bottomText
        }
        self.topText.text = "TOP TEXT"
        self.bottomText.text = "BOTTOM TEXT"
        
        // Delegate which registers touch on the bottom field to use it further for screen positioning
        self.bottomText.addTarget(self, action: #selector(textFieldTouched(_:)), for: .touchDown)
        
        let texts: [UITextField] = [self.topText, self.bottomText]
        
        for txt in texts {
            txt.delegate = self
            txt.defaultTextAttributes = textAttributes
            txt.backgroundColor = UIColor.clear
            txt.autocapitalizationType = .allCharacters
            txt.textAlignment = .center
            txt.adjustsFontSizeToFitWidth = true
            txt.minimumFontSize = 7
            txt.autoresizingMask = .flexibleHeight
            txt.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(txt)
        }
    }
    
    //MARK: TextFields delegates
    
    // Registering touch on the bottom text field and setting flag to true
    @objc func textFieldTouched(_ textField: UITextField){
        bottomTextTouch = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Keyboard observers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        bottomTextTouch = false
    }
    
    // Logic behind view behabiour when keyboard is shown. If user tap on _top_ text field it will be zoomed. If on a _bottom_, frame will be moved upwards.
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            
            if bottomTextTouch {
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: -keyboardSize.height + window.height)
            } else {
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: window.height + keyboardSize.height)
            }
        }
        toolBar.isHidden = true
    }
    
    // Back to original size
    @objc func keyboardWillHideForResizing(notification: Notification) {
        let viewHeight = UIScreen.main.bounds.height
        
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: self.view.frame.origin.y,
                                 width: self.view.frame.width,
                                 height: viewHeight)
        toolBar.isHidden = false
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowForResizing(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForResizing(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: Buttons on UIBarButton
    
    @objc func openCamera(_ sender: AnyObject) {
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = false
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //MARK: ImagePicker
    
    @objc func pickImage(_ sender: Any) {
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // ImagePicker Controller
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if let image = info[.originalImage] as? UIImage {
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                updateConstraintsToImage(image: image)
                setText()
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    class func isSourceTypeAvailable(_ sourceType: UIImagePickerController.SourceType) -> Bool {
        return true
    }
    
}
