//
//  MovieDetailViewController.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation
import AsyncDisplayKit

final class MovieDetailViewController: ASDKViewController<ASDisplayNode>,Viewable{
    var presenter: MovieDetailPresenter!
    
    override init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindPresenter(){
        
    }
}
