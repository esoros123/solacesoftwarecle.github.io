import Foundation
import UIKit

struct GameData : Codable {
    var id: Int
    var name: String
    var level: Int
    var time: Int
    var type: String
    var gameData: String
}

class CustomScrollView : UIScrollView {
    weak var viewController: LoadGamesViewController?
    
    func lightmode() {
        super.backgroundColor = .white
    }
    
    func darkmode() {
        super.backgroundColor = .black
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let pos = touches.first!.location(in: self)
        if(!self.isDragging) {
            subviews.forEach { f in
                if(f is UIButton) {
                    if(pos.y > f.frame.minY && pos.y < f.frame.maxY && pos.x > f.frame.minX &&  pos.x < f.frame.maxX) {
                        if((f as! UIButton).title(for: .normal)! == "Remove") {
                            viewController?.onRemoveGame(button: f as! UIButton)
                        } else {
                            viewController?.onLoadGame(button: f as! UIButton)
                        }
                    }
                }
            }
        }
    }
}

class LoadGamesView: UIView {
    weak var viewController: UIViewController?
    var games: [SaveDataMetadata] = []
    var label: UILabel = .init()
    var select: [UIView] = []
    var remove: [UIView] = []
    var scrollView: CustomScrollView = .init()
    var backButton: UIButton = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
        super.addSubview(label)
        
        backButton.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        backButton.addTarget(viewController, action: #selector(LoadGamesViewController.onBackButtonPress), for: .touchUpInside)
        let largeBoldDoc = UIImage(systemName: "chevron.left")
        backButton.tintColor = .systemOrange
        backButton.setImage(largeBoldDoc, for: .normal)
        super.addSubview(backButton)
        
        scrollView = CustomScrollView()
        super.addSubview(scrollView)
        
        if(isDarkMode) {
            darkmode()
            scrollView.darkmode()
        } else {
            lightmode()
            scrollView.lightmode()
        }
    }
    
    func lightmode() {
        backgroundColor = .white
        scrollView.lightmode()
    }
    
    func darkmode() {
        backgroundColor = .black
        scrollView.darkmode()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        if(games.count == 0) {
            layoutGamesNotfound()
        } else {
            layoutGamesFound()
        }
    }
    
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    func layoutGamesNotfound() {
        label.text = "No Games Found"
        let size = getLabelSize(label: label, char: label.text!)
        label.frame = .init(x:frame.width/2 - size.width/2 , y: frame.height/2 - size.height/2, width: size.width, height: size.height);
    }
    
    func layoutGamesFound() {
        if(select.count == 0) {
            return
        }
        
        let ystart = frame.width > frame.height ? 40: 60
        label.frame = .init(x:0 , y: ystart, width: 150, height: 25);
        label.center.x = center.x
        
        if(games.count == 1) {
            label.text = "1 Game Found"
        } else {
            label.text = String(games.count) + " Games Found"
        }
        
        backButton.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        scrollView.contentSize = .init(width: Int(frame.width), height: games.count * 100)
        scrollView.frame = .init(x: 0, y: CGFloat(ystart + 30), width: frame.width, height: frame.height)
        
        var index = 0
        var y_start = 5.0
        let width : CGFloat = frame.width/2
        select.forEach { g in
            select[index].frame = .init(x: 10, y: y_start, width: width - 20, height: 50)
            remove[index].frame = .init(x: width, y: y_start, width: width - 20, height: 50)
            index += 1
            y_start += 55
        }
    }
    
    func removeGame(id: Int) {
        let button1 = select.first { g in
            g.tag == id
        }
        let button2 = remove.first { g in
            g.tag == id
        }
        button1?.removeFromSuperview()
        button2?.removeFromSuperview()
        select.removeAll { g in
            g.tag == id
        }
        remove.removeAll { g in
            g.tag == id
        }
        
        games.removeAll { g in
            g.id == id
        }
        self.addSubview(label)
        setNeedsLayout()
    }
                
    func renderGames(games: [SaveDataMetadata]) {
        scrollView.viewController = viewController as? LoadGamesViewController
        self.games = games
        var index = 0
        for gameData in games {
            let button = UIButton()
            button.tag = gameData.id
            button.isEnabled = false
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            button.setTitle(gameData.name, for: .normal)
            button.backgroundColor = .green
            button.layer.cornerRadius = 5.0
            
            let removeButton = UIButton()
            removeButton.tag = gameData.id
            removeButton.backgroundColor = .systemOrange
            removeButton.setTitle("Remove", for: .normal)
            removeButton.isEnabled = false
            removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            removeButton.layer.cornerRadius = 5.0
            
            scrollView.addSubview(button)
            scrollView.addSubview(removeButton)
            select.append(button);
            remove.append(removeButton);
            index += 1
        }
        setNeedsLayout()
    }
}


class LoadGamesViewController: UIViewController {
    private var _v : LoadGamesView?
        
    @objc func onBackButtonPress() {
        let vc = ViewController()
        self.view.window?.rootViewController = vc
    }
    
    @objc func onRemoveGame(button: UIButton) {
        do {
            let metadata = _v!.games.first { g in g.id == button.tag }
            try Archiver().delete(metadata: .init(name: metadata!.name, id: metadata!.id))
            _v!.removeGame(id: button.tag)
        } catch {
            print("unable to remove game")
        }
    }
    
    @objc func onLoadGame(button: UIButton)   {
        do {
            let gameData = try Archiver().load(id: button.tag, name: button.title(for: .normal)!)
            if(gameData.GameType == "Crossword") {
                let vc = CrosswordScreenViewController()
                vc.data = gameData
                _v!.window?.rootViewController = vc
            } else {
                let vc = SudokuViewController()
                vc.data = gameData
                _v!.window?.rootViewController = vc
            }
        } catch {
            print("error", error)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                _v?.darkmode()
            } else {
                _v?.lightmode()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self._v?.setNeedsLayout()
        }, completion: { _ in
        })
    }
    
    func loadGames() {
        Task {
            let g = try Archiver().loadMetadata()
            _v?.renderGames(games: g)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = LoadGamesView(frame: self.view.frame)
        v.viewController = self
        self.view = v
        _v = v
        
        loadGames()
    }
}

