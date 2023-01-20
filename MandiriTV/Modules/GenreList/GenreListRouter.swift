//
//  GenreListRouter.swift
//  MandiriTV
//
//  Created by Maurice Tin on 18/01/23.
//

import Foundation
import UIKit

struct GenreListRouterInput{
    private func view()->GenreViewController{
        let view = GenreViewController()
        return view
    }
    
    public func push(from: Viewable){
        let view = self.view()
        from.push(view, animated: true)
    }
    
    public func present(from: Viewable){
        let nav = UINavigationController(rootViewController: view())
        from.present(nav, animated: true)
    }
}

final class GenreListRouterOutput: Routerable{
    private(set) weak var view: Viewable!
    
    init(view: Viewable!) {
        self.view = view
    }
    
    func transitionDetail(){
        
    }
}
