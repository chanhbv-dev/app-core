//
//  Button.swift
//  Swifty
//
//  Created by chanhbv on 17/9/24.
//

import Foundation
import UIKit

@IBDesignable
open class FilledButton: UIButton {
    private var highlightDuration: TimeInterval = 0.25

    var title: String = ""
    var highlightedBackgroundColor: UIColor? = AppColor.secondary
    var disabledBackgroundColor: UIColor? = AppColor.disabled
    var normalBackgroundColor: UIColor? = AppColor.primary
    var cornerRadius: CGFloat = 24

    override open var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                animateBackground(to: highlightedBackgroundColor, duration: highlightDuration)

            } else if oldValue == true && !isHighlighted {
                animateBackground(to: normalBackgroundColor, duration: highlightDuration)
            }
        }
    }

    override open var isEnabled: Bool {
        didSet {
            if oldValue == false && isEnabled {
                animateBackground(to: normalBackgroundColor, duration: 0)

            } else if oldValue == true && !isEnabled {
                animateBackground(to: disabledBackgroundColor, duration: 0)
            }
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        setupViews()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        setTitle(title, for: .normal)
        setTitleColor(AppColor.white, for: .normal)
        titleLabel?.font = AppFont.action
        backgroundColor = normalBackgroundColor
        layer.cornerRadius = cornerRadius
        layer.borderColor = normalBackgroundColor?.cgColor
        layer.borderWidth = 1
    }

    private func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.backgroundColor = color
            self?.layer.borderColor = color.cgColor
        }
    }
}
