import Foundation
import UIKit

class MathFactsSE: MathFacts {
    override func layoutSubviews() {
        label.center = CGPoint(x: bounds.midX, y: bounds.midY + 100)
    }
}
