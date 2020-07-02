//
//  ViewController.swift
//  MemeMe 1.0 updated to 2.0
//
//  Created by Nitin Anand on 25/06/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var memedImage:UIImage! = nil
    var isEditingCompleted = false
    var currentSelectedTextField: UITextField? = nil
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.yellow,
        NSAttributedString.Key.foregroundColor: UIColor.orange,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemeTextField(textField: topTextField, text: "TOP")
        configureMemeTextField(textField: bottomTextField, text: "BOTTOM")
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        imageView.contentMode = .scaleToFill
    }
    
    func configureMemeTextField(textField: UITextField, text:String){
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentSelectedTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeFromKeyboardNotificaton()
    }
    
    @IBAction func handleCameraClick(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
    
    @IBAction func handleGalleryClick(_ sender: Any) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
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
        if (currentSelectedTextField != nil && currentSelectedTextField?.tag == 1) {
            if self.view.frame.origin.y == 0 {self.view.frame.origin.y -= getKeyboardHeight(notification)}
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
       if (currentSelectedTextField != nil && currentSelectedTextField?.tag == 1) {
            if self.view.frame.origin.y != 0{self.view.frame.origin.y += getKeyboardHeight(notification)}
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
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
            if(success) {
                self.saveMeme()
            }
            self.dismiss(animated: true, completion: nil)
        }
        present(vc, animated: true, completion: nil)
        
    }
    
    func saveMeme(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage!)
        // save it to the app delegate
        (UIApplication.shared.delegate as! AppDelegate).memeList.append(meme)
    }
    
}

