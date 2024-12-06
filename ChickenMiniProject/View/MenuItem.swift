//
//  MenuItem.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 06/12/24.
//

import UIKit

class MenuItem: UICollectionViewCell {
    var menuItem: Meal? {
        didSet {
            guard let menuItem else { return }
            menuLabel.text = menuItem.strMeal
            categoryLabel.text = menuItem.strCategory

        }
    }
    
    lazy var menuLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        if let imageUrl = URL(string: menuItem?.strMealThumb ?? "") {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    image.image = UIImage(data: data)
                }
            }.resume()
        } else {
            image.image = UIImage(systemName: "exclamationmark.circle")
        }
        
        return image
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        menuLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 8).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
