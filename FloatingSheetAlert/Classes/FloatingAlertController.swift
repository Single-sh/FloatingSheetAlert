//
//  FloatingAlertController.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 09.10.2020.
//

import UIKit

public protocol FloatingCellDelegate: FloatingCellDateSource {
    func didSelect()
}

public protocol FloatingCellDateSource {
    func setTitle(icon: UIImage?, title: String)
    func setFontTitle(font: UIFont)
    func setAction(action: Any)
    func hideArrow()
}

extension FloatingCellDateSource {
    func switchState(state: Bool){}
}

public enum FloatingAlertAction {
    case title(icon: UIImage? = nil, title: String)
    case action(icon: UIImage? = nil, title: String, action: () -> Void)
    case actionArrow(icon: UIImage? = nil, title: String, action: () -> Void)
    case actionSwitch(icon: UIImage? = nil, title: String, stateSwitch: Bool = false, action: (UISwitch) -> Void)
    case separator
}

public class FloatingAlertController: UIViewController {
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var handleArea: UIView!
    public var floatingAlert = [FloatingAlertAction]()

    private var cardHeight: CGFloat?
    private var cardOpenPosition: CGFloat?

    public var backgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 10
    public var textFont = UIFont.systemFont(ofSize: 17)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        setProperty()
        floatingView.isHidden = true
        setupCard()
    }
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: "FloatingAlertController", bundle: bundle)
        self.modalPresentationStyle = .overCurrentContext
    }
    func registerCell() {
        let bundle = Bundle(for: type(of: self))
        tableView.register(UINib(nibName: "FloatingAlertCell", bundle: bundle), forCellReuseIdentifier: "floatingAlertCell")
        tableView.register(UINib(nibName: "FloatingSeparatorCell", bundle: bundle), forCellReuseIdentifier: "floatingSeparatorCell")
        tableView.register(UINib(nibName: "FloatingSwitchCell", bundle: bundle), forCellReuseIdentifier: "floatingSwitchCell")
    }

    func setupCard() {
        floatingView.clipsToBounds = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(handleCardPan(recogniser:)))
        floatingView.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(panGestureRecognizer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openAnimate()
        }
    }

    func openAnimate() {

        floatingView.frame.origin.y = self.view.frame.height
        floatingView.layoutIfNeeded()
        self.setCorner()
        floatingView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.floatingView.frame.origin.y = self.view.frame.height - self.floatingView.frame.height
        }
    }

    @objc
    func handleCardPan (recogniser: UIPanGestureRecognizer) {
        switch recogniser.state {
        case .began:
            if cardHeight == nil {
                cardHeight = floatingView.frame.height
                cardOpenPosition = floatingView.frame.origin.y
            }
        case .changed:
            let translationY = recogniser.translation(in: self.floatingView).y
            let nextPosition = self.floatingView.frame.origin.y + translationY
            let movePosition = min(self.view.frame.height, max(nextPosition, self.cardOpenPosition!))
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
        if currentPosition > (cardOpenPosition! + cardHeight! / 2) {
            nextPosition = self.view.frame.height
        } else {
            nextPosition = self.cardOpenPosition!
        }
        let duration = Double(abs(nextPosition - currentPosition) / (self.cardHeight! / 100)) / 100
        UIView.animate(withDuration: duration / 2) {
            self.floatingView.frame.origin.y = nextPosition
        } completion: { _ in
            if nextPosition > self.cardOpenPosition! {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    private func setProperty() {
        floatingView.backgroundColor = backgroundColor
        handleArea.layer.cornerRadius = 2.5
    }

    private func setCorner() {
        floatingView.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
    }
}

extension FloatingAlertController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        floatingAlert.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FloatingCellDateSource
        switch floatingAlert[indexPath.row] {
        case .separator:
            let cell = tableView.dequeueReusableCell(withIdentifier: "floatingSeparatorCell")!
            return cell
        case let .title(icon: icon, title: title):
            cell = tableView.dequeueReusableCell(withIdentifier: "floatingAlertCell") as! FloatingAlertCell
            cell.setTitle(icon: icon, title: title)
            cell.hideArrow()
        case let .action(icon: icon, title: title, action: action):
            cell = tableView.dequeueReusableCell(withIdentifier: "floatingAlertCell") as! FloatingAlertCell
            cell.setTitle(icon: icon, title: title)
            cell.setAction(action: action)
            cell.hideArrow()
        case let .actionArrow(icon: icon, title: title, action: action):
            cell = tableView.dequeueReusableCell(withIdentifier: "floatingAlertCell") as! FloatingAlertCell
            cell.setTitle(icon: icon, title: title)
            cell.setAction(action: action)
        case let .actionSwitch(icon: icon, title: title, stateSwitch: state, action: action):
            cell = tableView.dequeueReusableCell(withIdentifier: "floatingSwitchCell") as! FloatingSwitchCell
            cell.setTitle(icon: icon, title: title)
            cell.switchState(state: state)
            cell.setAction(action: action)
        }
        cell.setFontTitle(font: textFont)
        return cell as! UITableViewCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FloatingCellDelegate {
            UIView.animate(withDuration: 0.3) {
                self.floatingView.frame.origin.y = self.view.frame.height
            } completion: { _ in
                self.dismiss(animated: false) {
                    cell.didSelect()
                }
            }
        }
    }
}
