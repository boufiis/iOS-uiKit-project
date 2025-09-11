//
//  WheatherPresenter.swift
//  WhetherApp
//
//  Created by MAC on 11/9/2025.
//

import UIKit
import Foundation

protocol WheatherPresenterProtocol {
    func updateCityName(_ cityName: String)
    func updateWhetherDegree(_ degree: Double)
    func showLoading(_ show: Bool)
}

final class WheatherPresenter: NSObject {
    var delgate: WheatherPresenterProtocol?
    let locationManager = LocationManager()
    
    override init() {
        super.init()
        locationManager.delgate = self
        startUpdating()
        
    }
    
    func startUpdating() {
        locationManager.requestAutorisation()
        locationManager.updateLocation()
    }
    
    func fetchWhetherDegree(_ cityName: String) {
        let apiKey = "7d743f9ca2a430f994cefeb1c01996b0"
        let stringUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {[weak self] data,_,error in
            guard let self,let data else { return }
            do {
                let decodedData = try JSONDecoder().decode(OpenWeatherResponseDTO.self, from: data)
                delgate?.updateWhetherDegree(decodedData.main.temp)
                self.delgate?.showLoading(false)
    
            }
            catch {
                self.delgate?.showLoading(false)
                print("errro")
            }
        }
        .resume()
    }
}

extension WheatherPresenter: LocationManagerProtocol {
    func appearError(_ error: any Error) {
        
    }
    func getCityName(_ cityName: String) {
        delgate?.updateCityName(cityName)
        fetchWhetherDegree(cityName)
    }
}
