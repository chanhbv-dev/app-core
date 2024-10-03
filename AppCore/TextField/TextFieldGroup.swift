//
//  TextFieldGroup.swift
//  Swifty
//
//  Created by chanhbv on 13/9/24.
//

import Combine
import Foundation
import UIKit

open class TextFieldGroup: UIControl {
    private var subscriptions = Set<AnyCancellable>()
    public enum State {
        case info
        case warning(String?)
        case error(String?)
        case confirmed(String?)
    }

    public var groupState: State = .info {
        didSet {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .showHideTransitionViews) { [weak self] in
                self?.updateGroupState()
            }
        }
    }

    public var placeholder: String?
    public var helperMsg: String?
    public var content: String?
    public var isSecure: Bool = false

    public init(placeholder: String? = nil, helperMsg: String? = nil, content: String? = nil, isSecure: Bool = false) {
        self.placeholder = placeholder
        self.helperMsg = helperMsg
        self.content = content
        self.isSecure = isSecure
        super.init(frame: .zero)
        setupViews()
        textField.delegate = self
        textField.isSecure = isSecure
        bindEvents()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeFirstResponder() {
        if textField.canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    private func bindEvents() {
        Publishers.Merge(
            beginEditingPublisher,
            endEditingPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            if self?.helperMsg == nil {
                self?.groupState = .info
            }
        }
        .store(in: &subscriptions)
    }

    private func updateGroupState() {
        switch groupState {
            case .info:
                textField.layer.borderColor = textField.isFirstResponder ? AppColor.primary.cgColor : AppColor.placeholder.cgColor
                helperLabel.isHidden = true
                helperMsg = nil
            case let .warning(msg):
                textField.layer.borderColor = AppColor.warning.cgColor
                helperLabel.textColor = AppColor.text
                helperLabel.isHidden = true
                if let msg {
                    helperMsg = msg
                    helperLabel.isHidden = false
                    helperLabel.text = msg
                    helperLabel.textColor = AppColor.warning
                }
            case let .error(msg):
                textField.layer.borderColor = AppColor.error.cgColor
                helperLabel.isHidden = true
                helperLabel.textColor = AppColor.text
                if let msg {
                    helperMsg = msg
                    helperLabel.isHidden = false
                    helperLabel.text = msg
                    helperLabel.textColor = AppColor.error
                }
            case let .confirmed(msg):
                textField.layer.borderColor = AppColor.placeholder.cgColor
                helperLabel.isHidden = true
                helperLabel.textColor = AppColor.text
                if let msg {
                    helperMsg = msg
                    helperLabel.isHidden = false
                    helperLabel.text = msg
                    helperLabel.textColor = AppColor.success
                }
        }
        if let bottomConstraint {
            NSLayoutConstraint.deactivate([bottomConstraint])
        }
        if helperLabel.isHidden {
            bottomConstraint = bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        } else {
            bottomConstraint = bottomAnchor.constraint(equalTo: helperLabel.bottomAnchor)
        }
        if let bottomConstraint {
            NSLayoutConstraint.activate([bottomConstraint])
        }
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColor.white
        textField.placeholder = placeholder
        textField.text = content
        helperLabel.text = helperMsg
        addSubview(textField)
        addSubview(helperLabel)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48),

            helperLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            helperLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            helperLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            helperLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 24),
        ])
        bottomConstraint = bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        if let bottomConstraint {
            NSLayoutConstraint.activate([bottomConstraint])
        }
    }

    private var bottomConstraint: NSLayoutConstraint?

    private lazy var textField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = AppColor.text
        textField.font = AppFont.body
        return textField
    }()

    private lazy var helperLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondaryText
        label.font = AppFont.subtitle
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

extension TextFieldGroup: UITextFieldDelegate {
    public func textFieldDidEndEditing(_: UITextField) {
        sendActions(for: .textFieldDidEndEditing)
    }

    public func textFieldDidBeginEditing(_: UITextField) {
        sendActions(for: .textFieldDidBeginEditing)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text as? NSString {
            content = currentText.replacingCharacters(in: range, with: string)
            sendActions(for: .textFieldContentDidChange)
        }

        return true
    }
}
