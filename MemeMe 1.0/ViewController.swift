//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Nitin Anand on 25/06/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // todo
    // camera fix
    // attributed text
    // autolayout correction
    // keyboard issue

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memedImage:UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        subscribeToKeyboardNotification()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        unSubscribeFromKeyboardNotificaton()
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func handleCancelClick(_ sender: Any) {
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("user cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unSubscribeFromKeyboardNotificaton(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        // TODO hide the toolbar  and bottom navigation
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
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

