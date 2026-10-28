import Foundation
import UIKit

var gameMode = 0

//making object pools for all of these

class GameModeView: UIView {
    weak var viewController: UIViewController?
    var backButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(viewController, action: #selector(GameModeViewController.onBackButton), for: .touchUpInside)
        backButton.tintColor = .systemOrange
        backButton.tag = 20
        super.addSubview(backButton)
        
        let title = UILabel()
        title.text = "Game Mode Selection"
        super.addSubview(title)
        
        let i = UIImage(systemName: "moonphase.last.quarter.inverse")
        let img = UIImageView(image: i)
        img.tag = 10
        super.addSubview(img)
        
        let b = UIButton()
        b.setTitle("Free Play", for: .normal)
        b.tag = 1
        b.addTarget(viewController, action: #selector(GameModeViewController.onModeSelect), for: .touchUpInside)
        b.backgroundColor = .systemOrange
        b.layer.cornerRadius = 5.0
        b.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        
        let z = UIButton()
        z.setTitle("Timed Attack!", for: .normal)
        z.tag = 2
        z.addTarget(viewController, action: #selector(GameModeViewController.onModeSelect), for: .touchUpInside)
        z.backgroundColor = .systemPurple
        z.layer.cornerRadius = 5.0
        z.titleLabel!.font = UIFont.systemFont(ofSize: 14)

        if(isDarkMode) {
            darkmode()
        } else {
            lightmode()
        }
        
        super.addSubview(b)
        super.addSubview(z)
    }
    
    func lightmode() {
        backgroundColor = .white
    }
    
    func darkmode() {
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        if(frame.width > frame.height) {
            landscape()
        } else {
            portrait()
        }
    }
    
    func landscape() {
        let img = viewWithTag(10); let freePlay = viewWithTag(1); let time = viewWithTag(2)
        let starty : CGFloat = 160
        
        let backButton = viewWithTag(20)
        
        backButton?.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        img?.frame = .init(x: 200, y: 125, width: 150, height: 150)
        freePlay?.frame = .init(x: frame.width - 300 , y: starty, width: 150, height: 50)
        time?.frame = .init(x: frame.width - 300 , y: starty + 60, width: 150, height: 50)
    }
    
    func portrait() {
        let img = viewWithTag(10); let freePlay = viewWithTag(1); let time = viewWithTag(2)
        let backButton = viewWithTag(20)
        
        backButton?.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        img!.frame = .init(x: 0, y: 200, width: 100, height: 100); img!.center.x = center.x;
        time!.frame = .init(x: frame.width/2 - 100, y: frame.height/2 - 20 + 55, width: 200, height: 40)
        freePlay!.frame = .init(x: frame.width/2 - 100, y: frame.height/2 - 20 + 10, width: 200, height: 40)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class GameModeViewController: UIViewController {
    private var vi: GameModeView?

    @objc func onBackButton() {
        let vc = DifficultyScreenViewController()
        view.window?.rootViewController = vc
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
    
    @objc func onModeSelect(button: UIButton) {
        gameMode = button.tag
        if(gameMode == 1) {
            let vc = SudokuViewController()
            view.window?.rootViewController = vc
        } else {
            let vc = TmeSelectionViewController()
            view.window?.rootViewController = vc
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = GameModeView(frame: self.view.frame)
        v.viewController = self
        self.view = v
        self.vi = v
    }
}

