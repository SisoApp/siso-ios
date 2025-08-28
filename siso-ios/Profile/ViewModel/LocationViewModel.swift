//
//  LocationViewModel.swift
//  profile
//
//  Created by 멘태 on 8/24/25.
//
import Combine
import CoreLocation

enum Province: String, Identifiable, CaseIterable {
    case seoul = "서울"
    case incheon = "인천"
    case gyeonggi = "경기"
    case daejeon = "대전"
    case sejong = "세종"
    case chungbuk = "충북"
    case chungnam = "충남"
    case gwangju = "광주"
    case jeonbuk = "전북"
    case jeonnam = "전남"
    case gangwon = "강원"
    case daegu = "대구"
    case ulsan = "울산"
    case busan = "부산"
    case gyeongbuk = "경북"
    case gyeongnam = "경남"
    case jeju = "제주"
    
    var id: String { rawValue }
}

final public class LocationViewModel: NSObject, ObservableObject {
    @Published var location: String = ""
    @Published var isLoading: Bool = false
    
    private var locationManager: CLLocationManager
    
    public override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        super.init()
        
        locationManager.delegate = self
    }
    
    deinit {
        locationManager.stopUpdatingLocation() // 위치 업데이트 중단
        locationManager.delegate = nil // delegate 해제
    }
    
    func getCities(_ province: Province) -> [String] {
        switch province {
        case .seoul:
            return ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구","노원구", "도봉구", "동대문구", "동작구",
                    "마포구", "서대문구", "서초구", "성동구","성북구", "송파구", "양천구", "영등포구","용산구", "은평구", "종로구", "중구","중랑구"]
        case .incheon:
            return ["강화군", "계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군", "중구"]
        case .gyeonggi:
            return ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시",
                    "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"]
        case .daejeon:
            return ["대덕구", "동구", "서구", "중구", "유성구"]
        case .sejong:
            return ["세종시"]
        case .chungbuk:
            return ["괴산군", "단양군", "보은군", "영동군", "음성군", "옥천군", "제천시", "증평군", "진천군", "청주시", "충주시"]
        case .chungnam:
            return ["계룡시", "공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "청양군", "천안시", "태안군", "홍성군"]
        case .gwangju:
            return ["광산구", "남구", "동구", "북구", "서구"]
        case .jeonbuk:
            return ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "전주시", "정읍시", "장수군", "진안군"]
        case .jeonnam:
            return ["강진군", "곡성군", "광양시", "구례군", "고흥군", "나주시", "담양군", "목포시","무안군", "보성군", "순천시", "신안군",
                    "완도군", "영광군", "영암군", "여수시", "장성군", "장흥군", "진도군", "해남군", "화순군", "함평군"]
        case .gangwon:
            return ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "원주시", "영월군", "인제군", "정선군", "철원군", "춘천시", "태백시",  "평창군", "화천군", "홍천군", "횡성군"]
        case .daegu:
            return ["군위군", "남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"]
        case .ulsan:
            return ["남구", "동구", "북구", "중구", "울주군"]
        case .busan:
            return ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"]
        case .gyeongbuk:
            return ["경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시","성주군", "안동시", "영덕군",
                    "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"]
        case .gyeongnam:
            return ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군",
                    "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군", "합천군"]
        case .jeju:
            return ["서귀포시", "제주시"]
        }
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func checkAuthorizationStatus() throws {
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
    }
    
    func getLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            isLoading = true 
            locationManager.requestLocation()
        default:
            print("위치 권한 오류")
            isLoading = false
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = locationManager.authorizationStatus
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            isLoading = true
            locationManager.requestLocation()
        } else if status == .denied || status == .restricted {
            isLoading = false // 권한이 거부되면 로딩 상태 해제
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geoCoder: CLGeocoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("geoCoder error: \(error.localizedDescription)")
                        self?.isLoading = false
                        return
                    }
                    
                    if let placemark = placemarks?.first,
                       let country = placemark.country {
                        let address: [String] = placemark.description.components(separatedBy: country)[1].components(separatedBy: " ")
                        
                        if address.count > 2 {
                            let province: String = address[1].prefix(2).description
                            let city: String = address[2]
                            
                            self?.location = "\(province) \(city)"
                        } else {
                            print("Address Parsing Error: Out of Index...")
                        }
                        
                        self?.isLoading = false
                    }
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        print("위치 가져오기 실패: \(error.localizedDescription)")
    }
}
