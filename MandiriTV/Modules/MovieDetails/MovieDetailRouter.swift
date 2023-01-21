//
//  MovieDetailRouter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation
import UIKit

struct MovieDetailRouterInput{
    public func view(movie: Movie)->MovieDetailViewController{
        let view = MovieDetailViewController()
        let interactor = MovieDetailInteractor()
        let dependencies = MovieDetailPresenterDependencies(interactor: interactor, router: MovieDetailRouterOutput(view: view))
        let presenter = MovieDetailPresenter(movie: movie, dependencies: dependencies)
        view.presenter = presenter
        view.bindPresenter()
        return view
    }
    
    public func push(from: Viewable, movie: Movie){
        let view = self.view(movie: movie)
        from.push(view, animated: true)
    }
    
    public func present(from: Viewable, movie: Movie){
        let nav = UINavigationController(rootViewController: view(movie: movie))
        from.present(nav, animated: true)
    }
}

final class MovieDetailRouterOutput: Routerable{
    private(set) weak var view: Viewable!
    
    init(view: Viewable!) {
        self.view = view
    }
}
