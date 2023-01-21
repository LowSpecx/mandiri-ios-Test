//
//  MovieListViewController.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

import AsyncDisplayKit
import RxSwift
import UIKit

final class MovieListViewController: ASDKViewController<ASDisplayNode>,Viewable{
    var presenter: MovieListPresenter!
    
    //UI Component
    private let moviesCollectionNode: ASCollectionNode
    
    //properties
    private var movies: [Movie] = []
    
    //Input
    private let didLoadTrigger = PublishSubject<Void>()
    
    private let didSelectMovieTrigger = PublishSubject<IndexPath>()
    
    private let didReachBottomTrigger = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        self.moviesCollectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        self.moviesCollectionNode.style.flexGrow = 1.0
        
        super.init(node: ASDisplayNode())
        moviesCollectionNode.dataSource = self
        moviesCollectionNode.delegate = self
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = { [weak self] _,_ in
            guard let self = self else {return ASLayoutSpec()}
            return ASWrapperLayoutSpec(layoutElement: self.moviesCollectionNode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoadTrigger.onNext(())
    }
    
    public func bindPresenter(){
        let output = presenter.transform(input: MovieListPresenter.Input(
            didLoadTrigger: didLoadTrigger,
            didSelectMovieTrigger: didSelectMovieTrigger,
            didReachBottomTrigger: didReachBottomTrigger)
        )
        
        output.movies.subscribe(onNext: { movies in
            let startIndex = self.movies.count == 0 ? 0 : self.movies.count-1
            let endIndex = startIndex + movies.count
            let indexPaths = (startIndex..<endIndex).map {
                IndexPath(row: $0, section: 0)
            }
            self.movies.append(contentsOf: movies)
            self.moviesCollectionNode.insertItems(at: indexPaths)
        })
        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieListViewController: ASCollectionDataSource{
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let moviePosterURLString = movies[indexPath.row].posterPath
        return {MoviePosterNode(imageURLString: moviePosterURLString)}
    }
}

extension MovieListViewController: ASCollectionDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height{
            didReachBottomTrigger.onNext(())
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        didSelectMovieTrigger.onNext(indexPath)
    }
}
