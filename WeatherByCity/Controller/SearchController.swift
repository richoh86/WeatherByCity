//
//  SearchController.swift
//  WeatherByCity
//
//  Created by richard oh on 2019/07/31.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit
import MapKit

class SearchController: UIViewController {
    
    // 가장 최근에 검색한 도시 이름 UserDefault에 String으로 저장
    fileprivate let recentInputCityNameKey = "recentInputCityNameKey"
    
    // MARK: - UISearchController
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - MapView
    let mapView = MKMapView()
    
    // 위치 좌표 초기 값 => 시간이 되면 초기값을 사용자 위치로 변경해줄 것
    let initialLocation = CLLocation(latitude: 52.3740300, longitude: 4.8896900)
    let searchRadius: CLLocationDistance = 25000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setUpNavController()
        setUpMapView()
        
        // 가장 최근에 검색한 좌표의 위치가 남도록 구현할 것
        // 없으면 디폴트 값 적용
        if let recentInputCityName = UserDefaults.standard.string(forKey: recentInputCityNameKey) {
            searchOnValue(searchValue: recentInputCityName)
        } else {
            let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    // MARK: - Setup SearchController
    private func setUpNavController() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "세계 날씨"
        navigationItem.searchController = self.searchController
    
        definesPresentationContext = true
        // 검색어 입력할 때 화면이 희미해지는 효과 없애기
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup Mapview
    private func setUpMapView() {
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // 맵뷰를 탭하면 키보드가 내려가도록 구현
        let gestrueRecongnizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        mapView.addGestureRecognizer(gestrueRecongnizer)
    }
    
    // 맵뷰를 탭하면 키보드가 내려간다
    @objc func tapGestureAction(_ gesture: UIGestureRecognizer) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    // MARK: - MapKit Search By City Name
    private func searchOnValue(searchValue: String) {
        
        // request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchValue
        
        // search
        let search = MKLocalSearch(request: request)
        search.start { (res, err) in
            
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            // 검색 수량이 0보다 큰 경우 + 가장 첫번째 맵 아이템으로 위치 좌표 및 이름 확인
            if let count = res?.mapItems.count,
                count > 0,
                let mapItem = res?.mapItems[0] {
                
                // 검색된 위치의 이름
                let locationName = mapItem.name
                
                // 검색된 위치의 좌표
                let location = CLLocationCoordinate2D(latitude: mapItem.placemark.location!.coordinate.latitude, longitude: mapItem.placemark.location!.coordinate.longitude)
                
                // Annotation 생성: 위치의 좌표와 이름 주입
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = locationName
                
                // 기존에 삽입된 annotations를 모두 지운다
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                // MapView에 annotation 삽입
                self.mapView.addAnnotation(annotation)
                
                // MKCoordinateRegion 좌표 값 생성
                let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
                
                // UI 변경사항 적용
                DispatchQueue.main.async {
                    self.mapView.setRegion(coordinateRegion, animated: true)
                }
                
                // 가장 최근에 검색한 도시명을 UserDefault에 저장해두고
                // 앱 재시작시 해당 도시명으로 검색한 위치를 화면으로 보여준다
                UserDefaults.standard.set(searchValue, forKey: self.recentInputCityNameKey)
                
            } else {
                print("검색 결과가 없습니다..")
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchValue = searchBar.text else { return }
        searchOnValue(searchValue: searchValue)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

// MARK: - MKMapViewDelegate
extension SearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        guard let coordinate = view.annotation?.coordinate,
                let title = view.annotation?.title,
                    let cityName = title else { return }
        
        let latitude = Double(coordinate.latitude)
        let longitude = Double(coordinate.longitude)
        
        let weatherController = WeatherController(latitude: latitude, longitude: longitude, cityName: cityName)
        self.navigationController?.pushViewController(weatherController, animated: true)
    }

}
