//
//  RingProgressView.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import UIKit
import QuartzCore


@IBDesignable
class RingProgressView: UIView {
    @IBInspectable var ringWidth: CGFloat = 2.0
    @IBInspectable var trackColor: UIColor = .secondaryLabel
    @IBInspectable var circleColor: UIColor = .blue

    private var ringLayer = CAShapeLayer()
    private var currentValue: CGFloat = 0.0

    // MARK: - Public Methods -
    public func animateCircle(toValue: CGFloat) {
        createLayer()

        currentValue = toValue

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = currentValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        ringLayer.strokeEnd = toValue
        ringLayer.add(animation, forKey: "animateCircle")
    }

    // MARK: - Private Methods -
    private func createLayer() {
        let viewPoint = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let ringPath = UIBezierPath(arcCenter: viewPoint,
                                    radius: (frame.size.width )/2,
                                    startAngle: 0.0,
                                    endAngle: CGFloat(.pi * 2.0),
                                    clockwise: true)

        let trackLayer = CAShapeLayer()
        trackLayer.path = ringPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = ringWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round

        layer.sublayers?.removeAll()
        layer.addSublayer(trackLayer)

        ringLayer.path = ringPath.cgPath
        ringLayer.strokeColor = circleColor.cgColor
        ringLayer.lineWidth = ringWidth
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.lineCap = CAShapeLayerLineCap.round
        ringLayer.strokeEnd = 0

        layer.addSublayer(ringLayer)
    }
}
