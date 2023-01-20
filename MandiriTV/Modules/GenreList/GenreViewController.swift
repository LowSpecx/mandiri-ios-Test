//
//  GenreViewController.swift
//  MandiriTV
//
//  Created by Maurice Tin on 18/01/23.
//
import UIKit
import AsyncDisplayKit
import RxSwift

final class GenreViewController: ASDKViewController<ASDisplayNode>,Viewable{
    var presenter: GenreListPresenter!
    
    private let didLoadTrigger = PublishSubject<Void>()
    private let didSelectGenreTrigger = PublishSubject<IndexPath>()
    private let disposeBag = DisposeBag()
    
    private let genresTableNode: ASTableNode
    private var genres: [Genre] = []
    
    override init() {
        genresTableNode = ASTableNode()
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        genresTableNode.dataSource = self
        genresTableNode.delegate = self
        genresTableNode.style.width = ASDimensionMake(.fraction, 1)
        
        node.layoutSpecBlock = { [genresTableNode] _,_ in
            return ASWrapperLayoutSpec(layoutElement: genresTableNode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoadTrigger.onNext(())
    }
    
    public func bindPresenter(){
        let output = presenter.transform(
            input: GenreListPresenter.Input(
                didLoadTrigger: self.didLoadTrigger,
                didSelectGenreTrigger: didSelectGenreTrigger)
        )
        
        output.genres.subscribe(onNext: { [weak self] genres in
            guard let self = self else {return}
            self.genres = genres
            self.genresTableNode.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GenreViewController: ASTableDataSource{
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let genre = genres[indexPath.row]
        return {
            let textCellNode = ASTextCellNode()
            textCellNode.text = genre.name
            textCellNode.textAttributes = [
                .font : UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
            textCellNode.textInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            return textCellNode
        }
    }
}

extension GenreViewController: ASTableDelegate{
    
}

