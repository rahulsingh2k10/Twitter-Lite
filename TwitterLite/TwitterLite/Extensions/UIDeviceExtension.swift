//
//  UIDeviceExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 07/07/22.
//

import UIKit


extension UIDevice {
    static var isiPhone = (UIDevice.current.userInterfaceIdiom == .phone)
    static var isiPad = (UIDevice.current.userInterfaceIdiom == .pad)
}
