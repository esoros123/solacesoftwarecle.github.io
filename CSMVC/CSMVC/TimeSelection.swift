import Foundation
import UIKit

var time_selection = 0

class TimeSelectionView: UIView {
    weak var viewController: UIViewController?
    private var times = [10,20,30,40,50,60]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Please Select Time Limit"
        label.tag = 1
        super.addSubview(label)
        
        let backButton = UIButton()
        backButton.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        
        let image = UIImage(systemName: "chevron.left")
        backButton.setImage(image, for: .normal)
        backButton.addTarget(viewController, action: #selector(TmeSelectionViewController.onBackButtonPress), for: .touchUpInside)
        backButton.tintColor = .systemOrange
        super.addSubview(backButton)
        
        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
    }
    
    func darkmode() {
        backgroundColor = .black
    }
    
    func lightmode() {
        backgroundColor = .white
    }
    
    func renderTimes(times: [Int]) {
        let color = [UIColor.systemBlue, UIColor.systemRed, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemTeal, UIColor.systemYellow]
        var start_y = 200
        var index = 0
        let startTag = 20
        times.forEach { t in
            let button = UIButton.init(frame: .init(x: 100, y: start_y, width: Int(self.frame.width/2), height: 70))
            button.setTitle(t.description + " minutes", for: .normal)
            button.tag = startTag + index
            button.backgroundColor = color[index]
            button.layer.cornerRadius = 5.0
            button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(onTimeSelect), for: .touchUpInside)
            super.addSubview(button)
            start_y += 80
            index += 1
        }
                
        if(frame.width > frame.height) {
            landscape()
        } else {
            portrait()
        }
    }
    
    private func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    func portrait() {
        var start_y = Int(frame.width/2.75)
        var index = 0
        let startTag = 20
        times.forEach { t in
            let button = viewWithTag(startTag + index)!
            button.frame = .init(x: 100, y: start_y, width: Int(self.frame.width/2), height: 70)
            start_y += 80
            index += 1
        }
        
        let label = viewWithTag(1) as! UILabel
        let width = getLabelSize(label: label, char: label.text!)
        label.frame = .init(x: frame.width/2 - (width.width/2), y: frame.height / 7.5, width: width.width, height: 25)
    }
    
    func landscape() {
        let label = viewWithTag(1)
        let ten = viewWithTag(20); let twen = viewWithTag(21); let thri = viewWithTag(22);
        let fort = viewWithTag(23); let five = viewWithTag(24); let six = viewWithTag(25);
        
        label?.frame = .init(x: frame.width/13, y: frame.height/2 - 25, width: 200, height: 25)
        ten?.frame = .init(x: frame.width - 400, y: 100, width: 150, height: 50)
        twen?.frame = .init(x: frame.width - 400, y: 160, width: 150, height: 50)
        thri?.frame =  .init(x: frame.width - 400, y: 220, width: 150, height: 50)
        fort?.frame = .init(x: frame.width - 225, y: 100, width: 150, height: 50)
        five?.frame = .init(x: frame.width - 225, y: 160, width: 150, height: 50)
        six?.frame =  .init(x: frame.width - 225, y: 220, width: 150, height: 50)
    }
    
    @objc func onTimeSelect(button: UIButton) {
        if let vc = viewController as? TmeSelectionViewController {
            vc.onTimeSelect(button: button)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class TmeSelectionViewController: UIViewController {
    private var vi: TimeSelectionView?

    @objc func onBackButtonPress() {
        let vc = GameModeViewController()
        self.view.window?.rootViewController = vc
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        if(size.width > size.height) {
            coordinator.animate(alongsideTransition: { _ in
                self.vi?.landscape()
            }, completion: { _ in
            })
        } else {
            coordinator.animate(alongsideTransition: { _ in
                self.vi?.portrait()
            }, completion: { _ in
            })
        }
    }
    
    @objc func onTimeSelectDebug(button: UIButton) {
        time_selection = 10
        let vc = CrosswordScreenViewController()
        self.view.window?.rootViewController = vc
    }
    
    func onTimeSelect(button: UIButton) {
        let num = Int(button.titleLabel!.text!.prefix(2))!
        time_selection = num  * 60
        let vc = CrosswordScreenViewController()
        self.view.window?.rootViewController = vc
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                vi?.darkmode()
            } else {
                vi?.lightmode()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = TimeSelectionView(frame: self.view.frame)
        v.viewController = self
        self.vi = v
        self.view = v
        
        let times = [10,20,30,40,50,60]
        v.renderTimes(times: times)
    }
}
