//
//  PresenterType.swift
//  MandiriTV
//
//  Created by Maurice Tin on 20/01/23.
//

protocol PresenterType{
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
