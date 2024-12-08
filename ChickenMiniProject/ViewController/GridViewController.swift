//
//  GridViewController.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import UIKit

protocol GridViewControllerDelegate: AnyObject {
    func filterMeals(by area: String)
    func resetFilter()
}

// reusable grid component (UI)
class GridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var meals: [Meal] = []
    var allMeals: [Meal] = []
    weak var delegate: GridViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        fetchAndReloadMeals()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfItemsPerRow: CGFloat = 2
            let padding: CGFloat = 16 * 2 // left + right + Inter-item spacing
            let availableWidth = view.bounds.width - padding
            let itemWidth = availableWidth / numberOfItemsPerRow
            layout.itemSize = CGSize(width: itemWidth, height: view.bounds.height * 0.3)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // layout (grid) size moved to viewWillLayoutSubviews
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuItem.self, forCellWithReuseIdentifier: "MenuCell")
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leadingConstraint = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailingConstraint = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    
        // initial alpha to 0 (at first) - fade-in
        collectionView.alpha = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    // dequeue reusable cell for each items available
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuItem
        cell.menuItem = meals[indexPath.item]
        return cell
    }
    
    // for navigation logic during a tap to a grid cell - to its menu detail
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeal = meals[indexPath.item]
        let menuDetailVC = DetailViewController()
        menuDetailVC.item = selectedMeal
        navigationController?.pushViewController(menuDetailVC, animated: true)
    }
    
    func filterMeals(by area: String) {
        meals = allMeals.filter { $0.strArea == area}
        
        self.collectionView.reloadData()
    }
    
    func resetFilter() {
        meals = allMeals
        
        self.collectionView.reloadData()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func fetchAndReloadMeals() {
        APIHelper.shared.fetchMeals{ [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self.allMeals = meals
                    self.meals = meals
                    self.collectionView.reloadData()
                    
                    UIView.animate(withDuration: 1.0) {
                        self.collectionView.alpha = 1
                    }
//                    
                case .failure(let error):
                    print("Error fetching meals: \(error.localizedDescription)")
                }
            }
            

        }
    }
}
