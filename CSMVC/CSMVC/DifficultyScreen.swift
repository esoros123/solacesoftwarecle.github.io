import Foundation
import UIKit

var difficulty = 0

class DifficultyScreenView: UIView {
    weak var viewController: UIViewController?
    var backButton = UIButton.init()
    var easy = UIButton.init()
    var medium = UIButton.init()
    var hard = UIButton.init()
    var img = UIImageView.init()
    var zero = CGRect.zero
    var text = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        
        text = UILabel()
        text.text = "Select Your Difficulty"
        super.addSubview(text)
        
        let i = UIImage(systemName: "moonphase.last.quarter.inverse")
        img = UIImageView(image: i)
        img.tag = 1
        
        backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(viewController, action: #selector(DifficultyScreenViewController.onBackButtonPress), for: .touchUpInside)
        backButton.tintColor = .systemOrange
        backButton.tag = 10
        
        easy = UIButton()
        easy.tag = 2
        easy.setTitle("easy", for: .normal)
        easy.addTarget(viewController, action: #selector(DifficultyScreenViewController.onDifficulty), for: .touchUpInside)
        easy.backgroundColor = .systemGreen
        easy.layer.cornerRadius = 5.0
        easy.titleLabel!.font = UIFont.systemFont(ofSize: 14)

        medium = UIButton()
        medium.tag = 3
        medium.setTitle("medium", for: .normal)
        medium.addTarget(viewController, action: #selector(DifficultyScreenViewController.onDifficulty), for: .touchUpInside)
        medium.backgroundColor = .systemYellow
        medium.layer.cornerRadius = 5.0
        medium.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        
        hard = UIButton()
        hard.tag = 4
        hard.setTitle("hard", for: .normal)
        hard.addTarget(viewController, action: #selector(DifficultyScreenViewController.onDifficulty), for: .touchUpInside)
        hard.backgroundColor = .systemRed
        hard.layer.cornerRadius = 5.0
        hard.titleLabel!.font = UIFont.systemFont(ofSize: 14)

        if(isDarkMode) {
            darkmode()
        } else {
            lightMode()
        }
        
        super.addSubview(img)
        super.addSubview(backButton)
        super.addSubview(easy)
        super.addSubview(medium)
        super.addSubview(hard)
    }
    
    func lightMode() {
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
        backButton.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        medium.frame = .init(x: frame.width/2 - 125 + 45, y: (frame.height/2) - 50, width: 100, height: 100)
        hard.frame = .init(x: medium.frame.minX + 105, y: (frame.height/2) - 50, width: 100, height: 100)
        easy.frame = .init(x: medium.frame.minX - 105, y: (frame.height/2) - 50, width: 100, height: 100)
        text.frame = .init(x: frame.width/2 - 125 + 45, y: easy.frame.minY - 100, width: 200, height: 100)
        text.center.x = center.x
    }
    
    func portrait() {        
        backButton.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        medium.frame = .init(x: frame.width/2 - 125, y: (frame.height/2) - 30, width: 250, height: 60)
        hard.frame = .init(x: frame.width/2 - 125, y: medium.frame.maxY + 5, width: 250, height: 60)
        easy.frame = .init(x: frame.width/2 - 125, y: medium.frame.minY - 65, width: 250, height: 60)
        text.frame = .init(x: frame.width/2 - 125 + 45, y: easy.frame.minY - 200, width: 200, height: 100)
        text.center.x = center.x + 10
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class DifficultyScreenViewController: UIViewController {
    private var vi: DifficultyScreenView?
    
    @objc func onBackButtonPress() {
        let view = ViewController()
        self.view.window?.rootViewController = view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                vi?.darkmode()
            } else {
                vi?.lightMode()
            }
        }
    }
        
    @objc func onDifficulty(button: UIButton) {
        difficulty = button.tag
        let vc = GameModeViewController()
        view.window?.rootViewController = vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ellapsedTime = 0
        let v = DifficultyScreenView(frame: self.view.frame)
        v.viewController = self
        self.view = v
        self.vi = v
    }
}

