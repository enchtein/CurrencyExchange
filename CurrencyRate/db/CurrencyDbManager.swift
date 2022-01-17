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
  private var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  private var managedContext: NSManagedObjectContext {
    return self.appDelegate.persistentContainer.viewContext
  }
  
  private init() {}
  
  func save(currencyArray: [(currencyName: String, isFavourite: Bool)]) {
    guard !currencyArray.isEmpty else { return } // dont write if empty
    
    for currency in currencyArray {
      let currencyName = currency.currencyName
      let isFavourite = currency.isFavourite
      
      let entity = NSEntityDescription.entity(forEntityName: "Currency", in: self.managedContext)!
      let currency = NSManagedObject(entity: entity, insertInto: self.managedContext)
      currency.setValue(currencyName, forKeyPath: "name")
      currency.setValue(isFavourite, forKey: "isFavourite") // default
      do {
        try self.managedContext.save()
        // changes!
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
  }
  
  func fetchDataFromDB() -> [(currencyName: String, isFavourite: Bool)]? {
    var db_data = [(currencyName: String, isFavourite: Bool)]()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
    request.returnsObjectsAsFaults = false
    do {
      let result = try self.managedContext.fetch(request)
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
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
    request.returnsObjectsAsFaults = false
    
    do {
      let results = try self.managedContext.fetch(request)
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
        try self.managedContext.save()
        
        completion(true)
      }catch let error as NSError {
        print("Could not update. \(error), \(error.userInfo)")
        completion(false)
      }
      
    }
    catch let error as NSError {
      print("Could not update. \(error), \(error.userInfo)")
      completion(false)
    }
    
  }
}
