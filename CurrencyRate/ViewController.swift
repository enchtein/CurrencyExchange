//
//  ViewController.swift
//  CurrencyRate
//
//  Created by Дмитрий Хероим on 11.01.2022.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var currencyCollectionView: UICollectionView!
  
  private let cellIdentifier = "CurrencyRateCollectionViewCell"
  
  private var currencyExchange: CurrencyExchange?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
//    self.currencyCollectionView.delegate = self
//    self.currencyCollectionView.dataSource = self
    
    self.currencyCollectionView.register(UINib(nibName: "CurrencyRateCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: self.cellIdentifier)
    
    URLSessionAdapter.provider.getCurrencyRate { result in
//      print(result)
      if let result = result {
        self.currencyExchange = result
        
        self.currencyCollectionView.reloadData()
      }
    }
  }
}

extension ViewController: UICollectionViewDelegate {
  
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.currencyExchange?.conversionRates.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CurrencyRateCollectionViewCell, let currencyExchange = self.currencyExchange {
      let currencyInfo = currencyExchange.conversionRates[indexPath.row]
      
      
      
      return cell
    }
    return UICollectionViewCell()
  }
}
