//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Lukasz on 31/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  
    lazy var cellView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: UIScreen.main.bounds.width - 20, height: 110))
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 6, width: 110, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 160, y: 15, width: cellView.frame.width - 116, height: 30))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 160, y: 40, width: cellView.frame.width - 116, height: 30))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = 5
//        cellView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 0
        mainImageView.clipsToBounds = true

//        let top = NSLayoutConstraint.init(item: cellView, attribute: .top, relatedBy: .equal, toItem: contentView.safeAreaLayoutGuide, attribute: .top, multiplier: 0, constant: 1)
//        let bottom = NSLayoutConstraint.init(item: cellView, attribute: .bottom, relatedBy: .equal, toItem: contentView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 0, constant: 1)
//        let leading = NSLayoutConstraint.init(item: cellView, attribute: .leading, relatedBy: .equal, toItem: contentView.safeAreaLayoutGuide, attribute: .leading, multiplier: 0, constant: 1)
//        let trailing = NSLayoutConstraint.init(item: cellView, attribute: .trailing, relatedBy: .equal, toItem: contentView.safeAreaLayoutGuide, attribute: .trailing, multiplier: 0, constant: 1)
//
//        NSLayoutConstraint.activate([top, bottom, leading, trailing])
        
//        cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(cellView)
        cellView.addSubview(mainImageView)
        cellView.addSubview(topLabel)
        cellView.addSubview(bottomLabel)

//        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViewsAndlayout() {
     //will crash if not added
    
    let screenwidth = UIScreen.main.bounds.width //get any other properties you need
    
    cellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 1).isActive = true
    cellView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    cellView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 1).isActive = true
//    cellView.rightAnchor.constraint(equalTo: otherViewToTheSide.rightAnchor, constant: -24).isActive = true
    
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   
        // Configure the view for the selected state
    }

}
