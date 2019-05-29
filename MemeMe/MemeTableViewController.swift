//
//  RootViewWithMemes.swift
//  MemeMe
//
//  Created by Lukasz on 22/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
    
//    static var arrayOfMemes = [MemeData]()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        
       
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadList), for: .valueChanged)
        
    }
    
    @objc func loadList() {
        
        let fetchRequest: NSFetchRequest<MemeData> = MemeData.fetchRequest()
        do {
            let generatedMemes = try PersistanceService.context.fetch(fetchRequest)
            MemeData.arrayOfMemes = generatedMemes
            self.tableView.reloadData()
        } catch {
            let ac = UIAlertController(title: title, message: "Something went wrong", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
            present(ac, animated: true)
        }
        self.refreshControl.endRefreshing()
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
             loadList()
         self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GenerateMemeView") as! GenerateMemeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeData.arrayOfMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = MemeData.arrayOfMemes[indexPath.row].topText
        cell.detailTextLabel?.text = "test"
        cell.imageView?.image = UIImage(data: MemeData.arrayOfMemes[indexPath.row].originalImage! as Data)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
//        previewVC.memedImage = UIImage(data: self.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage as! Data)
//        self.navigationController?.pushViewController(previewVC, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gmvc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateMemeView") as! GenerateMemeViewController
        gmvc.memedImage = UIImage(data: MemeData.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage! as Data)
        gmvc.background = UIColor.white
        self.navigationController?.pushViewController(gmvc, animated: true)
    }
 
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as! GenerateMemeViewController
//    }
    
}

