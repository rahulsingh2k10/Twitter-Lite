//
//  Utils.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


struct Utils {
    static var shared: Utils = Utils()
    private init() {}

    public var loggedInUser: UserModel?
}
