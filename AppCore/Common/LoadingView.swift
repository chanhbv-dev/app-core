//
//  LoadingView.swift
//  AppCore
//
//  Created by chanhbv on 2/10/24.
//

import Foundation
import UIKit

public class LoadingView: UIView {
    public enum LoadingMode {
        case fullScreen
        case crossDissolve
    }

    private var loadingIcon: UIImage?
    private var loadingTitle: String?
    public var loadingMode: LoadingMode {
        didSet {
            updateContent()
        }
    }

    init(loadingIcon: UIImage? = nil, loadingTitle: String? = nil, loadingMode: LoadingMode = .crossDissolve) {
        self.loadingIcon = loadingIcon
        self.loadingTitle = loadingTitle
        self.loadingMode = loadingMode
        super.init(frame: .zero)
        setupViews()
        updateContent()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startLoading() {
        waitIcon.startAnimating()
    }

    public func stopLoading() {
        waitIcon.stopAnimating()
    }

    // MARK: - Private funcs

    private func updateContent() {
        if let loadingIcon {
            logoView.image = loadingIcon
        }
        if let loadingTitle {
            waitText.text = loadingTitle
        }

        switch loadingMode {
            case .fullScreen:
                backgroundColor = AppColor.white
            case .crossDissolve:
                backgroundColor = AppColor.black.withAlphaComponent(0.5)
        }
    }

    private func setupViews() {
        for item in [logoView, hStack] {
            item.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(item)
        }
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        let constraints: [NSLayoutConstraint] = [
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            container.widthAnchor.constraint(equalToConstant: 200),
            container.heightAnchor.constraint(equalToConstant: 200),

            logoView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -20),
            logoView.widthAnchor.constraint(equalToConstant: 120),
            logoView.heightAnchor.constraint(equalToConstant: 120),

            hStack.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 10),
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.widthAnchor.constraint(equalToConstant: 150),

            waitText.heightAnchor.constraint(equalToConstant: 24),
            waitIcon.heightAnchor.constraint(equalToConstant: 24),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - UIControls

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private lazy var logoView: UIImageView = {
        let view = UIImageView(image: .init(named: "thantai"))
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var waitText: UILabel = {
        let view = UILabel()
        view.text = "Chờ chút nhé"
        view.textColor = AppColor.secondaryText
        view.font = AppFont.bolder
        view.textAlignment = .center
        return view
    }()

    private lazy var waitIcon: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = AppColor.secondaryText
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var hStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [waitIcon, waitText])
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .center
        view.distribution = .fillProportionally
        return view
    }()
}
