//
//  WeatherController.swift
//  WeatherByCity
//
//  Created by richard oh on 2019/08/01.
//  Copyright © 2019 richard oh. All rights reserved.
//

import UIKit

class WeatherController: UIViewController {
    
    // MARK: - Weather data from openWeather API
    var city: City? {
        didSet {
            DispatchQueue.main.async {
                if let iconStr = self.city?.weather[0].icon {
                    self.weatherImageView.image = UIImage(named: iconStr)
                }
                if let temp = self.city?.main.temp {
                        // 소수점 제외
                        let tempInt = Int(temp)
                        self.temperatureLabel.text = "\(tempInt)º"
                }
                self.mainWeatherState.text = self.city?.weather[0].main
                self.detailWeatherDescription.text = self.city?.weather[0].description
                self.tableViewForWeatherDetails.reloadData()
            }
        }
    }
    
    // MARK: - OpenWeather API parameters
    var latitude: Double?
    var longitude: Double?
    
    // MARK: - Selected city name
    var cityName: String?
    
    // MARK: - Views
    
    // 데이터를 호출하는 동안 보여주는 뷰
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    // 날씨 상태 이미지
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return imageView
    }()
    
    // 온도
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .black
        return label
    }()
    
    // 메인 날씨 상태
    let mainWeatherState: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    // 날씨 상태 자세히
    let detailWeatherDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    let tableViewForWeatherDetails: UITableView = {
        let tableView = UITableView()
        tableView.register(WeatherDetailCell.self, forCellReuseIdentifier: WeatherDetailCell.cellId)
        return tableView
    }()
    
    // MARK: - Initializer
    init(latitude: Double, longitude: Double, cityName: String) {
        super.init(nibName: nil, bundle: nil)
        self.latitude = latitude
        self.longitude = longitude
        self.cityName = cityName
        
        navigationItem.title = cityName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setStackViewForWeatherState()
        setActivityView()
        setTableView()
        
        fetchData()
    }
    
    // MARK: - Set StackView
    fileprivate func setStackViewForWeatherState() {
        
        let stackViewForTop = UIStackView(arrangedSubviews: [
            weatherImageView,
            temperatureLabel,
            mainWeatherState,
            detailWeatherDescription,
            ])
        
        stackViewForTop.axis = .vertical
        stackViewForTop.alignment = .center
        view.addSubview(stackViewForTop)
        
        stackViewForTop.translatesAutoresizingMaskIntoConstraints = false
        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else { return }
        stackViewForTop.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight).isActive = true
        stackViewForTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackViewForTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackViewForTop.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - Set ActivityIndicatorView
    fileprivate func setActivityView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - Set TableView
    fileprivate func setTableView() {
        
        view.addSubview(tableViewForWeatherDetails)
        tableViewForWeatherDetails.translatesAutoresizingMaskIntoConstraints = false
        tableViewForWeatherDetails.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        tableViewForWeatherDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewForWeatherDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewForWeatherDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableViewForWeatherDetails.dataSource = self
        tableViewForWeatherDetails.delegate = self
        
        tableViewForWeatherDetails.allowsSelection = false
        
    }
    
    // MARK: - Fetch Weather Data
    private func fetchData() {
        guard let latitude = latitude,
            let longitude = longitude else { return }
        
        OpenWeatherAPI.shared.fetchWeatherDataByCoordinate(latitude: latitude, longitude: longitude) { (city, err) in
            if let err = err {
                print("Failed to decode..")
                print(err.localizedDescription)
                return
            }
            self.city = city
            
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
            }
        }
    }
}

// MARK: - UITableView DataSoucre
extension WeatherController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WeatherDetailCell.cellId, for: indexPath) as! WeatherDetailCell
        let indexPath = indexPath.row
        switch indexPath {
        case 0:
            cell.leftLabel.text = "최저온도"
            cell.rightLabel.text = "최고온도"
            if let minTemperature = self.city?.main.tempMin,
                let maxTemperature = self.city?.main.tempMax {
                cell.leftTextLabel.text = "\(Int(minTemperature))º"
                cell.rightTextLabel.text = "\(Int(maxTemperature))º"
            }
        case 1:
            cell.leftLabel.text = "기압"
            cell.rightLabel.text = "습도"
            if let pressure = self.city?.main.pressure,
                let humidity = self.city?.main.humidity {
                cell.leftTextLabel.text = "\(Int(pressure))hPa"
                cell.rightTextLabel.text = "\(Int(humidity))%"
            }
        case 2:
            cell.leftLabel.text = "바람"
            cell.rightLabel.text = "가시거리"
            if let speed = self.city?.wind.speed {
                cell.leftTextLabel.text = "\(speed)m/s"
            }
            if let visibility = self.city?.visibility {
                cell.rightTextLabel.text = "\(visibility/1000)km"
            }
            
        case 3:
            cell.leftLabel.text = "일출"
            cell.rightLabel.text = "일몰"
            if let sunriseTime = self.city?.sys.sunrise,
                let sunsetTime = self.city?.sys.sunset,
                    let timeZone = self.city?.timezone {
                
                let sunriseTimeStr = Date.UTCToLocal(inputTime: sunriseTime, timeZone: timeZone)
                let sunsetTimeStr = Date.UTCToLocal(inputTime: sunsetTime, timeZone: timeZone)
                
                cell.leftTextLabel.text = "\(sunriseTimeStr)"
                cell.rightTextLabel.text = "\(sunsetTimeStr)"
            }
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableView Delegate
extension WeatherController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - Date Extension 날짜, 시간 변환
extension Date {
    // UTC to Local Time 변환
    public static func UTCToLocal(inputTime: Float, timeZone: Int) -> String {
        let sunriseTimeDate = Date(timeIntervalSince1970: TimeInterval(inputTime))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "h:mm a"
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: timeZone)
        return dateFormatter1.string(from: sunriseTimeDate)
    }
}
