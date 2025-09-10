//
//  ViewController.swift
//  WhetherApp
//
//  Created by MAC on 9/7/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var wheatherDegree: UILabel!
    @IBOutlet weak var whetherImage: UIImageView!
    private var presenter = WheatherPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delgate = self
    }
}


extension ViewController: WheatherPresenterProtocol {
    func updateWhetherDegree(_ degree: Double) {
        DispatchQueue.main.async {
            self.wheatherDegree.text = "\(degree)"
        }
    }
    
    func updateCityName(_ cityName: String) {
        DispatchQueue.main.async {
            self.cityName.text = cityName
        }
    }
}


extension ViewController: LocationManagerProtocol {
    func getCityName(_ cityName: String) {
        self.cityName.text = "\(cityName)"
        
    }
    
    func updateLocation(_ longitude: Double, _ latitude: Double) {
        DispatchQueue.main.async {
        }
    }
    
    func appearError(_ error: any Error) {
        
    }
}
protocol WheatherPresenterProtocol {
    func updateCityName(_ cityName: String)
    func updateWhetherDegree(_ degree: Double)
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
        let stringUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {[weak self] data,_,error in
            guard let self,let data else { return }
            do {
                let decodedData = try JSONDecoder().decode(OpenWeatherGroupResponse.self, from: data)
                delgate?.updateWhetherDegree(decodedData.list.first?.main.temp ?? 0)
            }
            catch {
                
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


struct OpenWeatherGroupResponse: Decodable {
    let list: [CityWeather]
    
    struct CityWeather: Decodable {
        let name: String
        let main: Main
        let weather: [Weather]
        
        struct Main: Decodable {
            let temp: Double
        }
        
        struct Weather: Decodable {
            let main: String
            let icon: String
            
            var iconResource: ImageResource {
                switch main.lowercased() {
                case "clear": return .icSunnyWhether
                case "clouds": return .icFoggyWhether
                case "rain": return .icFoggyWhether
                case "fog": return .icFoggyWhether
                default: return .icSunnyWhether
                }
            }
        }
    }
}
