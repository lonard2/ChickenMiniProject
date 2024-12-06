//
//  GridViewController.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import UIKit

// reusable grid component (UI)
class GridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    var meals: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        fetchAndReloadMeals()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width / 2 - 16, height: 250) // layout (grid) size
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuItem.self, forCellWithReuseIdentifier: "Menu Cell")
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leadingConstraint = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailingConstraint = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    // dequeue reusable cell for each items available
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItem", for: indexPath) as! MenuItem
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
    
    func fetchAndReloadMeals() {
        APIHelper.shared.fetchMeals{ [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self.meals = meals
                    self.collectionView.reloadData()
                    
//                    // navigate to GridViewController after fetching meals
//                    let gridVC = GridViewController()
//                    gridVC.meals = meals
//                    self.navigationController?.pushViewController(gridVC, animated: true)
//                    
                case .failure(let error):
                    print("Error fetching meals: \(error.localizedDescription)")
                }
            }
            

        }
    }
}
