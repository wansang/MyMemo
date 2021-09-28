//
//  ServiceProtocol.swift
//  ItBooks
//
//  Created by wsryu on 2021/09/15.
//

protocol ServiceProtocol {
    associatedtype Repository
    var repository: Repository! { get set }
}
