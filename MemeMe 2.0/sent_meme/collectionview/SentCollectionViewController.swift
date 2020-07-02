//
//  SentCollectionViewController.swift
//  MemeMe 1.0 updated to 2.0
//
//  Created by Nitin Anand on 01/07/20.
//  Copyright © 2020 Ni3X. All rights reserved.
//

import UIKit

class SentCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memeList = [Meme]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                            target: self, action: #selector(handleNewMemeClick))
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeList = (UIApplication.shared.delegate as! AppDelegate).memeList
        collectionView.reloadData()
    }
    
    
    @objc func handleNewMemeClick(){
        performSegue(withIdentifier: "segue_meme_editor", sender: self)
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.imageView.image = memeList[indexPath.row].memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "memeDetailView")as! MemeDetailViewController
        vc.memedImage = memeList[indexPath.row].memedImage
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
