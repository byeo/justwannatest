//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdate(_ coindata: CoinData)
    func didFail(_ error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=AD15F81B-73CD-4131-9231-E4BFFD0756D2"
    
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        print("lala")
        performRequest(baseURL+"/"+currency+apiKey)
    }
    
    func performRequest(_ currency: String){
         let url = URL(string: currency)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let d = data else {return}
            
            let json = JSONDecoder()
            do{
            let codedData = try json.decode(CoinData.self, from: d)
                let time = codedData.time
                let assbase = codedData.asset_id_base
                let assquote = codedData.asset_id_quote
                let rate = codedData.rate
                
                let coinData = CoinData(time: time, asset_id_base: assbase, asset_id_quote: assquote, rate: rate)
                
                self.delegate?.didUpdate(coinData)
            }catch{
                self.delegate?.didFail(error)
            }
        }.resume()
    }
}
