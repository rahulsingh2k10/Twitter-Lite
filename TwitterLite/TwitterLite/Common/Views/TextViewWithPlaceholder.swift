//
//  TextViewWithPlaceholder.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import UIKit


protocol PlaceholderTextViewDelegate: AnyObject {
    func placeholderTextViewDidChangeText(_ text: String)
    func placeholderTextViewShouldReplace(_ text: String) -> Bool
}


extension PlaceholderTextViewDelegate {
    func placeholderTextViewDidChangeText(_ text: String) {}
    func placeholderTextViewShouldReplace(_ text: String) -> Bool { return true }
}


class PlaceholderTextView: UITextView {
    public weak var textViewDelegate: PlaceholderTextViewDelegate?

    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var borderColor: UIColor = .placeholderText

    @IBInspectable
    var placeholder: String? {
        didSet {
            placeholderLabel?.text = placeholder
        }
    }

    private var placeholderLabel: UILabel?

    init() {
        super.init(frame: CGRect.zero, textContainer: .none)

        awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        delegate = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChangeHandler(notification:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: .none)

        placeholderLabel = UILabel()
        placeholderLabel?.text = placeholder
        placeholderLabel?.textAlignment = .left
        placeholderLabel?.numberOfLines = 0
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let font: UIFont = .systemFont(ofSize: 14, weight: .medium)

        placeholderLabel?.font = font

        var height:CGFloat = font.lineHeight
        if let data = placeholderLabel?.text {
            let expectedDefaultWidth: CGFloat = bounds.size.width
            let fontSize: CGFloat = font.pointSize

            let textView = UITextView()
            textView.text = data
            textView.font = .systemFont(ofSize: fontSize)
            let size = CGSize(width: expectedDefaultWidth, height: CGFloat.greatestFiniteMagnitude)
            let sizeForTextView = textView.sizeThatFits(size)
            let expectedTextViewHeight = sizeForTextView.height

            if expectedTextViewHeight > height {
                height = expectedTextViewHeight
            }
        }

        placeholderLabel?.frame = CGRect(x: 5, y: 0, width: bounds.size.width - 16, height: height)
        placeholderLabel?.textColor = .placeholderText

        if text.isEmpty {
            addSubview(placeholderLabel!)
            bringSubviewToFront(placeholderLabel!)
        } else {
            placeholderLabel?.removeFromSuperview()
        }
    }

    // MARK: - Notification Methods -
    @objc
    private func textDidChangeHandler(notification: Notification) {
        layoutSubviews()
    }
}


extension PlaceholderTextView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textViewDelegate?.placeholderTextViewShouldReplace(text) ?? true
    }

    func textViewDidChange(_ textView: UITextView) {
        textViewDelegate?.placeholderTextViewDidChangeText(textView.text)
    }
}
