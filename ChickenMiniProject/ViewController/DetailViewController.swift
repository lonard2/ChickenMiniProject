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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        loadYtVideo()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // Set contentView's width equal to the scrollView's width
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        webView = WKWebView()
        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.layer.cornerRadius = 16
        
        setupUI() // Moved here so all views are initialized first
        setupLinkLabel() // Call after webView is initialized

    }
    
    private func setupLinkLabel() {
        guard webView != nil else {
            fatalError("webView is nil. Ensure setupWebView() is called before setupLinkLabel().")
        }
        contentView.addSubview(linkLabel)
        
        linkLabel.numberOfLines = 2

        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16).isActive = true
        linkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        linkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        linkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tapGesture)
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
    
    private func createCheckboxButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.tag = tag
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        let selectedIngredient = item?.strIngredients[sender.tag] ?? "Unknown ingredient"
        
        if sender.currentImage == UIImage(systemName: "square") {
            // change to checked state
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            // change to unchecked state
            sender.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    private func setupUI() {
        contentView.addSubview(titleBar)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        if let item = item {
            titleBar.text = item.strMeal
        }
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: titleBar.bottomAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let labelPadding: CGFloat = 16
        
        contentView.addSubview(categoryLabelContainer)
        categoryLabelContainer.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.bottomAnchor.constraint(equalTo: categoryLabelContainer.bottomAnchor, constant: -labelPadding).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: categoryLabelContainer.leadingAnchor, constant: labelPadding).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: categoryLabelContainer.trailingAnchor, constant: -labelPadding).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: categoryLabelContainer.topAnchor, constant: labelPadding).isActive = true
        
        categoryLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        categoryLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryLabelContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        
        contentView.addSubview(ingredientsTitle)
        ingredientsTitle.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTitle.topAnchor.constraint(equalTo: categoryLabelContainer.bottomAnchor, constant: 16).isActive = true
        ingredientsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        ingredientsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(ingredientsListStackView)
        ingredientsListStackView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsListStackView.topAnchor.constraint(equalTo: ingredientsTitle.bottomAnchor, constant: 8).isActive = true
        ingredientsListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        ingredientsListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        if let ingredients = item?.strIngredients {
            for (index, ingredient) in ingredients.enumerated() {
                let checkboxButton = createCheckboxButton(title: ingredient, tag: index)
                ingredientsListStackView.addArrangedSubview(checkboxButton)
            }
        }
        
        contentView.addSubview(instructionTitle)
        instructionTitle.translatesAutoresizingMaskIntoConstraints = false
        instructionTitle.topAnchor.constraint(equalTo: ingredientsListStackView.bottomAnchor, constant: 8).isActive = true
        instructionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        instructionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(instructionContent)
        instructionContent.translatesAutoresizingMaskIntoConstraints = false
        instructionContent.topAnchor.constraint(equalTo: instructionTitle.bottomAnchor, constant: 8).isActive = true
        instructionContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        instructionContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(ytTitle)
        ytTitle.translatesAutoresizingMaskIntoConstraints = false
        ytTitle.topAnchor.constraint(equalTo: instructionContent.bottomAnchor, constant: 8).isActive = true
        ytTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        ytTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        webView.topAnchor.constraint(equalTo: ytTitle.bottomAnchor, constant: 16).isActive = true
        webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
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
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    lazy var categoryLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = item?.strArea ?? ""
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
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
        label.text = item?.strInstructions
        label.font = .systemFont(ofSize: 12)
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
