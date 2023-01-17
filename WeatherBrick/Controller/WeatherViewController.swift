//
//  WeatherViewController.swift
//  WeatherBrick
//
//  Created by Beavean on 26.12.2022.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var weatherConditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherConditionLabel: UILabel!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var mainContainerView: UIView!
    @IBOutlet private weak var locationSearchTextField: UITextField!
    
    // MARK: - UI Elements
    
    private let infoView = InfoView()
    
    // MARK: - Properties

    private let infoButtonTopColor = UIColor(red: 254 / 255, green: 148 / 255, blue: 91 / 255, alpha: 1)
    private let infoButtonBottomColor = UIColor(red: 250 / 255, green: 94 / 255, blue: 40 / 255, alpha: 1)
    private let infoButtonShadowOpacity: Float = 0.2
    private let infoButtonShadowOffset = CGSize(width: 3, height: 3)
    private let infoButtonShadowRadius: CGFloat = 3
    private var weatherManager = WeatherManager()
    private let locationManager = LocationManager()
    var selectedCity: String? {
        didSet {
            saveSelectedCity()
        }
    }
    private enum StatusText: String {
        case updating = "Updating..."
        case noLocation = "No Location Data ⚠️"
        case noWeather = "No Weather Data ⚠️"
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureNotificationObservers()
        configurePanGesture()
        configureInfoButton()
    }
    
    // MARK: - Actions
    
    @IBAction private func locationButtonPressed() {
        prepareForUpdate()
        locationManager.requestLocation()
    }
    
    @IBAction private func infoButtonPressed() {
        mainContainerView.fadeOut()
        mainContainerView.isUserInteractionEnabled = false
        infoView.hideButton.addTarget(self, action: #selector(handleHideInfoView), for: .touchUpInside)
        infoView.alpha = 0
        view.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.fadeIn()
    }
    
    @IBAction private func searchButtonPressed() {
        locationSearchTextField.isHidden.toggle()
        locationSearchTextField.isEnabled.toggle()
        if !locationSearchTextField.isHidden && locationSearchTextField.isEnabled {
            locationSearchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleHideInfoView() {
        infoView.fadeOut()
        mainContainerView.fadeIn()
        mainContainerView.isUserInteractionEnabled = true
    }
    
    @objc private func textFieldDidChange() {
        guard let searchInput = locationSearchTextField.text, !searchInput.isEmpty else { return }
        activityIndicator.startAnimating()
        weatherManager.fetchWeatherUsingSearch(searchQuery: searchInput)
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        guard let elementToCover = infoButton,
        let userInfo = sender.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let lowestFrame = elementToCover.superview?.convert(elementToCover.frame, to: nil)
        else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let frameOriginY = self.view.frame.origin.y - keyboardHeight + (view.frame.height - lowestFrame.minY)
        self.view.frame.origin.y = frameOriginY
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            weatherConditionImageView.layer.removeAllAnimations()
            weatherConditionImageView.layoutIfNeeded()
            weatherConditionImageView.resetStonePosition()
            self.prepareForUpdate()
        case .changed:
            let translation = sender.translation(in: nil)
            let translationY = translation.y / 10
            weatherConditionImageView.transform = CGAffineTransform(translationX: 0, y: translationY)
        default:
            weatherConditionImageView.resetStonePosition()
            self.getWeather()
        }
    }
    
    // MARK: - Configuration
    
    private func configure() {
        prepareForUpdate()
        locationSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        weatherManager.delegate = self
        locationManager.delegate = self
        getWeather()
    }
    
    private func configureNotificationObservers() {
        let showNotification = UIResponder.keyboardWillShowNotification
        let hideNotification = UIResponder.keyboardWillHideNotification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: showNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: hideNotification, object: nil)
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    private func configureInfoButton() {
        infoButton.clipsToBounds = false
        infoButton.layer.shadowColor = UIColor.black.cgColor
        infoButton.layer.shadowOpacity = infoButtonShadowOpacity
        infoButton.layer.shadowOffset = infoButtonShadowOffset
        infoButton.layer.shadowRadius = infoButtonShadowRadius
        infoButton.layer.cornerRadius = Constants.UserInterface.baseCornerRadius
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [infoButtonTopColor.cgColor, infoButtonBottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = infoButton.bounds
        gradientLayer.cornerRadius = Constants.UserInterface.baseCornerRadius
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        infoButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Helpers
    
    private func prepareForUpdate() {
        activityIndicator.startAnimating()
        temperatureLabel.fadeOut()
        weatherConditionLabel.fadeOut()
        locationLabel.text = StatusText.updating.rawValue
    }

    private func getWeather() {
        getSelectedCity()
        if let selectedCity, !selectedCity.isEmpty {
            weatherManager.fetchWeatherUsingSearch(searchQuery: selectedCity)
        } else {
            locationManager.requestPermission()
            locationManager.requestLocation()
        }
    }
    
    private func showError(withText text: String) {
        temperatureLabel.fadeOut()
        weatherConditionLabel.fadeOut()
        weatherConditionImageView.fadeOut()
        locationLabel.text = text
        activityIndicator.stopAnimating()
    }
    
    private func updateInterface(withCondition condition: WeatherCondition) {
        weatherConditionImageView.alpha = condition == .fog ? 0.4 : 1
        weatherConditionLabel.text = condition.weatherConditionLabelText
        weatherConditionImageView.image = UIImage(named: condition.imageName)
    }
    
    func saveSelectedCity() {
        let defaults = UserDefaults.standard
        defaults.set(selectedCity, forKey: Constants.UserDefaults.selectedCityKey)
    }
    
    func getSelectedCity() {
        let defaults = UserDefaults.standard
        guard let savedCity = defaults.object(forKey: Constants.UserDefaults.selectedCityKey) as? String else { return }
        selectedCity = savedCity
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isHidden = true
        textField.isEnabled = false
        return true
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: LocationManagerDelegate {
    func failedToUpdateLocation() {
        showError(withText: StatusText.noLocation.rawValue)
    }

    func didUpdateLocationWith(coordinates: CLLocationCoordinate2D) {
        weatherManager.fetchWeatherUsingLocation(coordinates: coordinates)
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdate(weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            temperatureLabel.text = weather.temperatureString
            locationLabel.text = weather.locationName
            weatherConditionImageView.fadeIn()
            temperatureLabel.fadeIn()
            weatherConditionLabel.fadeIn()
            activityIndicator.stopAnimating()
            updateInterface(withCondition: weather.condition)
            selectedCity = weather.cityName
        }
    }
    
    func failedToUpdateWeather() {
        DispatchQueue.main.async {
            self.showError(withText: StatusText.noWeather.rawValue)
        }
    }
}
