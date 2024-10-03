//
//  TextField.swift
//  Swifty
//
//  Created by chanhbv on 12/9/24.
//

import Foundation
import UIKit

open class TextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 50)
    private let placeholderText: String?

    public var isSecure: Bool = false {
        didSet {
            isSecureTextEntry = isSecure
            setupSecure()
        }
    }

    public init(with content: String? = nil, placeholder: String? = "", isSecureTextEntry: Bool = false) {
        placeholderText = placeholder
        super.init(frame: .zero)
        text = content
        setupViews()
        isSecure = isSecureTextEntry
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 10
        return rect
    }

    @objc func doToggleView() {
        isSecureTextEntry.toggle()
        toggleActionView.setImage(getImage(with: isSecureTextEntry), for: .normal)
        sendActions(for: .textFieldToggleAction)
    }

    private lazy var toggleActionView: UIButton = {
        let button = UIButton()
        button.setImage(getImage(), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(doToggleView), for: .touchUpInside)
        return button
    }()
}

public extension TextField {
    func getImage(with isSecure: Bool = false) -> UIImage? {
        UIImage(
            systemName: isSecure ? "eye.slash" : "eye",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14)
        )?.withTintColor(AppColor.black)
            .withRenderingMode(.alwaysOriginal)
    }

    func setupViews() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = AppColor.placeholder.cgColor
        textColor = AppColor.text
        font = AppFont.body
        tintColor = AppColor.text
        attributedPlaceholder = NSAttributedString(
            string: placeholderText ?? "",
            attributes: [.font: AppFont.body, .foregroundColor: AppColor.placeholder]
        )
    }

    func setupSecure() {
        if isSecureTextEntry {
            rightView = toggleActionView
            rightViewMode = .always
            clearButtonMode = .never
        } else {
            clearButtonMode = .whileEditing
        }
        layoutIfNeeded()
    }
}
