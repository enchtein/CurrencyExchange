//
//  DetailCurrencyViewController.swift
//  CurrencyRate
//
//  Created by Track Ensure on 2022-01-16.
//

import UIKit

class DetailCurrencyViewController: UIViewController {
//  lazy var safeArea = self.view.safeAreaLayoutGuide
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
    let barButtonImage = currencyInfo.isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    let barButton = UIBarButtonItem(image: barButtonImage, style: .done, target: self, action: #selector(changeFavouriteState))
    navigationItem.rightBarButtonItem = barButton
    
    
    let currencyNameLabel = UILabel()
    currencyNameLabel.text = "Currency - \(self.currencyInfo.currencyName)"
    
    let currencyRateLabel = UILabel()
    currencyRateLabel.text = "Currency rate: \(self.currencyInfo.currencyRate)"
    
//    self.view.addSubview(currencyNameLabel)
//    self.view.addSubview(currencyRateLabel)
    
//    [currencyNameLabel, currencyRateLabel].forEach {
//      $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    currencyNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: self.sideInset).isActive = true
//    currencyNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: self.sideInset).isActive = true
//    currencyNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -self.sideInset).isActive = true
//
//
//    currencyRateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: self.sideInset).isActive = true
//    currencyRateLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor, constant: self.sideInset).isActive = true
//    currencyRateLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -self.sideInset).isActive = true
    
    
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
//    verticalStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -self.sideInset)
    verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -self.sideInset)
    ])
  }
    
  @objc private func changeFavouriteState() {
    //change state
//    var update = currencyInfo
//    update.isFavourite.toggle()
    self.currencyInfo.isFavourite.toggle()
    
    let update = (currencyName: currencyInfo.currencyName, isFavourite: currencyInfo.isFavourite)
    
    CurrencyDbManager.shared.updateDB(for: update) { isSuccess in
      if !isSuccess {
        let alert = UIAlertController(title: "Error", message: "isFavourite don't change", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
      } else {
        let alert = UIAlertController(title: "Success", message: "isFavourite change", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
      }
    }
//    if let parentVC = self.navigationController?.presentationController as? ViewController {
//      parentVC.
//    }
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
