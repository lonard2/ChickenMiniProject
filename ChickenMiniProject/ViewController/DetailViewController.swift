//
//  DetailViewController.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var item: Meal?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadYtVideo()
    }
    
    private func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: ytTitle.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func loadYtVideo() {
        guard let ytLink = item?.strYoutube else { return }
        
        if let videoID = extractVideoId(from: ytLink) {
            let embedURLString = "https://www.youtube.com/embed/\(videoID)"
            if let embedURL = URL(string: embedURLString) {
                webView.load(URLRequest(url: embedURL))
            }
            linkLabel.attributedText = createTextForYtLink(for: ytLink)
        }
    }
    
    private func extractVideoId(from url: String) -> String? {
        let components = url.components(separatedBy: "=")
        if components.count > 1 {
            return components[1] // get the first available content/video ID from the query parameter
        }
        
        return nil
    }
    
    private func createTextForYtLink(for url: String) -> NSAttributedString {
        let linkText = "Link: \(url)"
        let attributedText = NSMutableAttributedString(string: linkText)
        
        let linkRange = (linkText as NSString).range(of: url)
        attributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
        return attributedText
    }
    
    @objc private func linkTapped() {
        guard let ytLink = item?.strYoutube, let url = URL(string: ytLink) else { return }
        UIApplication.shared.open(url)
    }
    
    private func setupUI() {
        view.addSubview(titleBar)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        if let item = item {
            titleBar.text = item.strMeal
        }
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: titleBar.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(ingredientsTitle)
        ingredientsTitle.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        ingredientsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        ingredientsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(ingredientsListStackView)
        ingredientsListStackView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsListStackView.topAnchor.constraint(equalTo: ingredientsTitle.bottomAnchor, constant: 8).isActive = true
        ingredientsListStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        ingredientsListStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        if let ingredients = item?.strIngredients {
            for ingredient in ingredients {
                let ingredientLabel = UILabel()
                ingredientLabel.text = ingredient
                ingredientLabel.font = .systemFont(ofSize: 16)
                ingredientLabel.textColor = .secondaryLabel
                ingredientsListStackView.addArrangedSubview(ingredientLabel)
            }
        }
        
        view.addSubview(instructionTitle)
        instructionTitle.translatesAutoresizingMaskIntoConstraints = false
        instructionTitle.topAnchor.constraint(equalTo: ingredientsListStackView.bottomAnchor, constant: 8).isActive = true
        instructionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        instructionTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        
        view.addSubview(instructionContent)
        instructionContent.translatesAutoresizingMaskIntoConstraints = false
        instructionContent.topAnchor.constraint(equalTo: instructionTitle.bottomAnchor, constant: 8).isActive = true
        instructionContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        instructionContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(ytTitle)
        ytTitle.translatesAutoresizingMaskIntoConstraints = false
        ytTitle.topAnchor.constraint(equalTo: instructionContent.bottomAnchor, constant: 8).isActive = true
        ytTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        ytTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        
    }
    
    lazy var titleBar: UILabel = {
        let label = UILabel()
        label.text = "Loading..." // placeholder with a loading info until the data is successfully received
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        if let imageUrl = URL(string: item?.strMealThumb ?? "") {
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
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }()
    
    lazy var ingredientsTitle: UILabel = {
        let label = UILabel()
        label.text = "INGREDIENTS"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    lazy var ingredientsListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.alignment = .leading
        
        return stackView
    }()
    
    lazy var instructionTitle: UILabel = {
        let label = UILabel()
        label.text = "INSTRUCTIONS"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    lazy var instructionContent: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var ytTitle: UILabel = {
        let label = UILabel()
        label.text = "This recipe is available on YouTube"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    lazy var ytLink: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 1
        
        return label
    }()
    
    
    lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
}
