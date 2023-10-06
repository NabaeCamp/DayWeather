//
//  PlayListViewModel.swift
//  DayWeather
//
//  Created by 랑 on 2023/10/05.
//

import UIKit

class PlayListViewModel {
    
    private var weatherDataManager = WeatherDataManager.shared
    
    func getDataForPlayListView(lat: Double, lon: Double, completion: @escaping (UIImage?, String?, [PlayList]) -> Void) {
        weatherDataManager.fetchWeatherData(lat: lat, lon: lon) { [weak self] (data, _)  in
            guard let self else { return }
            guard let data = data else { return }
            
            let celsiusTemperature = data.main.feels_like - 273.15
            let sunriseTime = Date(timeIntervalSince1970: TimeInterval(data.sys.sunrise))
            let sunsetTime = Date(timeIntervalSince1970: TimeInterval(data.sys.sunset))
            let currentTime = Date()
            
            if celsiusTemperature < 5 && data.weather.first?.main != "Rain" {
                //추운 날
                completion(UIImage(named: "winterImage"), "얼어 죽겠어요🥶", [
                    PlayList(albumCover: UIImage(named: "coldAlbumCover1"), song: "And we go", singer: "성시경"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover2"), song: "그런 밤", singer: "어반자카파"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover3"), song: "Goodbye", singer: "박효신"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover4"), song: "마음을 드려요", singer: "아이유"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover5"), song: "Her", singer: "폴킴"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover6"), song: "If", singer: "샘김"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover7"), song: "우연을 믿어요", singer: "적재"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover8"), song: "You already have", singer: "권진아"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover9"), song: "가사", singer: "박재정"),
                    PlayList(albumCover: UIImage(named: "coldAlbumCover10"), song: "느린 우체통", singer: "윤하")
                ])
            } else if celsiusTemperature > 30 && data.weather.first?.main != "Rain" {
                //더운 날
                completion(UIImage(named: "summerImage"), "너무 더워요🥵", [
                    PlayList(albumCover: UIImage(named: "hotAlbumCover1"), song: "다시 여기 바닷가", singer: "싹쓰리"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover2"), song: "애상", singer: "쿨"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover3"), song: "여름 이야기", singer: "DJ DOC"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover4"), song: "8282", singer: "다비치"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover5"), song: "비행기", singer: "거북이"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover6"), song: "여름아 부탁해", singer: "인디고"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover7"), song: "바다의 왕자", singer: "박명수"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover8"), song: "Festival", singer: "엄정화"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover9"), song: "파도", singer: "UN"),
                    PlayList(albumCover: UIImage(named: "hotAlbumCover10"), song: "으쌰으쌰", singer: "신화")
                ])
            } else if data.weather.first?.main == "Rain" {
                //비오는 날
                completion(UIImage(named: "rainImage"), "비가 내리네요", [
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover1"), song: "우산(Feat.윤하)", singer: "에픽하이"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover2"), song: "빗소리", singer: "윤하"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover3"), song: "비 오는 날 듣기 좋은 노래(Feat.Colde)", singer: "에픽하이"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover4"), song: "북향(Feat.오혁)", singer: "다이나믹 듀오"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover5"), song: "비도 오고 그래서", singer: "헤이즈"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover6"), song: "잠 못 드는 밤 비는 내리고", singer: "김건모"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover7"), song: "비", singer: "폴킴"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover8"), song: "비가 오는 날엔", singer: "비스트"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover9"), song: "비가 오잖아", singer: "소유 & 오반"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover10"), song: "밤편지", singer: "아이유")
                ])
            } else if currentTime >= calculateSunTime(sunriseTime) && currentTime <= sunriseTime {
                //일출 30분 전부터 일출 때까지
                completion(UIImage(named: "sunriseImage"), "같이 일출 구경할까요?", [
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover1"), song: "Places We Won't Walk", singer: "Bruno Major"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover2"), song: "As Beautiful as You", singer: "Will Post"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover3"), song: "When The World Stopped Moving", singer: "Lizzy McAlpine"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover4"), song: "Wanderlust", singer: "Eloise"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover5"), song: "Vanilla Baby", singer: "Billie Marten"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover6"), song: "Come Rain Or Come Shine", singer: "Chet Baker"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover5"), song: "Fish", singer: "Billie Marten"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover7"), song: "Everyone Adores You (quiet)", singer: "Matt Maltese"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover6"), song: "Come Rain Or Come Shine", singer: "Billie Marten"),
                    PlayList(albumCover: UIImage(named: "sunriseAlbumCover3"), song: "In What World", singer: "Lizzy McAlpine")
                ])
            } else if currentTime >= calculateSunTime(sunsetTime) && currentTime <= sunsetTime {
                //일몰 30분 전부터 일몰 때까지
                completion(UIImage(named: "sunsetImage"), "같이 일몰 구경할까요?", [
                    PlayList(albumCover: UIImage(named: "albumCover1"), song: "우산(Feat.윤하)", singer: "에픽하이"),
                    PlayList(albumCover: UIImage(named: "albumCover2"), song: "빗소리", singer: "윤하"),
                    PlayList(albumCover: UIImage(named: "albumCover3"), song: "비 오는 날 듣기 좋은 노래(Feat.Colde)", singer: "에픽하이"),
                    PlayList(albumCover: UIImage(named: "albumCover4"), song: "북향(Feat.오혁)", singer: "다이나믹 듀오"),
                    PlayList(albumCover: UIImage(named: "albumCover5"), song: "비도 오고 그래서", singer: "헤이즈"),
                    PlayList(albumCover: UIImage(named: "albumCover6"), song: "잠 못 드는 밤 비는 내리고", singer: "김건모"),
                    PlayList(albumCover: UIImage(named: "albumCover7"), song: "비", singer: "폴킴"),
                    PlayList(albumCover: UIImage(named: "albumCover8"), song: "비가 오는 날엔", singer: "비스트"),
                    PlayList(albumCover: UIImage(named: "albumCover9"), song: "비가 오잖아", singer: "소유 & 오반"),
                    PlayList(albumCover: UIImage(named: "albumCover10"), song: "밤편지", singer: "아이유")
                ])
            } else {
                //변경하기
                completion(UIImage(named: "rainImage"), "비가 내리네요", [
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover1"), song: "우산(Feat.윤하)", singer: "에픽하이"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover2"), song: "빗소리", singer: "윤하"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover3"), song: "비 오는 날 듣기 좋은 노래(Feat.Colde)", singer: "에픽하이"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover4"), song: "북향(Feat.오혁)", singer: "다이나믹 듀오"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover5"), song: "비도 오고 그래서", singer: "헤이즈"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover6"), song: "잠 못 드는 밤 비는 내리고", singer: "김건모"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover7"), song: "비", singer: "폴킴"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover8"), song: "비가 오는 날엔", singer: "비스트"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover9"), song: "비가 오잖아", singer: "소유 & 오반"),
                    PlayList(albumCover: UIImage(named: "rainyAlbumCover10"), song: "밤편지", singer: "아이유")
                ])
            }
        }
    }
    
    private func calculateSunTime(_ date: Date) -> Date {
        let thirtyMinutesBeforeSunTime = date.addingTimeInterval(-30 * 60)
        return thirtyMinutesBeforeSunTime
    }
}
