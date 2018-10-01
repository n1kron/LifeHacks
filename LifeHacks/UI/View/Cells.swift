//
//  Cells.swift
//  LifeHacks
//
//  Created by  Kostantin Zarubin on 10.09.2018.
//  Copyright © 2018  Kostantin Zarubin. All rights reserved.
//

import UIKit

class HackTableViewCell: UITableViewCell {
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hackImageView.layer.cornerRadius = 8.0
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
}

class DetailHackTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageStackView: UIStackView!
    let imageHeight: CGFloat = Consts.isIpad ? UIScreen.main.bounds.size.height * 0.43923 : UIScreen.main.bounds.size.height * 0.2463
    
    func removeImages() {
        for image in imageStackView.arrangedSubviews {
            imageStackView.removeArrangedSubview(image)
            image.removeFromSuperview()
        }
    }
    
    func addImage(image: String) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        imageView.kf.setImage(with: URL(string: image), completionHandler: { [weak self] (image, error, cacheType, imageUrl) in
            self?.imageStackView.addArrangedSubview(imageView)
            self?.imageStackView.layoutIfNeeded()
        })
    }
}

class GoldCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hackImageView.layer.cornerRadius = 8.0
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
}

class SilverCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hackImageView.layer.cornerRadius = 8.0
        if #available(iOS 11.0, *) {
            hackImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 5, 10, 5))
    }
}
