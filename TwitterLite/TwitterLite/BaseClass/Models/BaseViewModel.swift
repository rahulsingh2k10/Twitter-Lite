//
//  BaseViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 25/06/22.
//

import Foundation


protocol ViewModelProtocol {
    var title: String { get }
    init()
}


class BaseViewModel: ViewModelProtocol {
    public var title: String {
        get {
            return "Base View Model"
        }
    }

    required init() {
        print("Init Called: \(self)")
    }

    deinit {
        print("***** Deinit Called: \(self) *****")
    }
}
