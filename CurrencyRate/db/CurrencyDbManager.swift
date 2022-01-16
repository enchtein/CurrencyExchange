//
//  CurrencyDbManager.swift
//  CurrencyRate
//
//  Created by Track Ensure on 2022-01-16.
//

import UIKit
import CoreData

class CurrencyDbManager {
  static let shared = CurrencyDbManager()
  
  private init() {}
  
  func save(currencyArray: [(currencyName: String, isFavourite: Bool)]) {
    
    guard !currencyArray.isEmpty else { return } // dont write if empty
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

    for currency in currencyArray {
      let currencyName = currency.currencyName
      let isFavourite = currency.isFavourite
      
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Currency", in: managedContext)!
      let currency = NSManagedObject(entity: entity, insertInto: managedContext)
      currency.setValue(currencyName, forKeyPath: "name")
      currency.setValue(isFavourite, forKey: "isFavourite") // default
      do {
        try managedContext.save()
        // changes!
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
//    let updateCurrency = (currencyName: "AUD", isFavourite: true)
//    self.updateDB(for: updateCurrency) { isSuccess in
//      if isSuccess {
//        if let test = self.fetchDataFromDB() {
//          print("update collection with this array")
//          if let index = self.currencyExchangeData.firstIndex(where: {$0.currencyName == updateCurrency.currencyName}) {
//            self.currencyExchangeData[index].isFavourite = updateCurrency.isFavourite
//
//            self.currencyExchangeData.sort(by: {$0.currencyName < $1.currencyName})
////            updateData.isFavourite = updateCurrency.isFavourite
//          }
//          self.currencyCollectionView.reloadData()
////          self.currencyExchangeData.ma
//        }
//      }
//    }
  }
  
  func fetchDataFromDB() -> [(currencyName: String, isFavourite: Bool)]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
    let context = appDelegate.persistentContainer.viewContext
    
    var db_data = [(currencyName: String, isFavourite: Bool)]()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        print(data.value(forKey: "name") as! String)
        print(data.value(forKey: "isFavourite") as! Bool)
        
        if let currencyName = data.value(forKey: "name") as? String,
           let isFavourite = data.value(forKey: "isFavourite") as? Bool {
          db_data.append((currencyName: currencyName, isFavourite: isFavourite))
        }
        
      }
      return db_data
    } catch {
      
      print("Failed")
      return nil
    }
  }
  func updateDB(for currency: (currencyName: String, isFavourite: Bool), completion: @escaping (Bool) -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
    request.returnsObjectsAsFaults = false
    
    do {
      let results = try context.fetch(request)
      let sssome = results as! [NSManagedObject]
      
      let objIndex = sssome.firstIndex { nsObject in
        if let name = nsObject.value(forKey: "name") as? String {
          return name == currency.currencyName
        }
        return false
      }
      guard let index = objIndex else {return}
      
      let objectUpdate = results[index] as! NSManagedObject
      objectUpdate.setValue(currency.currencyName, forKey: "name")
      objectUpdate.setValue(currency.isFavourite, forKey: "isFavourite")
      do {
        try context.save()
        
        completion(true)
      }catch let error as NSError {
        //          labelStatus.text = error.localizedFailureReason
        print("Could not update. \(error), \(error.userInfo)")
        completion(false)
      }
      
    }
    catch let error as NSError {
      //      labelStatus.text = error.localizedFailureReason
      print("Could not update. \(error), \(error.userInfo)")
      completion(false)
    }
    
  }
}
