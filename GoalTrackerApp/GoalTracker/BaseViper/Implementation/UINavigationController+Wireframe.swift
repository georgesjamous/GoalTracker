import UIKit

extension UINavigationController {
    /// Helper function to push a wireframe
    /// - Parameter wireframe: The wireframe to push
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    /// Helper function to set root wireframes
    /// - Parameter wireframe: The wireframe to set as root
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
}
