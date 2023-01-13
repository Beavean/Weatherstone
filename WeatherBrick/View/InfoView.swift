//
//  InfoView.swift
//  WeatherBrick
//
//  Created by Beavean on 27.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class InfoView: UIView {
    // MARK: - UI Elements
    
    lazy var hideButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hide", for: .normal)
        button.accessibilityIdentifier = "HideButton"
        button.tintColor = .darkGray
        button.layer.cornerRadius = Constants.UserInterface.baseCornerRadius
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = self.backgroundColor
        view.frame = self.frame
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabel = createLabel(withText: "INFO", isBold: true)
    
    // MARK: - Properties

    private let shadowsOffset: CGFloat = 6
    private let darkShadowOpacity: Float = 0.2
    private let darkShadowRadius: CGFloat = 3
    private let secondaryShadowColor = UIColor(red: 232 / 255, green: 106 / 255, blue: 60 / 255, alpha: 1).cgColor
    private let mainBackgroundColor = UIColor(red: 255 / 255, green: 153 / 255, blue: 96 / 255, alpha: 1)
    private let mainViewHeight: CGFloat = 350
    private let mainViewWidth: CGFloat = 250
    private let hideButtonWidth: CGFloat = 150
    private let baseInset: CGFloat = 24
    private let labelFontSize: CGFloat = 16.0
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadows()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMainView()
        configureHeaderLabel()
        configureHideButton()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureMainView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Constants.UserInterface.baseCornerRadius
        heightAnchor.constraint(equalToConstant: mainViewHeight).isActive = true
        widthAnchor.constraint(equalToConstant: mainViewWidth).isActive = true
        backgroundColor = mainBackgroundColor
        addSubview(subView)
        subView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func configureHeaderLabel() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: baseInset).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func configureHideButton() {
        addSubview(hideButton)
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        hideButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        hideButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -baseInset).isActive = true
        hideButton.widthAnchor.constraint(equalToConstant: hideButtonWidth).isActive = true
    }
    
    private func configureStackView() {
        let stack = UIStackView()
        WeatherCondition.allCases.forEach { stack.addArrangedSubview(createLabel(withText: $0.infoLabelText )) }
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: baseInset).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: baseInset).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: baseInset).isActive = true
        stack.bottomAnchor.constraint(equalTo: hideButton.topAnchor, constant: -baseInset).isActive = true
    }
    
    private func applyShadows() {
        let rightOffset = CALayer()
        rightOffset.frame = self.bounds
        rightOffset.shadowColor = secondaryShadowColor
        rightOffset.shadowRadius = 0
        rightOffset.shadowOpacity = 1
        rightOffset.shadowOffset = .init(width: shadowsOffset, height: 0)
        rightOffset.cornerRadius = Constants.UserInterface.baseCornerRadius
        rightOffset.backgroundColor = backgroundColor?.cgColor
        layer.insertSublayer(rightOffset, at: 0)
        layer.frame = self.bounds
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = darkShadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: shadowsOffset)
        layer.shadowRadius = darkShadowRadius
    }
    
    private func createLabel(withText text: String, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        let fontName = isBold ? Constants.UserInterface.mainSemiboldFontName : Constants.UserInterface.mainLightFontName
        label.text = text
        label.font = UIFont(name: fontName, size: labelFontSize)
        return label
    }
}
