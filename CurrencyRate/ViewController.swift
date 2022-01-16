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
  private var currencyExchangeData = [(currencyName: String, currencyRate: Double, isFavourite: Bool)]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    self.currencyCollectionView.delegate = self
    self.currencyCollectionView.dataSource = self
    
    self.currencyCollectionView.register(UINib(nibName: "CurrencyRateCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: self.cellIdentifier)
    
    URLSessionAdapter.provider.getCurrencyRate { result in
      if let result = result {
        self.currencyExchange = result
        DispatchQueue.main.async {
          self.selectedCurrency.text = "Currency "+result.baseCode
          
          if let storedData = CurrencyDbManager.shared.fetchDataFromDB() {
            if storedData.isEmpty {
              // need to save
              var currencyArrayToDb = [(currencyName: String, isFavourite: Bool)]()
              for (currencyName, currencyNameRate) in result.conversionRates {
                currencyArrayToDb.append((currencyName: currencyName, isFavourite: false))
                self.currencyExchangeData.append((currencyName: currencyName, currencyRate: currencyNameRate, isFavourite: false))
              }
              CurrencyDbManager.shared.save(currencyArray: currencyArrayToDb)
            } else {
              let favouritesItems = storedData.filter({$0.isFavourite})
              //get is favourite
              var prepairCurrencyArray = [(currencyName: String, currencyRate: Double, isFavourite: Bool)]()
              for item in result.conversionRates {
                prepairCurrencyArray.append((currencyName: item.key, currencyRate: item.value,  isFavourite: false))
              }
              
              for favouritesItem in favouritesItems {
                if let index = prepairCurrencyArray.firstIndex(where: {$0.currencyName == favouritesItem.currencyName}) {
                  prepairCurrencyArray[index].isFavourite = favouritesItem.isFavourite
                }
              }
              self.currencyExchangeData = prepairCurrencyArray.sorted(by: {$0.isFavourite && !$1.isFavourite})
            }
          }
          
          self.currencyCollectionView.reloadData()
        }
        
      }
    }
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let currencyExchangeInfo = self.currencyExchangeData[indexPath.row]
    
    let vc = DetailCurrencyViewController(currencyInfo: currencyExchangeInfo)
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
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
