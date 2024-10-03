//
//  AlertViewController.swift
//  Swifty
//
//  Created by chanhbv on 20/9/24.
//

import Combine
import Foundation
internal import Lottie
import UIKit

open class AlertViewController: UIViewController {
    public typealias CompletionAction = () -> Void
    public enum AlertType {
        case info
        case success
        case error
        case warning
    }

    private var _title: String
    private var message: String
    private var type: AlertType
    public var completion: CompletionAction?

    public init(title: String, message: String, type: AlertType = .info) {
        _title = title
        self.message = message
        self.type = type
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleView.text = _title
        subtitleView.text = message

        container.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.black.withAlphaComponent(0.5)
        for item in [animationView, titleView, subtitleView, submitButton, cancelButton] {
            item.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(item)
        }
        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            animationView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animationView.widthAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1 / 3),
            animationView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1 / 3),

            titleView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            titleView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            titleView.heightAnchor.constraint(equalToConstant: 30),

            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            subtitleView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            subtitleView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            subtitleView.heightAnchor.constraint(equalToConstant: 48),

            submitButton.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 48),
            submitButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 48),

            cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }

    @objc func didTapCancel() {
        dismiss(animated: true)
    }

    @objc func didTapSubmit() {
        if let completion {
            completion()
        }
    }

    private func prepareAnimation(type: AlertType) -> LottieAnimation? {
        switch type {
            case .success: return LottieAnimation.named("success")
            case .info: return LottieAnimation.named("warning")
            case .error: return LottieAnimation.named("error")
            case .warning: return LottieAnimation.named("warning")
        }
    }

    // MARK: - UIControls

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.background
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.configuration = .init(renderingEngine: .automatic)
        view.animationSpeed = 0.75
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .playOnce
        view.animation = prepareAnimation(type: type)
        return view
    }()

    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.font = AppFont.title
        view.textColor = AppColor.text
        view.textAlignment = .center
        return view
    }()

    private lazy var subtitleView: UILabel = {
        let view = UILabel()
        view.font = AppFont.body
        view.textColor = AppColor.text
        view.numberOfLines = 3
        view.textAlignment = .center
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Bỏ qua", for: .normal)
        view.titleLabel?.font = AppFont.action
        view.setTitleColor(AppColor.primary, for: .normal)
        view.backgroundColor = AppColor.background
        view.layer.cornerRadius = 24
        view.layer.borderColor = AppColor.primary.cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return view
    }()

    private lazy var submitButton = FilledButton(title: "Đồng ý")
}
