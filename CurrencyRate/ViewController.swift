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
  @IBOutlet weak var selectCurrencyTextField: UITextField!
  
  private var changeCurrencyPicker: UIPickerView?
  private lazy var pickerDataSource: [String] = self.currencyExchangeData.map({$0.currencyName}).sorted(by: {$0 < $1})
  
  private let cellIdentifier = "CurrencyRateCollectionViewCell"
  
  private var currencyExchange: CurrencyExchange?
  private var currencyExchangeData = [(currencyName: String, currencyRate: Double, isFavourite: Bool)]()
  
  private var isGrowingUP = false {
    willSet {
      if newValue != isGrowingUP {
        self.sortExchangeData(isGrowingUP: newValue)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    self.currencyCollectionView.delegate = self
    self.currencyCollectionView.dataSource = self
    
    self.currencyCollectionView.register(UINib(nibName: "CurrencyRateCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: self.cellIdentifier)
    
    self.setupToolbar()
    
    changeCurrencyPicker = UIPickerView()
    changeCurrencyPicker?.dataSource = self
    changeCurrencyPicker?.delegate = self
    
    self.selectCurrencyTextField.inputView = changeCurrencyPicker
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexRow = self.changeCurrencyPicker?.selectedRow(inComponent: 0) {
      let text = self.pickerDataSource[indexRow]
      self.fetchNetworkRequest(with: text)
    } else {
      self.fetchNetworkRequest()
    }
  }
  
  @IBAction func reSortData(_ sender: UIButton) {
    self.isGrowingUP.toggle()
  }
  
  @IBAction func selectCurrency(_ sender: UIControl) {
    self.selectCurrencyTextField.becomeFirstResponder()
  }
  
  private func setupToolbar() {
    //    self.changeCurrencyPicker/
    
    
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(updateCurrencyList))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
    
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    self.selectCurrencyTextField.inputAccessoryView = toolBar
    
  }
  @objc private func updateCurrencyList() {
    if let indexRow = self.changeCurrencyPicker?.selectedRow(inComponent: 0) {
      let text = self.pickerDataSource[indexRow]
      self.fetchNetworkRequest(with: text)
    }
    
    self.selectCurrencyTextField.resignFirstResponder()
  }
  
  @objc private func cancelPicker() {
    self.selectCurrencyTextField.resignFirstResponder()
  }
  
  private func fetchNetworkRequest(with currencyName: String = "EUR") {
    URLSessionAdapter.provider.getCurrencyRate(with: currencyName) { result in
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
              self.currencyExchangeData = prepairCurrencyArray
            }
          }
          self.sortExchangeData(isGrowingUP: self.isGrowingUP)
        }
        
      }
    }
  }
  
  private func sortExchangeData(isGrowingUP: Bool) {
    self.currencyExchangeData.sort { lhs, rhs in
      if lhs.isFavourite && rhs.isFavourite {
        return isGrowingUP ? lhs.currencyRate < rhs.currencyRate : lhs.currencyRate > rhs.currencyRate
      } else if !lhs.isFavourite && !rhs.isFavourite {
        return isGrowingUP ? lhs.currencyRate < rhs.currencyRate : lhs.currencyRate > rhs.currencyRate
      }
      return lhs.isFavourite && !rhs.isFavourite
    }
    
    self.currencyCollectionView.reloadData()
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

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerDataSource.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerDataSource[row]
  }
}
