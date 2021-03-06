import UIKit

protocol WireframeInterface: class {
    var viewController: UIViewController { get }
    /// The wireframe's internal ViewController's navigation controller
    var navigationController: UINavigationController? { get }
}
