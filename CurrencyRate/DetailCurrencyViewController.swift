//
//  DetailCurrencyViewController.swift
//  CurrencyRate
//
//  Created by Track Ensure on 2022-01-16.
//

import UIKit

class DetailCurrencyViewController: UIViewController {
  
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
    
    self.view.addSubview(currencyNameLabel)
    self.view.addSubview(currencyRateLabel)
    
    [currencyNameLabel, currencyRateLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
    
    currencyNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10 + navigationBarHeight).isActive = true
    currencyNameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10 + navigationBarHeight).isActive = true
    currencyNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(10 + navigationBarHeight)).isActive = true
    
    
    currencyRateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10 + navigationBarHeight).isActive = true
    currencyRateLabel.topAnchor.constraint(equalTo: currencyNameLabel.topAnchor, constant: 10 + navigationBarHeight).isActive = true
    currencyRateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(10 + navigationBarHeight)).isActive = true
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
