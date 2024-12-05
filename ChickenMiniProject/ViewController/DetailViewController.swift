//
//  DetailViewController.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var itemId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(titleBar)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    lazy var titleBar: UILabel = {
        let label = UILabel()
        label.text = itemId ?? 0 // MARK: To be changed with real data
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
}
