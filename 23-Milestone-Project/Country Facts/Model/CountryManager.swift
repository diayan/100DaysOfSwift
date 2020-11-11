//
//  CountryManager.swift
//  Country Facts
//
//  Created by diayan siat on 26/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import Foundation


protocol CountryManagerDelegate {
    func didUpdateCountry(_ countryManager: CountryManager, country: [Country])
    func didFailWithError(_ error: Error)
}

struct CountryManager {
    
    let countryDataUrl = "https://restcountries.eu/rest/v2/all"
    var delegate: CountryManagerDelegate?
    
    //perform network request using urlsession
    func performNetworkRequest() {
        //create url
        if let url = URL(string: countryDataUrl) {
            //create url session
            let session = URLSession(configuration: .default)
            //create a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let country = self.parseJson(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateCountry(self, country: country)
                        }
                    }
                }
            }
            //start task
            task.resume()
        }
    }
    
    func parseJson(_ countryData: Data) -> [Country]?{
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Country].self, from: countryData)
//            let area = decodedData[0].area!
//            let name = decodedData[0].name
//            let capital = decodedData[0].capital
//            let region = decodedData[0].region
//            let currency = decodedData[0].currencies[0].name!
//            let border = decodedData[0].borders[0]
//            let language = decodedData[0].languages[0].name
//            let flag = decodedData[0].flag
//            let population = decodedData[0].population
            
//            let country = CountriesModel(name: name, region: region, capital: capital, border: border, flag: flag, area: area, population: population, currency: currency, language: language)
            return decodedData
            
        }catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
