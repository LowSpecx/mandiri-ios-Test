//
//  MovieListRouter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import Foundation
import UIKit

struct MovieListRouterInput{
    public func view(genre: Genre)->MovieListViewController{
        let view = MovieListViewController()
        return view
    }
    
    public func push(from: Viewable, genre: Genre){
        let view = self.view(genre: genre)
        from.push(view, animated: true)
    }
    
    public func present(from: Viewable, genre: Genre){
        let nav = UINavigationController(rootViewController: view(genre: genre))
        from.present(nav, animated: true)
    }
}

final class MovieListRouterOutput: Routerable{
    private(set) weak var view: Viewable!
    
    init(view: Viewable!) {
        self.view = view
    }
    
    func transitionDetail(){
        
    }
}
