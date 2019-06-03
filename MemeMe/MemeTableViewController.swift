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
    
    //    static var arrayOfMemes = [MemeData]()
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    
    //    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        loadList()
//        self.title = "MemeMe"
    
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        
        constraints()
        
    }
    
    func constraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        let lead = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
//        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        let trail = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
//
//        NSLayoutConstraint.activate([top, lead, bottom, trail])
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
        return MemeData.arrayOfMemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTebleView") as! TableViewCell
        cell.topLabel.text = MemeData.arrayOfMemes[indexPath.row].topText
        cell.bottomLabel.text = "test"
//        cell.mainImageView.contentMode = .scaleAspectFill
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
            // so if you want your tableView change more smooth reload it here too.
            self?.tableView.reloadData()
       
        }
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            // This block will be called when rotation will be completed
            self?.tableView.reloadData()
        }
        
        coordinator.animate(alongsideTransition: animationHandler, completion: completionHandler)
        
    }

}
