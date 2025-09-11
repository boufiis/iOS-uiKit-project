//
//  LocationManager.swift
//  WhetherApp
//
//  Created by MAC on 10/9/2025.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    func appearError(_ error: Error)
    func getCityName(_ cityName: String)
}



final class LocationManager: NSObject {
    let manager = CLLocationManager()
    weak var delgate: LocationManagerProtocol?
    let geoCoder = CLGeocoder()
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAutorisation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    private func reverseGeoLocation(_ location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self  else { return }
            if let error = error {
                showError(error)
                return
            }
            let cityName = placemarks?.first?.locality ?? ""
            delgate?.getCityName(cityName)
        }
    }

}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        reverseGeoLocation(location)
        manager.stopUpdatingLocation()
    }
    
    func showError(_ error: Error) {
        delgate?.appearError(error)
    }
}
