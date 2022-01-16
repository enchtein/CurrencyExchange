//
//  CurrencyRateCollectionViewCell.swift
//  CurrencyRate
//
//  Created by Дмитрий Хероим on 11.01.2022.
//

import UIKit

class CurrencyRateCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var currencyNameLabel: UILabel!
  @IBOutlet weak var currencyRateLabel: UILabel!
  
  @IBOutlet weak var favouriteImageView: UIImageView!
  
  var indexPath: IndexPath?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.indexPath = nil
    self.currencyNameLabel.text = nil
    self.currencyRateLabel.text = nil
//    addToFavouriteButton -- image nil!
    
  }
  
  func setupCell(with currencyInfo: (currencyName: String, currencyRate: Double, isFavourite: Bool)) {
    self.contentView.backgroundColor = .red
    self.currencyNameLabel.text = currencyInfo.currencyName
    self.currencyRateLabel.text = String(currencyInfo.currencyRate)
    
    // only if favourite
    if currencyInfo.isFavourite {
      self.favouriteImageView.image = UIImage(systemName: "star.fill")
      self.favouriteImageView.tintColor = .orange
    } else {
      self.favouriteImageView.image = UIImage(systemName: "star")
      self.favouriteImageView.tintColor = .white
    }
    
  }
}
