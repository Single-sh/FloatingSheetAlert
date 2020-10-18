//
//  FloatingAlertController.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 09.10.2020.
//

import UIKit

public class FloatingAlertController: UIViewController {
//    @IBOutlet private var floatingView: UIView!
//    @IBOutlet private var tableView: UITableView!
//    @IBOutlet private var handleArea: UIView!
    private var floatingView: FloatingCardController!
    
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
        floatingView.tableView.register(UINib(nibName: normalCell, bundle: bundle), forCellReuseIdentifier: normalCell)
        floatingView.tableView.register(UINib(nibName: separatorCell, bundle: bundle), forCellReuseIdentifier: separatorCell)
        floatingView.tableView.register(UINib(nibName: toggleCell, bundle: bundle), forCellReuseIdentifier: toggleCell)
        
        floatingView.tableView.delegate = self
        floatingView.tableView.dataSource = self
    }

    func setupCard() {
        let bounds = UIScreen.main.bounds
        print("width: \(bounds.width), height: \(bounds.height)")
        cardHeight = self.viewModelsCell.height()
        cardWidth = view.bounds.width
        cardOpenPosition = bounds.height - cardHeight
        let bundle = Bundle(for: type(of: self))
        floatingView = FloatingCardController(nibName: "FloatingCardController", bundle: bundle)
        addChild(floatingView)
        self.view.addSubview(floatingView.view)
        floatingView.view.frame = CGRect(x: 0, y: bounds.height, width: cardWidth, height: cardHeight)
        registerCell()
        setProperty()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handleCardPan(recogniser:)))
        floatingView.view.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(panGestureRecognizer)
    }

    func openAnimate() {
        UIView.animate(withDuration: 0.3) {
            self.floatingView.view.frame.origin.y = self.cardOpenPosition
        }
    }

    @objc
    func handleCardPan (recogniser: UIPanGestureRecognizer) {
        switch recogniser.state {
        case .changed:
            let translationY = recogniser.translation(in: self.floatingView.view).y
            let nextPosition = self.floatingView.view.frame.origin.y + translationY
            let movePosition = min(self.view.frame.height, max(nextPosition, self.cardOpenPosition))
            self.floatingView.view.frame.origin.y = movePosition
            recogniser.setTranslation(CGPoint.zero, in: self.floatingView.view)
        case .ended:
            animatedEnded()
        default:
            break
        }
    }

    func animatedEnded() {
        let currentPosition = self.floatingView.view.frame.minY
        var nextPosition: CGFloat
        if currentPosition > (cardOpenPosition + cardHeight / 2) {
            nextPosition = self.view.frame.height
        } else {
            nextPosition = self.cardOpenPosition
        }
        let duration = Double(abs(nextPosition - currentPosition) / (self.cardHeight / 100)) / 100
        UIView.animate(withDuration: duration / 2) {
            self.floatingView.view.frame.origin.y = nextPosition
        } completion: { _ in
            if nextPosition > self.cardOpenPosition {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    private func setProperty() {
        floatingView.view.backgroundColor = theme.backgroundColor
        floatingView.handleView.layer.cornerRadius = 2.5
        
        if #available(iOS 11.0, *) {
            floatingView.view.layer.cornerRadius = theme.cornerRadius
            floatingView.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            floatingView.view.roundCorners(corners: [.topLeft, .topRight], radius: theme.cornerRadius)
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
            cell.configure(with: viewModel)
            return cell
        case let .toggle(viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: toggleCell, for: indexPath) as! FloatingSwitchCell
            cell.configure(with: viewModel)
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
                    self.floatingView.view.frame.origin.y = self.view.frame.height
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
    public init(backgroundColor: UIColor = UIColor.white,
                cornerRadius: CGFloat = 10,
                textFont: UIFont = UIFont.systemFont(ofSize: 17)) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.textFont = textFont
    }
    
    public let backgroundColor: UIColor
    public let cornerRadius: CGFloat
    public var textFont = UIFont.systemFont(ofSize: 17)
    
    static var `default`: Self = .init()
}
 //  private let theme: Theme
