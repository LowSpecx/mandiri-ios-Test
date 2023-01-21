//
//  MovieDetailPresenter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation
import RxSwift

typealias MovieDetailPresenterDependencies = (
    interactor: MovieDetailInteractor,
    router: MovieDetailRouterOutput
)

final class MovieDetailPresenter: PresenterType{
    struct Input{
        let didLoadTrigger: PublishSubject<Void>
        let didReachBottomReviewTrigger: PublishSubject<Void>
    }
    
    struct Output{
        let movie: BehaviorSubject<Movie>
        let video: PublishSubject<Video>
        let reviews: BehaviorSubject<[Review]>
    }
    
    private let dependencies: MovieDetailPresenterDependencies
    private let disposeBag = DisposeBag()
    
    var reviewPageCounter = 0
    
    let movieSubject: BehaviorSubject<Movie>
    
    let videoSubject = PublishSubject<Video>()
    
    let reviewSubject = BehaviorSubject<[Review]>(value: [])
    
    init(movie: Movie, dependencies: MovieDetailPresenterDependencies){
        self.movieSubject = BehaviorSubject(value: movie)
        
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        input.didReachBottomReviewTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.reviewPageCounter += 1
                guard let movie = try? self.movieSubject.value() else {return}
                
                let apiRequest = APIRequest(urlString: APIEndpoints.getReviewsURLString(id: movie.id), parameters: [
                    "api_key" : apiKey,
                    "page" : "\(self.reviewPageCounter)"
                ])
                
                self.dependencies.interactor.loadReviewTrigger.onNext(apiRequest)
            })
            .disposed(by: disposeBag)
        
        input.didLoadTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.reviewPageCounter += 1
                guard let movie = try? self.movieSubject.value() else {return}
                print(">>> movie name: \(movie.originalTitle)")
                let apiRequestReview = APIRequest(urlString: APIEndpoints.getReviewsURLString(id: movie.id), parameters: [
                    "api_key" : apiKey,
                    "page" : "\(self.reviewPageCounter)"
                ])
                
                self.dependencies.interactor.loadReviewTrigger.onNext(apiRequestReview)
                
                let apiRequestVideo = APIRequest(urlString: APIEndpoints.getVideosURLString(id: movie.id), parameters: [
                    "api_key" : apiKey
                ])
                self.dependencies.interactor.loadVideoTrigger.onNext(apiRequestVideo)
            })
            .disposed(by: disposeBag)
        
        dependencies
            .interactor
            .reviewResponseSubject
            .bind(to: reviewSubject)
            .disposed(by: disposeBag)
        
        dependencies
            .interactor
            .videoResponseSubject
            .subscribe(onNext: { [videoSubject] videos in
                guard let video = videos.first(where: {$0.site == "YouTube"}) else {return}
                videoSubject.onNext(video)
            })
            .disposed(by: disposeBag)
        
        return Output(movie: movieSubject, video: videoSubject, reviews: reviewSubject)
    }
}
