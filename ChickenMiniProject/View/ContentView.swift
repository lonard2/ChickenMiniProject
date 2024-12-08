//
//  ContentView.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 04/12/24.
//

import UIKit

class ContentView: UIViewController, GridViewControllerDelegate, UISearchBarDelegate {
    
    // store Meals data
    var meals: [Meal] = []
    // store filter/area categories
    var filterCategories: [String] = []
    // store selected filters
    private var selectedFilters: Set<String> = [] // set is unique and efficient on operations
    
    private var gridViewController: GridViewController!
    
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
        
        // border & stroke
        searchBar.layer.cornerRadius = 16
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.systemGray.cgColor
        searchBar.layer.masksToBounds = false
        
        searchBar.showsCancelButton = true
        
        searchBar.delegate = self
        
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
        stackView.spacing = 24
        stackView.distribution = .fill
        return stackView
    }()
    
    let gridContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func addGridViewController() {
        gridViewController = GridViewController()
        gridViewController.delegate = self
        addChild(gridViewController)
        
        gridContainerView.addSubview(gridViewController.view)
        gridViewController.view.translatesAutoresizingMaskIntoConstraints = false
        gridViewController.view.leadingAnchor.constraint(equalTo: gridContainerView.leadingAnchor).isActive = true
        gridViewController.view.trailingAnchor.constraint(equalTo: gridContainerView.trailingAnchor).isActive = true
        gridViewController.view.topAnchor.constraint(equalTo: gridContainerView.topAnchor).isActive = true
        gridViewController.view.bottomAnchor.constraint(equalTo: gridContainerView.bottomAnchor).isActive = true
        
        gridViewController.didMove(toParent: self)
    }
    
    private func setupFilterButtons(with categories: [String]) {
        print("Setting up filter buttons with categories: \(categories)")
        horizontalFilterStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // clear existing buttons
        
        for area in categories {
            let button = PaddedButton(type: .system)
            button.setTitle(area, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = selectedFilters.contains(area) ? UIFont.systemFont(ofSize: 14, weight: .regular) : UIFont.systemFont(ofSize: 14, weight: .bold)
            button.backgroundColor = selectedFilters.contains(area) ? .systemGreen : .systemBlue
            button.layer.borderWidth = 1
            button.layer.borderColor = selectedFilters.contains(area) ? UIColor.systemGreen.cgColor : UIColor.systemBlue.cgColor
            button.layer.cornerRadius = 8
            
            button.titlePadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false // Important for stack view handling
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            print("Adding button for: \(area), Selected: \(selectedFilters.contains(area))")
            
            horizontalFilterStackView.addArrangedSubview(button)
        }
        
        print("Buttons updated. Total buttons: \(horizontalFilterStackView.arrangedSubviews.count)")
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        guard let filter = sender.title(for: .normal) else { return }
        
        // Update selected filters
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter) // deselect filter
            print("Removed filter: \(filter)")
        } else {
            selectedFilters.insert(filter) // select filter
            print("Added filter: \(filter)")
        }

        // Log current selected filters
        print("Current selected filters: \(selectedFilters)")

        // Set up buttons again with the latest selected filters
        setupFilterButtons(with: filterCategories)
        
        applyFilters()
    }
    
    private func applyFilters() {
        guard !selectedFilters.isEmpty else {
            resetFilter()
            return
        }
        
        print("Applying filters: \(selectedFilters)")
        
        let filteredMeals = meals.filter { meal in
            return selectedFilters.contains(meal.strArea)
        }
        
        gridViewController.meals = filteredMeals
        gridViewController.reloadCollectionView()
        
        // Ensure that buttons are set up with the full categories to maintain their states
        setupFilterButtons(with: filterCategories)
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func resetFilter() {
        gridViewController.resetFilter()
    }

    func filterMeals(by area: String) {
        gridViewController.filterMeals(by: area)
    }
    
    func fetchMealsAndSetupFilters() {
        APIHelper.shared.fetchMeals { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
                self?.setupFilterButtons(with: APIHelper.shared.filterCategories)
                
                // pass to GridViewController
                self?.gridViewController.allMeals = meals
                self?.gridViewController.meals = meals
                self?.gridViewController.reloadCollectionView()
                
            case .failure(let error):
                print("Error while fetching the meals data: \(error.localizedDescription)")
            }
        }
    }
    
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(titleBar)
        view.addSubview(searchBarView)
        view.addSubview(horizontalFilterScrollView)
        view.addSubview(gridContainerView)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleBar.bottomAnchor.constraint(equalTo: searchBarView.topAnchor, constant: -16).isActive = true
        titleBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.topAnchor.constraint(equalTo: titleBar.bottomAnchor, constant: 8).isActive = true
        searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -8).isActive = true
    
        horizontalFilterScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalFilterScrollView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 8).isActive = true
        horizontalFilterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        horizontalFilterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        horizontalFilterScrollView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        horizontalFilterStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalFilterStackView.leadingAnchor.constraint(equalTo: horizontalFilterScrollView.leadingAnchor).isActive = true
        horizontalFilterStackView.trailingAnchor.constraint(equalTo: horizontalFilterScrollView.trailingAnchor).isActive = true
        horizontalFilterStackView.topAnchor.constraint(equalTo: horizontalFilterScrollView.topAnchor).isActive = true
        horizontalFilterStackView.bottomAnchor.constraint(equalTo: horizontalFilterScrollView.bottomAnchor).isActive = true
        
        gridContainerView.translatesAutoresizingMaskIntoConstraints = false
        gridContainerView.topAnchor.constraint(equalTo: horizontalFilterScrollView.bottomAnchor).isActive = true
        gridContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gridContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gridContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalFilterScrollView.contentSize = CGSize(width: horizontalFilterStackView.frame.width, height: horizontalFilterStackView.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addGridViewController()
        
        fetchMealsAndSetupFilters()
        setupDismissKeyboardGesture()
    }
}

extension ContentView {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            resetFilter()
            return
        }
        
        // fetch meals data based on the query
        APIHelper.shared.fetchMeals(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.gridViewController.meals = meals
                    self?.gridViewController.reloadCollectionView()
                case .failure(let error):
                    print("Search failed: \(error.localizedDescription)")
                }
            }
        }
        
        // dismiss keyboard after search
        searchBar.resignFirstResponder()
    }
    
    // real time search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            resetFilter()
            return
        }
        
        APIHelper.shared.fetchMeals(query: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.gridViewController.meals = meals
                    self?.gridViewController.reloadCollectionView()
                case .failure(let error):
                    print("Search failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // reset the data after search cancelled
        resetFilter()
        searchBar.resignFirstResponder()
    }
}
