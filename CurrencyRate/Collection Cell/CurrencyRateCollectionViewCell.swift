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
  
  @IBOutlet weak var addToFavouriteButton: UIButton!
  
  var indexPath: IndexPath?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.indexPath = nil
    self.currencyNameLabel.text = nil
    self.currencyRateLabel.text = nil
//    addToFavouriteButton -- image nil!
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  func setupCell(with currencyInfo: (currencyName: String, currencyRate: Double)) {
    self.contentView.backgroundColor = .red
    self.currencyNameLabel.text = currencyInfo.currencyName
    self.currencyRateLabel.text = String(currencyInfo.currencyRate)
  }
}
