//
//  MovieListPresenter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import Foundation
import RxSwift

typealias MovieListPresenterDependencies = (
    interactor: MovieListInteractor,
    router: MovieListRouterOutput
)

final class MovieListPresenter: PresenterType{
    struct Input{
        let didLoadTrigger: PublishSubject<Void>
        let didSelectMovieTrigger: PublishSubject<IndexPath>
        let didReachBottomTrigger: PublishSubject<Void>
    }
    
    struct Output{
        let movies: BehaviorSubject<[Movie]>
        let error: PublishSubject<Void>
    }
    
    private let genre: Genre
    private let dependencies: MovieListPresenterDependencies
    private var moviesCache: [Movie] = []
    private let disposeBag = DisposeBag()
    
    var pageCounter = 0
    
    let movies = BehaviorSubject<[Movie]>(value: [])
    let error = PublishSubject<Void>()
    
    init(genre: Genre, dependencies: MovieListPresenterDependencies) {
        self.genre = genre
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        Observable.merge(input.didLoadTrigger, input.didReachBottomTrigger)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.pageCounter += 1
                let apiRequest = APIRequest(urlString: APIEndpoints.getDiscoverMoviesURLString(), parameters: [
                    "api_key" : apiKey,
                    "with_genres" : "\(self.genre.id)",
                    "page" : "\(self.pageCounter)"
                ])
                self.dependencies.interactor.loadTrigger.onNext(apiRequest)
            })
            .disposed(by: disposeBag)
        
        input.didSelectMovieTrigger.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            let movie = self.moviesCache[indexPath.row]
            self.dependencies.router.transitionDetail(movie: movie)
        })
        .disposed(by: disposeBag)
        
        dependencies.interactor.moviesResponseSubject
            .bind(to: movies)
            .disposed(by: disposeBag)
        
        dependencies.interactor.moviesResponseSubject
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else {return}
                self.moviesCache.append(contentsOf: movies)
            })
            .disposed(by: disposeBag)
        
        dependencies.interactor.responseErrorSubject.bind(to: error)
            .disposed(by: disposeBag)
        
        return Output(movies: movies, error: error)
    }
}
