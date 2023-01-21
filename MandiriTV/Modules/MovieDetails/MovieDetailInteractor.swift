//
//  MovieDetailInteractor.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation
import RxSwift
import Alamofire

final class MovieDetailInteractor{
    //Inputs
    let loadVideoTrigger = PublishSubject<APIRequest>()
    let loadReviewTrigger = PublishSubject<APIRequest>()
    
    //Outputs
    let videoResponseSubject = PublishSubject<[Video]>()
    let reviewResponseSubject = PublishSubject<[Review]>()
    
    let disposeBag = DisposeBag()
    
    init() {
        loadVideoTrigger.subscribe(onNext: { apiRequest in
            AF.request(apiRequest.urlString, parameters: apiRequest.parameters).responseDecodable(of: VideoResponse.self){ [weak self]
                response in
                guard let self = self,
                let videos = response.value?.results else {return}
                self.videoResponseSubject.onNext(videos)
            }
        })
        .disposed(by: disposeBag)
        
        loadReviewTrigger.subscribe(onNext: { apiRequest in
            AF
                .request(apiRequest.urlString, parameters: apiRequest.parameters)
                .responseDecodable(of: ReviewResponse.self){ [weak self] response in
                    guard let self = self,
                          let reviews = response.value?.results else {return}
                    self.reviewResponseSubject.onNext(reviews)
                }
        })
        .disposed(by: disposeBag)
    }
}

