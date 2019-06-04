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

class MemeTableViewController: UIViewController {
    
    
    
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    
    //    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        loadList()
        self.navigationItem.title = "MemeMe"
    
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        
        constraints()
        
    }
    
    func constraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    func setTableView() {
        tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.lightGray
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "MemeTebleView")
        self.view.addSubview(tableView)
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
    
    @objc func deleteData() {
        
        let fetchRequest: NSFetchRequest<MemeData> = MemeData.fetchRequest()
        do {
            let arrayOfMemes = try PersistanceService.context.fetch(fetchRequest)
            PersistanceService.context.delete(arrayOfMemes[1])
            PersistanceService.saveContext()
            self.tableView.reloadData()
        } catch {
            let ac = UIAlertController(title: title, message: "Something went wrong", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
            present(ac, animated: true)
        }
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
}


extension MemeTableViewController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Items \(MemeData.arrayOfMemes.count)")
        return MemeData.arrayOfMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTebleView") as! TableViewCell
        cell.topLabel.text = MemeData.arrayOfMemes[indexPath.row].topText?.capitalized
        cell.bottomLabel.text = MemeData.arrayOfMemes[indexPath.row].bottomText?.capitalized
        cell.mainImageView.image = UIImage(data: MemeData.arrayOfMemes[indexPath.row].memedImage! as Data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let pc = self.storyboard?.instantiateViewController(withIdentifier: "PreviewController") as! PreviewViewController
        pc.imageToDisplay = UIImage(data: MemeData.arrayOfMemes[(indexPath as NSIndexPath).row].memedImage! as Data)
        pc.view.backgroundColor = UIColor.white

        self.navigationController?.pushViewController(pc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let animationHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            // This block will be called several times during rotation,
            // so the tableView change more smoothly
            self?.tableView.reloadData()
            self?.tableView.frame = self!.view.frame
        }
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            // This block will be called when rotation will be completed
            self?.tableView.reloadData()
        }
        coordinator.animate(alongsideTransition: animationHandler, completion: completionHandler)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete) {
            
            //MARK: Deleting data from database
            
            let commit = MemeData.arrayOfMemes[indexPath.row]
            PersistanceService.context.delete(commit)
            MemeData.arrayOfMemes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            PersistanceService.saveContext()
            tableView.reloadData()
        }
    }
}


