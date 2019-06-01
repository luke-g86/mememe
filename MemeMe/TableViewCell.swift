//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Lukasz on 31/05/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var mainImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 4, y: 6, width: 30, height: 15))
        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cellView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: self.frame.width - 20, height: 110))
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = 5
        cellView.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainImageView)
        self.addSubview(cellView)
        
//        mainImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        mainImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        mainImageView.layer.cornerRadius = 5.0
//        mainImageView.layer.masksToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
