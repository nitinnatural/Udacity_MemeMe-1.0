//
//  MemeTableViewController.swift
//  MemeMe 1.0 updated to 2.0
//
//  Created by Nitin Anand on 01/07/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    
    var memeList = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeList = (UIApplication.shared.delegate as! AppDelegate).memeList
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_table_view_cell", for: indexPath) as! CustomTableViewCell
        let meme = memeList[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        cell.title.text = meme.topText + "..." + meme.bottomText
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "memeDetailView")as! MemeDetailViewController
        vc.memedImage = memeList[indexPath.row].memedImage
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
   

}
