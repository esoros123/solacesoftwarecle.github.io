import Foundation
import UIKit
import SwiftUI

extension UIView {
    var isDarkMode: Bool {
        return self.traitCollection.userInterfaceStyle == .dark
    }
}

class HomeScreenView: UIView {
    weak var viewController: UIViewController?
    var label  = UILabel.init()
    var sudoku = UILabel.init()
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
                
        let symbolImage = UIImage(systemName: "sun.min")
        let imageView = UIImageView(image: symbolImage);
        imageView.tintColor = .orange
        imageView.center.x = self.center.x
        imageView.tag = 1
        super.addSubview(imageView)
        
        label = UILabel()
        label.text = "Crossword Sudoku"
        label.font = UIFont.systemFont(ofSize: 20)
        super.addSubview(label)
        
        sudoku = UILabel()
        sudoku.text = "Sudoku"
        sudoku.font = UIFont.systemFont(ofSize: 20)
        //super.addSubview(sudoku)
        
        let newGame = UIButton()
        newGame.backgroundColor = .systemBlue
        newGame.tag = 2
        newGame.layer.cornerRadius = 5.0
        newGame.setTitle("New Game", for: .normal)
        newGame.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        newGame.setTitleColor(.white, for: .normal)
        newGame.addTarget(viewController, action: #selector(ViewController.onNewGame), for: .touchUpInside)
        
        let load = UIButton()
        load.backgroundColor = .systemMint
        load.layer.cornerRadius = 5.0
        load.tag = 3
        load.setTitle("Load Game", for: .normal)
        load.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        load.setTitleColor(.white, for: .normal)
        load.addTarget(viewController, action: #selector(ViewController.onLoadGame), for: .touchUpInside)
        
        let sb = UIButton()
        sb.backgroundColor = .systemPurple
        sb.tag = 4
        sb.layer.cornerRadius = 5.0
        sb.setTitle("Scoreboard", for: .normal)
        sb.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sb.setTitleColor(.white, for: .normal)
        sb.addTarget(viewController, action: #selector(ViewController.onScoreboard), for: .touchUpInside)
        
        let create = UIButton()
        create.tag = 5
        create.layer.cornerRadius = 5.0
        create.setTitle("Create", for: .normal)
        create.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        create.backgroundColor = .systemOrange
        create.setTitleColor(.white, for: .normal)
        create.addTarget(viewController, action: #selector(ViewController.onPuzzleCreate), for: .touchDown)
        
        let learn = UIButton()
        learn.tag = 6
        learn.layer.cornerRadius = 5.0
        learn.setTitle("Learn", for: .normal)
        learn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        learn.backgroundColor = .systemPink
        learn.setTitleColor(.white, for: .normal)
        learn.addTarget(viewController, action: #selector(ViewController.onLearn), for: .touchDown)
        
        let configure = UIButton()
        configure.tag = 7
        configure.layer.cornerRadius = 5.0
        configure.setTitle("Configure", for: .normal)
        configure.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        configure.backgroundColor = .systemYellow
        configure.setTitleColor(.white, for: .normal)
        configure.addTarget(viewController, action: #selector(ViewController.xxconfigure), for: .touchDown)
        
        if(isDarkMode) {
            darkmode()
        } else {
            lightMode()
        }
        
        super.addSubview(newGame); 
        super.addSubview(load);
        super.addSubview(sb);
        super.addSubview(create);
        super.addSubview(learn);
        super.addSubview(configure);
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
        
    private func portrait() {
        let f : CGRect = frame
        let start = f.height/2 - 50
        _ = self.viewWithTag(101)
        let image = self.viewWithTag(1); let newGame = self.viewWithTag(2); let load = self.viewWithTag(3); let sb = self.viewWithTag(4)
        let byop = self.viewWithTag(5);  let learn = self.viewWithTag(6); let config = self.viewWithTag(7);
        
        let labelSize = getLabelSize(label: label, char: label.text!)
        let sudokySize = getLabelSize(label: sudoku, char: sudoku.text!)
        label.frame = .init(x: frame.width/2 - (labelSize.width/2), y: 50, width: labelSize.width, height: 200)
        sudoku.frame = .init(x: label.frame.minX + 100, y: label.frame.minY, width: 200, height: 200)
        
        let loadx : CGFloat = f.width/2 - 150
        newGame?.frame = .init(origin: .init(x: loadx, y: start + 30), size: .init(width: 300, height: 50))
        load?.frame = .init(origin: .init(x: loadx, y: newGame!.frame.maxY + 5), size: .init(width: 300, height: 50))
        sb?.frame = .init(origin: .init(x: loadx, y: load!.frame.maxY + 5), size: .init(width: 300, height: 50))
        image?.frame = .init(x: 0, y: newGame!.frame.minY - 130, width: 100, height: 100); image?.center.x = self.center.x
        byop?.frame = .init(origin: .init(x: loadx, y: sb!.frame.maxY + 5), size: .init(width: 300, height: 50))
        learn?.frame = .init(origin: .init(x: loadx, y: byop!.frame.maxY + 5), size: .init(width: 300, height: 50))
        config?.frame = .init(origin: .init(x: loadx, y: learn!.frame.maxY + 5), size: .init(width: 300, height: 50))
    }
    
    private func landscape() {
        _ = self.viewWithTag(100)
        let image = self.viewWithTag(1); let newGame = self.viewWithTag(2); let load = self.viewWithTag(3); let sb = self.viewWithTag(4)
        let byop = self.viewWithTag(5); let learn = self.viewWithTag(6); let config = self.viewWithTag(7);
        let starty = CGFloat(20)
        
        label.frame = .init(x: 60, y: frame.height/2 - 60, width: 200, height: 100)
        sudoku.frame = .init(x: 80, y: label.frame.minY + 30, width: 200, height: 100)
        
        sb?.frame = .init(x: frame.width - (120) - (frame.width/12), y: starty + 60 + 60, width: 120, height: 50)
        load?.frame = .init(x: frame.width - (120)  - (frame.width/12), y: starty + 60, width: 120, height: 50)
        newGame?.frame = .init(x: frame.width - (120)  - (frame.width/12), y: starty, width: 120, height: 50)
        byop?.frame = .init(x: frame.width - (120)  - (frame.width/12), y: starty + 60 + 60 + 60, width: 120, height: 50)
        image!.frame = .init(x: center.x - 50, y: center.y - 50, width: 100, height: 100)
        learn!.frame = .init(x: frame.width - (120) - (frame.width/12), y:  (byop?.frame.maxY)! + 10, width: 120, height: 50)
        config?.frame = .init(origin: .init(x: frame.width - (120)  - (frame.width/12), y: learn!.frame.maxY + 10), size: .init(width: 120, height: 50))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class ViewController: UIViewController {
    private var vi: HomeScreenView?
        
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
    
    @objc func xxconfigure() {
        let viewController = ConfigurationViewController()
        self.view.window?.rootViewController = viewController
    }
    
    @objc func gameOver() {
        let viewController = GameOverViewController()
        self.view.window?.rootViewController = viewController
    }
    
    @objc func onLearn() {
        let viewController = LearnViewController()
        self.view.window?.rootViewController = viewController
    }
    
    @objc func onNewGame() {
        let viewController = DifficultyScreenViewController()
        self.view.window?.rootViewController = viewController
    }
    
    @objc func onPuzzleCreate() {
        let viewController = BuildYourOwnPuzzleViewController()
        self.view.window?.rootViewController = viewController
    }
    
    @objc func onScoreboard() {
        let viewController = ScoreboardViewController()
        self.view.window?.rootViewController = viewController
    }
    
    @objc func onLoadGame() {
        let viewController = LoadGamesViewController()
        self.view.window?.rootViewController = viewController
    }
        
    override func viewDidLoad() {
        let v = HomeScreenView(frame: self.view.frame)
        v.viewController = self
        self.view = v
        vi = v
    }
}

#Preview() {
    ViewController()
}

