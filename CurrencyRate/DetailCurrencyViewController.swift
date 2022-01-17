//
//  DetailCurrencyViewController.swift
//  CurrencyRate
//
//  Created by Track Ensure on 2022-01-16.
//

import UIKit

class DetailCurrencyViewController: UIViewController {
  private var addToFavouritesBarButton: UIBarButtonItem?
  let sideInset: CGFloat = 10
  
  var currencyInfo: (currencyName: String, currencyRate: Double, isFavourite: Bool)
  init(currencyInfo: (currencyName: String, currencyRate: Double, isFavourite: Bool)) {
    self.currencyInfo = currencyInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.title = "Details"
    setupUI()
  }
  
  private func setupUI() {
    self.view.backgroundColor = .systemBackground
    self.addToFavouritesBarButton = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(changeFavouriteState))
    navigationItem.rightBarButtonItem = addToFavouritesBarButton
    self.updateAddToFavouriteIcon()
    
    let currencyNameLabel = UILabel()
    currencyNameLabel.text = "Currency - \(self.currencyInfo.currencyName)"
    
    let currencyRateLabel = UILabel()
    currencyRateLabel.text = "Currency rate: \(self.currencyInfo.currencyRate)"
    
    let verticalStack = UIStackView()
    verticalStack.axis = .vertical
    verticalStack.spacing = 10
    
    verticalStack.addArrangedSubview(currencyNameLabel)
    verticalStack.addArrangedSubview(currencyRateLabel)
    
    
    self.view.addSubview(verticalStack)
    
    let safeArea = self.view.safeAreaLayoutGuide
    verticalStack.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      verticalStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: self.sideInset),
      verticalStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: self.sideInset),
      verticalStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -self.sideInset),
      verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -self.sideInset)
    ])
  }
  
  private func updateAddToFavouriteIcon() {
    self.addToFavouritesBarButton?.image = currencyInfo.isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    self.addToFavouritesBarButton?.tintColor = currencyInfo.isFavourite ? .orange : .label
  }
  
  @objc private func changeFavouriteState() {
    //change state
    self.currencyInfo.isFavourite.toggle()
    
    let update = (currencyName: currencyInfo.currencyName, isFavourite: currencyInfo.isFavourite)
    
    CurrencyDbManager.shared.updateDB(for: update) { isSuccess in
      let titleMsg: String
      let alertMsg: String
      if !isSuccess {
        titleMsg = "Error"
        alertMsg = "isFavourite don't change"
      } else {
        titleMsg = "Success"
        alertMsg = "isFavourite change"
      }
      
      let alert = UIAlertController(title: titleMsg, message: alertMsg, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default)
      alert.addAction(okAction)
      self.present(alert, animated: true, completion: nil)
    }
    self.updateAddToFavouriteIcon()
  }
}
