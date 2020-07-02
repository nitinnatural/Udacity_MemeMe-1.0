//
//  TabBarController.swift
//  MemeMe 1.0
//
//  Created by Nitin Anand on 01/07/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizingMask = .flexibleHeight
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        = "Sent Memes"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
