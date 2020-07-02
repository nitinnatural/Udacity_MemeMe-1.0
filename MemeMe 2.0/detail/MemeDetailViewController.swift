//
//  MemeDetailViewController.swift
//  MemeMe 1.0 updated to 2.0
//
//  Created by Nitin Anand on 02/07/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {


    @IBOutlet var ivMeme : UIImageView!
    var memedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivMeme.image = memedImage
    }


}
