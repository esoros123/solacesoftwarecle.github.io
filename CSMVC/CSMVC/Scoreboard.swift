import Foundation
import UIKit
import SwiftData

let emptyString = ""

struct ScoreboardData : Codable {
    var name = emptyString
    var score = 0
    var date = Date()
    
    init(_ name: String, score: Int, date: Date) {
        self.name = name
        self.score = score
        self.date = date
    }
}

class DataFetch {
    func xfetch(grammar: String) -> NSObject {
        return NSObject.init()
    }
}

class ScoreboardTableCellView : UITableViewCell {
    private var _gameName: UILabel = .init()
    private var _userName: UILabel = .init()
    private var _date: UILabel = .init()
    private var _score: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: "ScoreboardTableCellView")
                  
         self.selectionStyle = .none
        
        _gameName.frame = .init(x: 0, y: 0, width: 100, height: 20)
        _userName.frame = .init(x: 100, y: 0, width: 100, height: 20)
        _date.frame = .init(x: 200, y: 0, width: 100, height: 20)
        _score.frame = .init(x: 300, y: 0, width: 100, height: 20)

        _gameName.backgroundColor = .systemBlue
        _userName.backgroundColor = .systemMint
        _date.backgroundColor = .systemYellow
        _score.backgroundColor = .systemOrange
        
        _gameName.backgroundColor = .systemBlue
        _userName.backgroundColor = .systemMint
        _date.backgroundColor = .systemYellow
        _score.backgroundColor = .systemOrange
                
        _gameName.textColor = .white
        _userName.textColor = .white
        _date.textColor = .white
        _score.textColor = .white

         contentView.addSubview(_gameName)
         contentView.addSubview(_userName)
         contentView.addSubview(_date)
         contentView.addSubview(_score)
      }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        let landscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        if(!landscape) {
            _gameName.frame = .init(x: 0, y: 20, width: frame.width/4, height: 20)
            _userName.frame = .init(x: 100, y: 20, width: frame.width/4, height: 20)
            _date.frame = .init(x: 200, y: 20, width: frame.width/4, height: 20)
            _score.frame = .init(x: 300, y: 20, width: frame.width/4, height: 20)
            
        } else {
            _gameName.frame = .init(x: 0, y: 20, width: frame.width/4, height: 20)
            _userName.frame = .init(x: 150, y: 20, width: frame.width/4, height: 20)
            _date.frame = .init(x: 300, y: 20, width: frame.width/4, height: 20)
            _score.frame = .init(x: 450, y: 20, width: frame.width/4, height: 20)
        }
    }
    
    func configure(game: String, user: String, date: Date, score: Int) {
        _score.text = String(score)
        _userName.text = user
        _gameName.text = game
        _date.text = date.description
    }
}

class ScoreboardView: UIView, UITableViewDataSource  {
    weak var viewController: UIViewController?
    private var data: [ScoreboardGameData] = []
    private var label: UILabel = .init()
    private var notFond : UILabel = .init()
    private var backButton: UIButton = .init()
    private var tableView : UITableView = .init()
    
    private var names: [UIButton] = []
    private var gameNames: [UIButton] = []
    private var dates: [UIButton] = []
    private var scores: [UIButton] = []
        
    func getLabelSize(label: UILabel, char: String) -> CGSize {
        let att = [NSAttributedString.Key.font: label.font!]
        let size = (char as NSString).size(withAttributes: att)
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        label.text = "Scoreboard"
        
        tableView.dataSource = self
        tableView.register(ScoreboardTableCellView.self, forCellReuseIdentifier: "ScoreboardTableCellView")
        
        super.addSubview(label)
        super.addSubview(tableView)
        
        notFond.text = "No Games Found"
        super.addSubview(notFond)
        
        backButton.frame = .init(x: 10, y: frame.height/12, width: 30, height: 30)
        backButton.addTarget(viewController, action: #selector(ScoreboardViewController.onBackButtonPress), for: .touchUpInside)
        backButton.tintColor = .systemOrange
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
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

    override func layoutSubviews() {
        let landscape = frame.width > frame.height
        if(data.count != 0) {
            notFond = .init();
            let labelY = landscape ? 25.0 : 50.0
            backButton.frame = .init(x: 10, y: labelY, width: 20, height: 25)
            label.frame = .init(x: frame.width/2 - 50, y: labelY, width: 100, height: 25)
            tableView.frame = .init(x: 30, y: 30, width: frame.width - 40, height: frame.height - 20)
            tableView.center.x = center.x
        } else {
            let size = getLabelSize(label: notFond, char: notFond.text!)
            notFond.frame = .init(x: frame.width/2 - size.width/2, y: frame.height/2 - size.height/2, width: size.width, height: size.height)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScoreboardTableCellView = tableView.dequeueReusableCell(withIdentifier: "ScoreboardTableCellView") as! ScoreboardTableCellView
        let data = data[indexPath.row]
        cell.configure(game: data.gameName, user: data.playerName, date: data.date, score: data.score)
        return cell
    }
    
    func renderScores(gameData: [ScoreboardGameData]) {
        data = gameData
        layoutIfNeeded()
    }
}

class ScoreboardViewController: UIViewController {
    private var vi: ScoreboardView?
        
    @objc func onBackButtonPress() {
        let vc = ViewController()
        view.window?.rootViewController = vc
    }
        
    func getScores() -> [ScoreboardGameData] {
        do {
            let archiver = ScoreboardArchiver()
            let games = try archiver.loadGames()
            return games
        } catch {
            print("unable to get scores")
        }
        return []
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
        let v = ScoreboardView(frame: self.view.frame)
        v.viewController = self
        self.view = v
        self.vi = v
        
        let result = getScores()
        v.renderScores(gameData: result)
    }
}
