//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Lukasz on 28/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let width = (view.frame.size.width - 25) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        self.navigationItem.title = "MemeMe"
        self.collectionView.backgroundColor = UIColor.lightGray
        self.collectionView?.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeData.arrayOfMemes.count
    }
    
    // MARK: loading data into the Collection View from array of memes
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let img = UIImage(data: MemeData.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage! as Data)
        cell.memeCellImageView.image = img
    
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
      // MARK: Launching PreviewController
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let pc = self.storyboard?.instantiateViewController(withIdentifier: "PreviewController") as! PreviewViewController
        pc.imageToDisplay = UIImage(data: MemeData.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage as! Data)
        pc.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(pc, animated: true)
        
    }
    
    // MARK: CollectionView animations
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }

}
