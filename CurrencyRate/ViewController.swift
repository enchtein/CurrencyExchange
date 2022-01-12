//
//  ViewController.swift
//  CurrencyRate
//
//  Created by Дмитрий Хероим on 11.01.2022.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var selectedCurrency: UILabel!
  @IBOutlet weak var currencyCollectionView: UICollectionView!
  
  
  private let cellIdentifier = "CurrencyRateCollectionViewCell"
  
  private var currencyExchange: CurrencyExchange?
  private var currencyExchangeData = [(currencyName: String, currencyRate: Double)]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    self.currencyCollectionView.delegate = self
    self.currencyCollectionView.dataSource = self
    
    self.currencyCollectionView.register(UINib(nibName: "CurrencyRateCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: self.cellIdentifier)
    
    URLSessionAdapter.provider.getCurrencyRate { result in
      //      print(result)
      if let result = result {
        self.currencyExchange = result
        
        for item in result.conversionRates {
          self.currencyExchangeData.append((currencyName: item.key, currencyRate: item.value))
        }
        
        DispatchQueue.main.async {
          self.selectedCurrency.text = "Currency "+result.baseCode
          self.currencyCollectionView.reloadData()
        }
        
      }
    }
  }
}

extension ViewController: UICollectionViewDelegate {
  
}

extension ViewController: UICollectionViewDataSource {
  func numberOfItems(inSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.currencyExchangeData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CurrencyRateCollectionViewCell {
      let currencyInfo = self.currencyExchangeData[indexPath.row]
      cell.setupCell(with: currencyInfo)
      
      
      return cell
    }
    return UICollectionViewCell()
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      let layoutWidth = layout.sectionInset.left + collectionView.contentInset.left + layout.sectionInset.right + collectionView.contentInset.right
      let cellWidth = ((collectionView.frame.size.width - layout.minimumInteritemSpacing) / 2) - layoutWidth
      let width = cellWidth
      
      return CGSize(width: width, height: width)
    }
    
    return CGSize(width: 50, height: 50)
  }
}
