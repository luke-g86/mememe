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
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        self.collectionView?.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeData.arrayOfMemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let img = UIImage(data: MemeData.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage! as Data)
        cell.memeCellImageView.image = img
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 414)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let gmvc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMemeView") as! GenerateMemeViewController
        gmvc.memedImage = UIImage(data: MemeData.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage as! Data)
        gmvc.background = UIColor.white
        self.navigationController?.pushViewController(gmvc, animated: true)
        
    }

}