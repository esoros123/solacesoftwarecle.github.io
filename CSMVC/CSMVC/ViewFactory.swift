import Foundation
import UIKit

class ViewFactory {
    func createSudokuView(frame: CGRect) -> SudokuView {
        var w = 0.0; var h = 0.0;
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            w = windowScene.screen.bounds.width
            h = windowScene.screen.bounds.height
        }
        
        if( doubleEquals(w, 667) || doubleEquals(w, 375) && doubleEquals(h, 375) || doubleEquals(h, 667) ) {
            print("se")
            let s = SudokuViewSE.init(frame: frame)
            return s
        } else {
            print("non se")
            let s = SudokuView.init(frame: frame)
            return s
        }
    }
    
    func doubleEquals(_ expected: Double, _ actual: Double) -> Bool {
        return abs(actual - expected) < 1.0;
    }
    
    func createMathFacts(frame: CGRect) -> MathFacts  {
        var w = 0.0; var h = 0.0;
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            w = windowScene.screen.bounds.width
            h = windowScene.screen.bounds.height
        }
        
        if( doubleEquals(w, 667) || doubleEquals(w, 375) && doubleEquals(h, 375) || doubleEquals(h, 667) ) {
            let s = MathFactsSE.init(frame: frame)
            return s
        } else {
            let s = MathFacts.init(frame: frame)
            return s
        }
    }
    
    func createCrosswordScreen(frame: CGRect) -> CrosswordScreen {
        var w = 0.0; var h = 0.0;

        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            w = windowScene.screen.bounds.width
            h = windowScene.screen.bounds.height
        }
        
        if( doubleEquals(w, 667) || doubleEquals(w, 375) && doubleEquals(h, 375) || doubleEquals(h, 667) ) {
            print("se")
            let s = CrosswordScreenSE.init(frame: frame)
            return s
        } else {
            print("non se")
            let s = CrosswordScreen.init(frame: frame)
            return s
        }
    }
}
