//
//  GenreListPresenter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import RxSwift

typealias GenreListPresenterDependencies = (
    interactor: GenreListInteractor,
    router: GenreListRouterOutput
)

final class GenreListPresenter: PresenterType{
    struct Input{
        let didLoadTrigger: PublishSubject<Void>
        let didSelectGenreTrigger: PublishSubject<IndexPath>
    }
    
    struct Output{
        let genres: BehaviorSubject<[Genre]>
        let error: PublishSubject<Void>
    }
    
    private let dependencies: GenreListPresenterDependencies
    private let disposeBag = DisposeBag()
    
    init(dependencies: GenreListPresenterDependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        input.didLoadTrigger.subscribe(onNext: { [dependencies] in
            let apiRequest = APIRequest(urlString: APIEndpoints.getGenresURLString(), parameters: [
                "api_key" : apiKey
            ])
            dependencies.interactor.loadTrigger.onNext(apiRequest)
        })
        .disposed(by: disposeBag)
        
        let genres = BehaviorSubject<[Genre]>(value: [])
        
        dependencies.interactor.genreResponseSubject
            .bind(to: genres)
            .disposed(by: disposeBag)
        
        let error = PublishSubject<Void>()
        
        dependencies.interactor.responseErrorSubject
            .bind(to: error)
            .disposed(by: disposeBag)
        
        return Output(genres: genres, error: error)
    }
}
