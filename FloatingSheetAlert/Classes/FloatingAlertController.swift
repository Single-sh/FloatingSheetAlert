//
//  FloatingAlertController.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 09.10.2020.
//

import UIKit

public class FloatingAlertController: UIViewController {
    @IBOutlet private var floatingView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var handleArea: UIView!
    
    private var theme: FloatingSheetTheme = .default
    private var viewModelsCell = [ViewModelCell]()
    
    private var cardHeight: CGFloat = 0
    private var cardWidth: CGFloat = 0
    private var cardOpenPosition: CGFloat = 0
    
    private let normalCell = "FloatingAlertCell"
    private let toggleCell = "FloatingSwitchCell"
    private let separatorCell = "FloatingSeparatorCell"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openAnimate()
    }
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: "FloatingAlertController", bundle: bundle)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public func setActions(_ actions: [FloatingAlertAction]){
        self.viewModelsCell = actions.getViewModelCell()
    }
    
    func registerCell() {
        let bundle = Bundle(for: type(of: self))
        tableView.register(UINib(nibName: normalCell, bundle: bundle), forCellReuseIdentifier: normalCell)
        tableView.register(UINib(nibName: separatorCell, bundle: bundle), forCellReuseIdentifier: separatorCell)
        tableView.register(UINib(nibName: toggleCell, bundle: bundle), forCellReuseIdentifier: toggleCell)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupCard() {
        let bounds = UIScreen.main.bounds
        cardHeight = self.viewModelsCell.height()
        cardWidth = view.bounds.width
        cardOpenPosition = bounds.height - cardHeight
        floatingView.frame = CGRect(x: 0, y: bounds.height, width: cardWidth, height: cardHeight)
        registerCell()
        setProperty()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handleCardPan(recogniser:)))
        floatingView.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(panGestureRecognizer)
    }

    func openAnimate() {
        UIView.animate(withDuration: 0.3) {
            self.floatingView.frame.origin.y = self.cardOpenPosition
        }
    }

    @objc
    func handleCardPan (recogniser: UIPanGestureRecognizer) {
        switch recogniser.state {
        case .changed:
            let translationY = recogniser.translation(in: self.floatingView).y
            let nextPosition = self.floatingView.frame.origin.y + translationY
            let movePosition = min(self.view.frame.height, max(nextPosition, self.cardOpenPosition))
            self.floatingView.frame.origin.y = movePosition
            recogniser.setTranslation(CGPoint.zero, in: self.floatingView)
        case .ended:
            animatedEnded()
        default:
            break
        }
    }

    func animatedEnded() {
        let currentPosition = self.floatingView.frame.minY
        var nextPosition: CGFloat
        if currentPosition > (cardOpenPosition + cardHeight / 2) {
            nextPosition = self.view.frame.height
        } else {
            nextPosition = self.cardOpenPosition
        }
        let duration = Double(abs(nextPosition - currentPosition) / (self.cardHeight / 100)) / 100
        UIView.animate(withDuration: duration / 2) {
            self.floatingView.frame.origin.y = nextPosition
        } completion: { _ in
            if nextPosition > self.cardOpenPosition {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    private func setProperty() {
        floatingView.backgroundColor = theme.backgroundColor
        handleArea.layer.cornerRadius = 2.5
        
        if #available(iOS 11.0, *) {
            floatingView.layer.cornerRadius = theme.cornerRadius
            floatingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            floatingView.roundCorners(corners: [.topLeft, .topRight], radius: theme.cornerRadius)
        }
    }
}

extension FloatingAlertController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModelsCell.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModelsCell[indexPath.row] {
        case let .normal(viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: normalCell, for: indexPath) as! FloatingAlertCell
            cell.configure(with: viewModel, theme: theme)
            return cell
        case let .toggle(viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: toggleCell, for: indexPath) as! FloatingSwitchCell
            cell.configure(with: viewModel, theme: theme)
            return cell
        case .separator:
            let cell = tableView.dequeueReusableCell(withIdentifier: separatorCell, for: indexPath)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModelsCell[indexPath.row] {
        case let .normal(viewModel):
            if(viewModel.isDismiss){
                UIView.animate(withDuration: 0.3) {
                    self.floatingView.frame.origin.y = self.view.frame.height
                } completion: { _ in
                    self.dismiss(animated: false) {
                        viewModel.onTap?()
                    }
                }
            } else {
                viewModel.onTap?()
            }
        default:
            return
        }
    }
}

public struct FloatingSheetTheme {
    public init(backgroundColor: UIColor = .white,
                cornerRadius: CGFloat = 10,
                textFont: UIFont = .systemFont(ofSize: 17),
                textColor: UIColor = .black) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.textFont = textFont
        self.textColor = textColor
    }
    
    public let backgroundColor: UIColor
    public let cornerRadius: CGFloat
    public let textFont: UIFont
    public let textColor: UIColor
    
    static var `default`: Self = .init()
}
