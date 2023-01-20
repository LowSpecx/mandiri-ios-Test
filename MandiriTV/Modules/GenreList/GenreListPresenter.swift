//
//  GenreListPresenter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//
import Foundation
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
    
    //Output
    let genres = BehaviorSubject<[Genre]>(value: [])
    let error = PublishSubject<Void>()
    
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
        
        dependencies.interactor.genreResponseSubject
            .bind(to: genres)
            .disposed(by: disposeBag)
        
        dependencies.interactor.responseErrorSubject
            .bind(to: error)
            .disposed(by: disposeBag)
        
        input.didSelectGenreTrigger.bind(onNext: transitionDetail)
            .disposed(by: disposeBag)
        
        return Output(genres: genres, error: error)
    }
    
    private func transitionDetail(indexPath: IndexPath){
        guard let genre = try? genres.value()[indexPath.row] else {return}
        dependencies.router.transitionDetail(genre: genre)
    }
}
