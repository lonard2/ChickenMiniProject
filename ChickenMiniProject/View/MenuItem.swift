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
            if let imageUrl = URL(string: menuItem.strMealThumb) {
                URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                    guard let data else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }.resume()
            } else {
                self.imageView.image = UIImage(systemName: "exclamationmark.circle")
            }
        }
    }
    
    lazy var menuLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    lazy var categoryLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        contentView.addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        menuLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        let labelPadding: CGFloat = 8
        
        contentView.addSubview(categoryLabelContainer)
        categoryLabelContainer.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.bottomAnchor.constraint(equalTo: categoryLabelContainer.bottomAnchor, constant: -labelPadding).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: categoryLabelContainer.leadingAnchor, constant: labelPadding).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: categoryLabelContainer.topAnchor, constant: -labelPadding).isActive = true
        
        categoryLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        categoryLabelContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        categoryLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        categoryLabelContainer.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
