//
//  CheckBox.swift
//  Swifty
//
//  Created by chanhbv on 17/9/24.
//

import Combine
import Foundation
import UIKit

open class CheckBox: UIControl {
    var isChecked: Bool = false
    var title: String?

    init(isChecked: Bool, title: String? = nil) {
        self.isChecked = isChecked
        self.title = title
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(getImage(
            systemName: isChecked ? "checkmark.square.fill" : "square",
            with: isChecked ? AppColor.primary : AppColor.secondaryText
        ), for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button.backgroundColor = .clear
        button.tintColor = AppColor.primary
        button.contentMode = .scaleAspectFill
        return button
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = AppFont.body
        label.textColor = AppColor.secondaryText
        label.numberOfLines = 3
        label.textAlignment = .justified
        return label
    }()

    @objc private func didTap() {
        isChecked.toggle()
        button.setImage(getImage(
            systemName: isChecked ? "checkmark.square.fill" : "square",
            with: isChecked ? AppColor.primary : AppColor.secondaryText
        ), for: .normal)
        sendActions(for: .checkboxToggleAction)
    }
}

public extension CheckBox {
    private func setupViews() {
        for item in [button, label] {
            item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
        }
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30),

            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }

    func getImage(systemName: String, with color: UIColor = AppColor.black) -> UIImage? {
        UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?
            .withTintColor(color)
            .withRenderingMode(.alwaysOriginal)
    }
}
