//
//  Scrollable.swift
//  Swifty
//
//  Created by chanhbv on 10/9/24.
//

import Foundation
import UIKit

public protocol ScrollableView {
    var scrollView: UIScrollView { get set }
    var containerView: UIView { get set }

    func makeViewScrollable(subViews: [UIView], constant: CGFloat) -> [NSLayoutConstraint]
}

public extension ScrollableView where Self: UIViewController {
    func makeViewScrollable(subViews: [UIView], constant _: CGFloat = 40) -> [NSLayoutConstraint] {
        var screenConstraints = [NSLayoutConstraint]()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        for subView in subViews {
            subView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(subView)
        }
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)

        let svContentG = scrollView.contentLayoutGuide
        let svFrameG = scrollView.frameLayoutGuide

        screenConstraints.append(contentsOf: [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: svContentG.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: svContentG.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: svFrameG.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: svFrameG.heightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        return screenConstraints
    }
}
