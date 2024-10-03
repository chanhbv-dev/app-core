//
//  ViewControllerType.swift
//  Swifty
//
//  Created by chanhbv on 10/9/24.
//

import Combine
import Foundation
import UIKit

open class ViewControllerType<M: ViewModelType>: UIViewController {
    open var screenBackground: String?
    public var constraints: [NSLayoutConstraint] = []
    public var subscriptions: Set<AnyCancellable> = []
    public var behaviors: [ViewControllerBehavior] = .init()
    public var viewModel: M

    public var loadingConstraints: [NSLayoutConstraint] = []
    public lazy var loadingView: LoadingView = .init(
        loadingIcon: UIImage(named: "thantai"),
        loadingTitle: "Chờ chút nhé!"
    )

    // MARK: - ViewController lifecyle

    public let viewWillAppear: PassthroughSubject<Void, Never> = .init()
    public let viewDidAppear: PassthroughSubject<Void, Never> = .init()
    public let viewWillDisappear: PassthroughSubject<Void, Never> = .init()
    public let viewDidDisappear: PassthroughSubject<Void, Never> = .init()

    public init(viewModel: M) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configBehaviors()
        bindViewModel()
        for behavior in behaviors {
            behavior.viewDidLoad(viewController: self)
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for behavior in behaviors {
            behavior.viewWillAppear(viewController: self)
        }
        viewWillAppear.send(())
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for behavior in behaviors {
            behavior.viewDidAppear(viewController: self)
        }
        viewDidAppear.send(())
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for behavior in behaviors {
            behavior.viewWillDisappear(viewController: self)
        }
        viewWillDisappear.send(())
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for behavior in behaviors {
            behavior.viewDidDisappear(viewController: self)
        }
        viewDidDisappear.send(())
    }

    // MARK: - ViewController Behaviors

    public func dismissKeyboardBehaviors() {
        behaviors.append(ViewControllerDismissKeyboardBehavior())
    }

    public func tranparentNavigationBar() {
        behaviors.append(ViewControllerTransparentBehavior())
    }

    public func dealingWithKeyboard() {
        behaviors.append(ViewControllerDealingKeyboardBehavior())
    }

    // MARK: - Customize implementation

    private func setupViews() {
        if let screenBackground, let contents = UIImage(named: screenBackground)?.cgImage {
            view.layer.contents = contents
        } else {
            view.backgroundColor = AppColor.white
        }
        configNavigator()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(constraints)
        constraints = autolayout()
        NSLayoutConstraint.activate(constraints)
        view.updateConstraintsIfNeeded()
    }

    // Default configuration
    open func configNavigator() {
        if let navigationController {
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.navigationBar.topItem?.title = ""
            navigationController.navigationBar.tintColor = AppColor.primary
        }
    }

    open func autolayout() -> [NSLayoutConstraint] {
        []
    }

    open func configBehaviors() {}
    open func bindViewModel() {}

    // MARK: - Scrollable

    open lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()

    open lazy var containerView = UIView()

    deinit {
        print("\(String(describing: Self.self)) deinit")
    }
}

extension ViewControllerType: ScrollableView {}

public extension ViewControllerType {
    func handleError(_ error: AnyPublisher<Error, Never>) {
        error.receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.alertMsg(title: "Có lỗi xảy ra", message: error.localizedDescription)
            }.store(in: &subscriptions)
    }

    func alertMsg(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: false)
            })
        )
        present(alert, animated: true, completion: nil)
    }

    func bindLoading(_ isLoading: AnyPublisher<Bool, Never>) {
        isLoading.receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.startLoading() : self?.stopLoading()
            }.store(in: &subscriptions)
    }

    func startLoading(with loadingMode: LoadingView.LoadingMode = .crossDissolve) {
        view.isUserInteractionEnabled = false
        if loadingView.loadingMode != loadingMode {
            loadingView.loadingMode = loadingMode
        }

        if !loadingView.isDescendant(of: view) {
            view.addSubview(loadingView)
        }
        NSLayoutConstraint.deactivate(loadingConstraints)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingConstraints = [
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(loadingConstraints)
        loadingView.startLoading()
    }

    func stopLoading() {
        loadingView.stopLoading()
        NSLayoutConstraint.deactivate(loadingConstraints)
        loadingView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }

    func alert(title: String, message: String, type: AlertViewController.AlertType = .info, completion: @escaping AlertViewController.CompletionAction) {
        let alert = AlertViewController(
            title: title,
            message: message,
            type: type
        )
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        alert.completion = completion
        present(alert, animated: true)
    }
}
