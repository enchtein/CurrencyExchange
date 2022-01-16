//
//  URLSessionAdapter.swift
//  CurrencyRate
//
//  Created by Дмитрий Хероим on 11.01.2022.
//

import Foundation

class URLSessionAdapter {
  
  static let provider = URLSessionAdapter()
  
  private init() {}
  
  func getCurrencyRate(completion: @escaping (_ result: CurrencyExchange?) -> Void) {
    DispatchQueue.main.async {
      let baseUrl = "https://v6.exchangerate-api.com/v6/89973d0c9255096f930d81ec/latest/EUR"
//      let additionalURL = NasaTarget.getAllRovers.headers.joinedParamsDict()
      
      
      
      guard let url = URL(string: baseUrl) else { return }
      let session = URLSession.shared
      let request = URLRequest.init(url: url)
      
      let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
          print("");
          completion(nil)
          return }
        
        guard let data = data else {
          completion(nil)
          return
        }

        do {
          if let result = try? JSONDecoder().decode(CurrencyExchange.self, from: data) {
            completion(result)
          }
          
//          if let gitData = try? JSONDecoder().decode(AllRovers.self, from: data) {
//            completion(gitData)
//          }
        }
      }
      task.resume()
    }
    
    
    
    
  }
}
