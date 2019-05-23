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

class RootViewWithMemes: UIViewController, UITableViewDataSource {
    
    var arrayOfMemes = [MemeData]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
    }
    
    @objc func loadList() {
        
        let fetchRequest: NSFetchRequest<MemeData> = MemeData.fetchRequest()
        do {
            let generatedMemes = try PersistanceService.context.fetch(fetchRequest)
            self.arrayOfMemes = generatedMemes
            self.tableView.reloadData()
        } catch {
            let ac = UIAlertController(title: title, message: "Something went wrong", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
             self.tableView.reloadData()
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
        return arrayOfMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = arrayOfMemes[indexPath.row].topText
        cell.detailTextLabel?.text = "test"
        cell.imageView?.image = UIImage(data: arrayOfMemes[indexPath.row].originalImage as! Data)
        return cell
    }
    
 
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as! GenerateMemeViewController
//    }
    
}

