//
//  ErrorNode.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import AsyncDisplayKit

final public class ErrorNode: ASDisplayNode{
    private let errorMessageNode: ASTextNode2
    private let tryAgainButtonNode: ASButtonNode
    private let callback: ()->Void
    
    public init(callback: @escaping ()->Void) {
        errorMessageNode = ASTextNode2()
        errorMessageNode.attributedText = NSAttributedString(
            string: "Oops we can't load the content, please try again...",
            attributes: [
                .font : UIFont.systemFont(ofSize: 18, weight: .semibold),
                .foregroundColor : UIColor.white
            ]
        )
        
        tryAgainButtonNode = ASButtonNode()
        tryAgainButtonNode.setTitle("Retry", with: nil, with: .red, for: .normal)
        self.callback = callback
        super.init()
        automaticallyManagesSubnodes = true
        tryAgainButtonNode.addTarget(self, action: #selector(didClickTryAgain), forControlEvents: .touchUpInside)
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .vertical, spacing: 6, justifyContent: .center, alignItems: .center, children: [errorMessageNode,tryAgainButtonNode])
        
        return ASCenterLayoutSpec(centeringOptions: .XY, child: mainStack)
    }
    
    @objc private func didClickTryAgain(){
        callback()
    }
}
