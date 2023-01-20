//
//  MovieListInteractor.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class MovieListInteractor{
    //Inputs
    let loadTrigger = PublishSubject<APIRequest>()
    
    //Outputs
    let moviesResponseSubject = PublishSubject<[Movie]>()
    
    let responseErrorSubject = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        loadTrigger.subscribe(onNext: { apiRequest in
            AF.request(apiRequest.urlString, parameters: apiRequest.parameters)
                .responseDecodable(of: MoviesResponse.self){ [weak self] response in
                    guard let self = self else {return}
                    if let _ = response.error{
                        self.responseErrorSubject.onNext(())
                    }
                    
                    guard let movies = response.value?.results else {return}
                    self.moviesResponseSubject.onNext(movies)
                }
        })
        .disposed(by: disposeBag)
    }
}
