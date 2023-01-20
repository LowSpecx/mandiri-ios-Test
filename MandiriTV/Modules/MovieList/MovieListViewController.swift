//
//  MovieListViewController.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import AsyncDisplayKit

final class MovieListViewController: ASDKViewController<ASDisplayNode>,Viewable{
    
    override init() {
        super.init(node: ASDisplayNode())
        node.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
