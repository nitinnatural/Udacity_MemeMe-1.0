//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Nitin Anand on 25/06/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // camera fix
    // - attributed string issue background
    // - share button issue
    // - handle cancel button
    // update icons.
    // handle keyboard enter button.
    // keyboard issue

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var memedImage:UIImage! = nil
    var isEditingCompleted = false
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.yellow,
        NSAttributedString.Key.foregroundColor: UIColor.orange,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        imageView.contentMode = .scaleToFill
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        subscribeToKeyboardNotification()
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        switch textField.tag {
//        case 0:
//            // top text field
//
//        case 1:
//            // bottom text field
//        default:
//            //
//        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            unSubscribeFromKeyboardNotificaton()
        }
    
        switch textField.tag {
        case 0:
            let text = textField.text
            if text?.count == 0 {
                textField.text = "TOP"
            }
        case 1:
             if textField.text?.count == 0 {
                textField.text = "BOTTOM"
            }
       
        default:
           return
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeFromKeyboardNotificaton()
    }
    
    @IBAction func handleCameraClick(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func handleGalleryClick(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func handleCancelClick(_ sender: Any) {
        // set the top and bottom text to default
        // reset the image view
        // disable the share button.
        // hide the keyboard if open.
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        memedImage = nil
        shareButton.isEnabled = false
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("user cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeFromKeyboardNotificaton(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if self.view.frame.origin.y == 0 {self.view.frame.origin.y -= getKeyboardHeight(notification)}
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y != 0{self.view.frame.origin.y += getKeyboardHeight(notification)}
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        // TODO hide the toolbar  and bottom navigation
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        return memedImage
    }
    
    @IBAction func handleShareClick(_ sender: Any) {
        memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        vc.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.saveMeme() //print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
        }
        present(vc, animated: true, completion: nil)
        
    }
    

    func saveMeme(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage!)
        print(meme)
    }
    
}

