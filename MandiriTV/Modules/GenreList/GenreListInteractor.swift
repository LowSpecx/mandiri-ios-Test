//
//  GenreListInteractor.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class GenreListInteractor{
    //Inputs
    let loadTrigger = PublishSubject<APIRequest>()
    
    //Outputs
    let genreResponseSubject = PublishSubject<[Genre]>()
    let responseErrorSubject = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        loadTrigger.subscribe(onNext: { apiRequest in
            AF.request(apiRequest.url, parameters: apiRequest.parameters)
                .responseDecodable(of: GenreResponse.self){
                    [weak self] response in
                    guard let self = self else {return}
                    if let _ = response.error{
                        self.responseErrorSubject.onNext(())
                    }
                    
                    guard let genres = response.value?.genres else {return}
                    self.genreResponseSubject.onNext(genres)
                }
        })
        .disposed(by: disposeBag)
    }
}
