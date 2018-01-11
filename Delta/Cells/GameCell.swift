//
//  GameCell.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit

final class GameCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(stackView)
        stackView.pinToSuperviewEdges()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views

    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.imageView, self.titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
 
    lazy private(set) var imageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    
    lazy private(set) var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        return titleLabel
    }()
    
}
