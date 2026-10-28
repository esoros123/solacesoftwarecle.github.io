import Foundation
import UIKit
import SwiftData

class ScoreboardGameData  {
    var gameName = ""
    var playerName = ""
    var date = Date()
    var score = 0
    
    init(gameName: String = "", playerName: String = "", date: Date = Date(), score: Int = 0) {
        self.gameName = gameName
        self.playerName = playerName
        self.date = date
        self.score = score
    }
}

class ScoreboardArchiver {
    func createNewFolder(folderName: String) {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to find documents directory")
            return
        }

        let newFolderPath = documentsDirectory.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: newFolderPath.path) {
            do {
                try fileManager.createDirectory(at: newFolderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory: \(error.localizedDescription)")
            }
        } else {
        }
    }
    
    func saveGame(data: ScoreboardGameData) throws {
        createNewFolder(folderName: "scoreboard")
        
        let documentsDirectory = try FileManager.default.url(
              for: .documentDirectory,
              in: .userDomainMask,
              appropriateFor: nil,
              create: false
        )
        let folder = documentsDirectory.appendingPathComponent("scoreboard", isDirectory: true)
        let filename = data.playerName + "--" + data.gameName  + "--" + data.date.timeIntervalSince1970.description + "--" + data.score.description
        let fileUrl = folder.appendingPathComponent(filename)
        try filename.write(to: fileUrl, atomically: true, encoding: .utf8)
    }
    
    func loadGames() throws -> [ScoreboardGameData] {
        createNewFolder(folderName: "scoreboard")
        
        let fileURLs = try FileManager.default.contentsOfDirectory(
            at: URL.documentsDirectory.appendingPathComponent("scoreboard"),
                  includingPropertiesForKeys: nil,
                  options: .skipsHiddenFiles
        )
        
        var result : [ScoreboardGameData] = []
        fileURLs.forEach { url in
            let str = url.lastPathComponent
            let s = str.split(separator: "--")
            if(s.count == 4) {
                let dateDouble = Double(s[2])!; let date = Date(timeIntervalSince1970: dateDouble)
                result.append(.init(gameName: s[1].description, playerName: s[0].description, date: date, score: Int(s[3])!))
            }
        }
        return result
    }
}

class GameOverViewController : UIViewController {
    override func viewDidLoad() {
        let v = GameOver(frame: self.view.frame)
        self.view = v
    }
    
    @objc func back() {
        let vc = ViewController()
        self.view.window?.rootViewController = vc
    }
}

class GameOver : UIView {
    private var label : UILabel = .init()
    private var button : UIButton = .init()
    private var exit : UIButton = .init()
    private var _points = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        super.backgroundColor = .white
        label.text = "Game Over"
        
        let score = UILabel.init()
        score.text = "300 points"
        
        let textField = UITextField.init()
        textField.text = "Enter Name Here"
        textField.tag = 10
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        
        let nameField = UITextField.init()
        nameField.text = "Enter Save Name"
        nameField.tag = 20
        nameField.layer.borderWidth = 2.0
        nameField.layer.borderColor = UIColor.systemBlue.cgColor
        
        let points = UILabel.init()
        points.text = "5 points earned"
        points.tag = 30
        _points = 5
        
        let timelmit = UILabel.init()
        timelmit.text = "10 minute game"
        timelmit.tag = 40

        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(saveGame), for: .touchDown)
        
        exit.setTitle("Exit", for: .normal)
        exit.backgroundColor = .systemOrange
        exit.layer.cornerRadius = 5.0
        exit.addTarget(self, action: #selector(exitGame), for: .touchDown)
        
        super.addSubview(label); super.addSubview(button); super.addSubview(exit);
        super.addSubview(textField); super.addSubview(nameField); super.addSubview(points); super.addSubview(timelmit)
    }
    
    override func layoutSubviews() {        
        let textField = viewWithTag(10) as? UITextField
        let nameField = viewWithTag(20) as? UITextField
        let points = viewWithTag(30) as? UILabel
        let timelmit = viewWithTag(40)

        if(frame.width > frame.height) {
            exit.frame = .init(x: 10, y: frame.height - 100, width: 100, height: 50)
            button.frame = .init(x: 115, y: frame.height - 100, width: 100, height: 50)
            textField?.frame = .init(x: 50, y: 100, width: 300, height: 50)
            nameField?.frame = .init(x: 50, y: 155, width: 300, height: 50)
            points?.frame = .init(x: 200, y: 20, width: 300, height: 50)
            timelmit?.frame = .init(x: 330, y: 20, width: 300, height: 50)
        } else {
            exit.frame = .init(x: 10, y: frame.height - 100, width: 100, height: 50)
            button.frame = .init(x: 115, y: frame.height - 100, width: 100, height: 50)
            textField?.frame = .init(x: 10, y: 100, width: 300, height: 50)
            nameField?.frame = .init(x: 10, y: 155, width: 300, height: 50)
            points?.frame = .init(x: 10, y: 400, width: 300, height: 50)
            timelmit?.frame = .init(x: 10, y: 440, width: 300, height: 50)
        }
    }
    
    @objc func exitGame() {
        let vc = ViewController()
        self.window?.rootViewController = vc
    }
    
    @objc func saveGame() {
        do {
            let textField = viewWithTag(10) as! UITextField
            let nameField = viewWithTag(20) as! UITextField
            
            let archiver = ScoreboardArchiver()
            try archiver.saveGame(data: .init(gameName: textField.text!, playerName: nameField.text!, date: .init(), score: _points))
            
            let vc = ViewController()
            self.window?.rootViewController = vc
        } catch {
            print("unable to save")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
