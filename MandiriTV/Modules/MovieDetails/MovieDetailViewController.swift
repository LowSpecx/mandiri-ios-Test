//
//  MovieDetailViewController.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//
import AsyncDisplayKit
import UIKit
import youtube_ios_player_helper
import RxSwift

final class MovieDetailViewController: ASDKViewController<ASDisplayNode>,Viewable{
    //MARK: Properties
    public var presenter: MovieDetailPresenter!
    private var reviews: [Review] = []
    private let didLoadTrigger = PublishSubject<Void>()
    private let didReachBottomReviewTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    //MARK: UI Components
    private let playerNode: ASDisplayNode
    private let generalInfoNode: GeneralInfoNode
    private let reviewsTableNode: ASTableNode
    
    //MARK: Functions
    override init() {
        playerNode = ASDisplayNode(viewBlock: { () -> UIView in
            let view = YTPlayerView()
            return view
        })
        playerNode.style.width = ASDimensionMake(.fraction, 1.0)
        playerNode.style.height = ASDimensionMake(.points, 300)
        
        generalInfoNode = GeneralInfoNode()
        reviewsTableNode = ASTableNode()
        reviewsTableNode.style.width = ASDimensionMake(.fraction, 1.0)
        reviewsTableNode.style.height = ASDimensionMake(.fraction, 0.5)
        
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        reviewsTableNode.dataSource = self
        reviewsTableNode.delegate = self
        node.layoutSpecBlock = { [weak self] _,_ in
            guard let self = self else {return ASLayoutSpec()}
            
            let generalInsetLayout = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                child: self.generalInfoNode
            )
            
            let reviewInsetLayout = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                child: self.reviewsTableNode
            )
            
            return ASStackLayoutSpec(
                direction: .vertical,
                spacing: 10,
                justifyContent: .start,
                alignItems: .center,
                children: [self.playerNode,generalInsetLayout,reviewInsetLayout])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoadTrigger.onNext(())
    }
    
    public func bindPresenter(){
        let output = presenter.transform(input: MovieDetailPresenter.Input(
            didLoadTrigger: didLoadTrigger,
            didReachBottomReviewTrigger: didReachBottomReviewTrigger
        ))
        
        output.movie.subscribe(onNext: { [generalInfoNode] movie in
            generalInfoNode.bind(with: movie)
            generalInfoNode.setNeedsLayout()
        })
        .disposed(by: disposeBag)
        
        output.reviews.subscribe(onNext: { [weak self] reviews in
            guard let self = self else {return}
            print(">>> reviews received: \(reviews)")
            let startIndex = self.reviews.count == 0 ? 0 : self.reviews.count-1
            let endIndex = startIndex + reviews.count
            let indexPaths = (startIndex..<endIndex).map {
                IndexPath(row: $0, section: 0)
            }
            self.reviews.append(contentsOf: reviews)
            self.reviewsTableNode.insertRows(at: indexPaths, with: .automatic)
        })
        .disposed(by: disposeBag)
        
        output.video.subscribe(onNext: { [weak self] youtubeVideo in
            guard let self = self else {return}
            if let youtubePlayerView = self.playerNode.view as? YTPlayerView{
                youtubePlayerView.load(withVideoId: youtubeVideo.key)
            }
        }).disposed(by: disposeBag)
    }
}

extension MovieDetailViewController: ASTableDataSource{
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        print(">>> reviews count: \(reviews.count)")
        return reviews.count
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let review = reviews[indexPath.row]
        
        return {ReviewCellNode(review: review)}
    }
}

extension MovieDetailViewController: ASTableDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height{
            didReachBottomReviewTrigger.onNext(())
        }
    }
}
