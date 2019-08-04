# 도시별 날씨 검색 앱 

## 구현기능

~~~
- 전세계 도시명 검색 후 검색한 도시 핀 선택을 하면 해당 도시의 날씨 정보를 확인할 수 있습니다.
- 도시별로 메인 날씨 상태와 온도를 확인할 수 있습니다
- 최저온도, 최고온도, 기압, 습도, 바람, 가시거리, 일출(시간), 일몰(시간)도 확인 가능합니다 
~~~

<p align="center"><img width="220" height="400" src="/screenshots/screenshot1.png">
<img width="220" height="400" src="/screenshots/screenshot2.png">
<img width="220" height="400" src="/screenshots/screenshot3.png"></p>

## 기술셋

- Networking: URLSession 활용
- Model & Parser: Codable과 JSONDecoder 활용
- openWeathermap.org의 currentWeather API 활용 (좌표로 호출 가능한 API: By geographic coordinates)
- MapKit을 활용 도시명 검색
- Mapkit을 통해 검색한 도시의 위/경도 좌표 확보 -> 좌표 파라미터로 API 호출
- 검색한 도시명 UserDefault에 저장 -> 앱 재시작시 해당 도시명으로 호출된 맵뷰 화면 표시