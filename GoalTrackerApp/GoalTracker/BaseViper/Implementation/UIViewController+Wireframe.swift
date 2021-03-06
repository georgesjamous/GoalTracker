import UIKit

extension UIViewController {
    /// Helper function to present a wireframe
    /// - Parameter wireframe: The wireframe to present
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
}
