
enum ViewModelCell {
    case separator
    case toggle(viewModel: ViewModelToggle)
    case normal(viewModel: ViewModelNormal)
}

extension Array where Element == ViewModelCell {
    func height() -> CGFloat {
        var height: CGFloat = 59
        forEach { (model) in
            switch model {
            case .separator:
                height += 6
            default:
                height += 48
            }
        }
        return height
    }
}

public enum FloatingAlertAction {
    case title(icon: UIImage? = nil, title: String)
    case normal(icon: UIImage? = nil, title: String, isDismiss: Bool = true, onTap: () -> Void)
    case normalArrow(icon: UIImage? = nil, title: String, isDismiss: Bool = true, onTap: () -> Void)
    case toggle(icon: UIImage? = nil, title: String, isOn: Bool = false, isDisabled: Bool = false, onToggle: (Bool) -> Void)
    case separator
}

extension Array where Element == FloatingAlertAction {
    func getViewModelCell() -> [ViewModelCell]{
        var array = [ViewModelCell]()
        forEach { (alertAction) in
            switch alertAction {
            case let .title(icon, title):
                array.append(.normal(viewModel: ViewModelNormal(image: icon, title: title, hasArrow: false, isDismiss: false, onTap: nil)))
            case let .normal(icon, title, isDismiss, onTap):
                array.append(.normal(viewModel: ViewModelNormal(image: icon, title: title, hasArrow: false, isDismiss: isDismiss, onTap: onTap)))
            case let .normalArrow(icon, title, isDismiss, onTap):
                array.append(.normal(viewModel: ViewModelNormal(image: icon, title: title, hasArrow: true, isDismiss: isDismiss, onTap: onTap)))
            case let .toggle(icon, title, isOn, isDisabled, onToggle):
                array.append(.toggle(viewModel: ViewModelToggle(image: icon, title: title, isOn: isOn, isDisabled: isDisabled, onToggle: onToggle)))
            case .separator:
                array.append(.separator)
            }
        }
        return array
    }
}

