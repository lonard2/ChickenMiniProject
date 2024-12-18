//
//  DetailViewController.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 05/12/24.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        loadYtVideo()
        ingredientsListStackView.isHidden = isIngredientsCollapsed
        instructionContent.isHidden = isInstructionsCollapsed
        webView.isHidden = isYtToggleCollapsed
    }
    
    var item: Meal?
    private var webView: WKWebView!
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var ingredientsToggleButton: UIButton = createToggleButton(title: "INGREDIENTS")
    private lazy var instructionsToggleButton: UIButton = createToggleButton(title: "INSTRUCTIONS")
    private lazy var ytToggleButton: UIButton = createToggleButton(title: "This recipe is available on YouTube")
    
    // state tracking for collapse/expand
    private lazy var isIngredientsCollapsed: Bool = false
    private lazy var isInstructionsCollapsed: Bool = false
    private lazy var isYtToggleCollapsed: Bool = false
    
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
    
    lazy var areaLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var areaLabelImage: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "globe")
        icon.tintColor = .white
        icon.frame.size = CGSize(width: 24, height: 24)
        return icon
    }()
    
    lazy var areaLabel: UILabel = {
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
    
    lazy var categoryLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var categoryLabelImage: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "shippingbox.fill")
        icon.tintColor = .white
        icon.frame.size = CGSize(width: 24, height: 24)
        return icon
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = item?.strCategory ?? ""
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
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
    
    lazy var instructionContent: UILabel = {
        let label = UILabel()
        label.text = item?.strInstructions
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.textColor = .label
        label.numberOfLines = 0
        
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
        button.titleLabel?.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        button.contentHorizontalAlignment = .left
        button.tag = tag
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "square") {
            // change to checked state
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            // change to unchecked state
            sender.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    private func createToggleButton(title: String) -> UIButton {
        let button = UIButton(type: .system) // linter: SwiftLint (static analytics) - nice to have
        button.setTitle("\(title) ▼", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func toggleSection(_ sender: UIButton) {
        switch sender {
        case ingredientsToggleButton:
            isIngredientsCollapsed.toggle()
            ingredientsListStackView.isHidden = isIngredientsCollapsed
            ingredientsToggleButton.setTitle(isIngredientsCollapsed ? "INGREDIENTS ▶" : "INGREDIENTS ▼", for: .normal)
            
        case instructionsToggleButton:
            isInstructionsCollapsed.toggle()
            instructionContent.isHidden = isInstructionsCollapsed
            instructionsToggleButton.setTitle(isInstructionsCollapsed ? "INSTRUCTIONS ▶" : "INSTRUCTIONS ▼", for: .normal)
            
        case ytToggleButton:
            isYtToggleCollapsed.toggle()
            webView.isHidden = isYtToggleCollapsed
            ytToggleButton.setTitle(isYtToggleCollapsed ? "This recipe is available on YouTube ▶" : "This recipe is available on YouTube ▼", for: .normal)
            
        default:
            break
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
        
        contentView.addSubview(areaLabelContainer)
        areaLabelContainer.addSubview(areaLabelImage)
        areaLabelContainer.addSubview(areaLabel)
        
        areaLabelImage.translatesAutoresizingMaskIntoConstraints = false
        areaLabelImage.bottomAnchor.constraint(equalTo: areaLabelContainer.bottomAnchor, constant: -labelPadding).isActive = true
        areaLabelImage.leadingAnchor.constraint(equalTo: areaLabelContainer.leadingAnchor, constant: labelPadding).isActive = true
        areaLabelImage.topAnchor.constraint(equalTo: areaLabelContainer.topAnchor, constant: labelPadding).isActive = true

        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.bottomAnchor.constraint(equalTo: areaLabelContainer.bottomAnchor, constant: -labelPadding).isActive = true
        areaLabel.leadingAnchor.constraint(equalTo: areaLabelImage.trailingAnchor, constant: labelPadding).isActive = true
        areaLabel.trailingAnchor.constraint(equalTo: areaLabelContainer.trailingAnchor, constant: -labelPadding).isActive = true
        areaLabel.topAnchor.constraint(equalTo: areaLabelContainer.topAnchor, constant: labelPadding).isActive = true
        
        areaLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        areaLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        areaLabelContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        
        contentView.addSubview(categoryLabelContainer)
        categoryLabelContainer.addSubview(categoryLabelImage)
        categoryLabelContainer.addSubview(categoryLabel)
        
        categoryLabelImage.translatesAutoresizingMaskIntoConstraints = false
        categoryLabelImage.bottomAnchor.constraint(equalTo: categoryLabelContainer.bottomAnchor, constant: -labelPadding).isActive = true
        categoryLabelImage.leadingAnchor.constraint(equalTo: categoryLabelContainer.leadingAnchor, constant: labelPadding).isActive = true
        categoryLabelImage.topAnchor.constraint(equalTo: categoryLabelContainer.topAnchor, constant: labelPadding).isActive = true

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.bottomAnchor.constraint(equalTo: categoryLabelContainer.bottomAnchor, constant: -labelPadding).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: categoryLabelImage.trailingAnchor, constant: labelPadding).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: categoryLabelContainer.trailingAnchor, constant: -labelPadding).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: categoryLabelContainer.topAnchor, constant: labelPadding).isActive = true
        
        categoryLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        categoryLabelContainer.leadingAnchor.constraint(equalTo: areaLabelContainer.trailingAnchor, constant: 16).isActive = true
        categoryLabelContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        
        contentView.addSubview(ingredientsToggleButton)
        ingredientsToggleButton.translatesAutoresizingMaskIntoConstraints = false
        ingredientsToggleButton.topAnchor.constraint(equalTo: areaLabelContainer.bottomAnchor, constant: 16).isActive = true
        ingredientsToggleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

        contentView.addSubview(ingredientsListStackView)
        ingredientsListStackView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsListStackView.topAnchor.constraint(equalTo: ingredientsToggleButton.bottomAnchor, constant: 8).isActive = true
        ingredientsListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        ingredientsListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        if let ingredients = item?.strIngredients {
            for (index, ingredient) in ingredients.enumerated() {
                let checkboxButton = createCheckboxButton(title: ingredient, tag: index)
                ingredientsListStackView.addArrangedSubview(checkboxButton)
            }
        }
        
        contentView.addSubview(instructionsToggleButton)
        instructionsToggleButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsToggleButton.topAnchor.constraint(equalTo: ingredientsListStackView.bottomAnchor, constant: 8).isActive = true
        instructionsToggleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

        contentView.addSubview(instructionContent)
        instructionContent.translatesAutoresizingMaskIntoConstraints = false
        instructionContent.topAnchor.constraint(equalTo: instructionsToggleButton.bottomAnchor, constant: 8).isActive = true
        instructionContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        instructionContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(ytToggleButton)
        ytToggleButton.translatesAutoresizingMaskIntoConstraints = false
        ytToggleButton.topAnchor.constraint(equalTo: instructionContent.bottomAnchor, constant: 8).isActive = true
        ytToggleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
      
        webView.topAnchor.constraint(equalTo: ytToggleButton.bottomAnchor, constant: 16).isActive = true
        webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
}
