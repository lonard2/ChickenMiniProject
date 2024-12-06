//
//  ContentView.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 04/12/24.
//

import UIKit

class ContentView: UIViewController {
    
    // store Meals data
    var meals: [Meal] = []
    
    lazy var titleBar: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Menu"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    lazy var searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search your menu..."
        searchBar.searchTextField.backgroundColor = .systemBackground
        searchBar.searchTextField.textColor = .label
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        
        return searchBar
    }()
    
    lazy var horizontalFilterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(horizontalFilterStackView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let horizontalFilterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let gridContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func addGridViewController() {
        let gridViewController = GridViewController()
        addChild(gridViewController)
        
        gridContainerView.addSubview(gridViewController.view)
        gridViewController.view.translatesAutoresizingMaskIntoConstraints = false
        gridViewController.view.leadingAnchor.constraint(equalTo: gridContainerView.leadingAnchor).isActive = true
        gridViewController.view.trailingAnchor.constraint(equalTo: gridContainerView.trailingAnchor).isActive = true
        gridViewController.view.topAnchor.constraint(equalTo: gridContainerView.topAnchor).isActive = true
        gridViewController.view.bottomAnchor.constraint(equalTo: gridContainerView.bottomAnchor).isActive = true
        
        gridViewController.didMove(toParent: self)
    }
    
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(titleBar)
        view.addSubview(searchBarView)
        view.addSubview(horizontalFilterStackView)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleBar.bottomAnchor.constraint(equalTo: searchBarView.topAnchor).isActive = true
        titleBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.topAnchor.constraint(equalTo: titleBar.bottomAnchor).isActive = true
        searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBarView.bottomAnchor.constraint(equalTo: horizontalFilterStackView.topAnchor).isActive = true
    
        horizontalFilterStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalFilterStackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor).isActive = true
        horizontalFilterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        horizontalFilterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        horizontalFilterStackView.bottomAnchor.constraint(equalTo: gridContainerView.topAnchor).isActive = true
        
        gridContainerView.translatesAutoresizingMaskIntoConstraints = false
        gridContainerView.topAnchor.constraint(equalTo: horizontalFilterStackView.bottomAnchor).isActive = true
        gridContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gridContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gridContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
