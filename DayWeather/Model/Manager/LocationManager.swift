//
//  LocationManager.swift
//  DayWeather
//
//  Created by Jack Lee on 2023/09/30.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?) -> Void
    
    private var fetchLocationCompletion: FetchLocationCompletion?
    
    override init() {
        super.init()
        
        self.delegate = self
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func startUpdatingLocation() {
        super.startUpdatingLocation()
    }
    
    override func stopUpdatingLocation() {
        super.stopUpdatingLocation()
    }
    
    override func requestLocation() {
        super.requestLocation()
    }
    
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
        self.requestLocation()
        self.fetchLocationCompletion = completion
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        
        self.fetchLocationCompletion?(coordinate, nil)
        self.fetchLocationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치를 가져오지 못했습니다. \(error.localizedDescription)")
        
        self.fetchLocationCompletion?(nil, error)
        self.fetchLocationCompletion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Auth: Allow")
            self.startUpdatingLocation()
            
        case .notDetermined, .denied, .restricted:
            print("Location Auth: Denied")
            self.stopUpdatingLocation()
        default: break
        }
    }
}
