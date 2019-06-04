//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Lukasz on 31/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  // objects' parameters created with closures
    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()
    
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = 5
        mainImageView.layer.cornerRadius = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(cellView)
        cellView.addSubview(mainImageView)
        cellView.addSubview(topLabel)
        cellView.addSubview(bottomLabel)

        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Constraints
    
    func addSubViewsAndlayout() {
        
        cellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        cellView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        cellView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 10).isActive = true
        cellView.heightAnchor.constraint(equalToConstant:110).isActive = true
        cellView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        mainImageView.centerYAnchor.constraint(equalTo:self.cellView.centerYAnchor).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo:self.cellView.leadingAnchor, constant: 10).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant:110).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        topLabel.topAnchor.constraint(equalTo: self.mainImageView.topAnchor, constant: 20).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 30).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.cellView.trailingAnchor, constant: -10).isActive = true
        
        bottomLabel.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 15).isActive = true
        bottomLabel.leadingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: 30).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: self.cellView.trailingAnchor, constant: -10).isActive = true
        
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
