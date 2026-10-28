import Foundation
import UIKit

var useCustomGames = true
var playAudio = true

struct Configuration: Codable {
    let customGames: Bool
    let audio: Bool
    
    init(c: Bool, a: Bool) {
        customGames = c
        audio = a
    }
}

class ConfigurationRepository {
    init() {
        createDirectory()
    }
    
    func directoryURL() -> URL {
        let documentsURL = URL.documentsDirectory
        let directoryURL = documentsURL.appending(path: "configuration")
        return directoryURL
    }
    
    func delete() {
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: directoryURL())
            createDirectory()
        } catch {
            print("unable to delete and create")
        }
    }
    
    func createDirectory() {
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: directoryURL().appending(path:"config.txt").path) {
                try fileManager.createDirectory(
                    atPath: directoryURL().path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                fileManager.createFile(atPath: directoryURL().appending(path:"config.txt").path, contents: nil, attributes: nil)
            }
        } catch {
            print("unable to create file manager")
        }
    }
    
    func loadConfig() {
        do {
            let url = directoryURL().appending(path:"config.txt")
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let config = try decoder.decode(Configuration.self, from: data)
            useCustomGames = config.customGames
            playAudio = config.audio
        } catch {
            print("Failed to load data to file: \(error.localizedDescription)")
        }
    }
    
    func saveConfg() {
        let fileUrl = directoryURL().appending(path:"config.txt")
        do {
                let configuration = Configuration.init(c: useCustomGames, a: playAudio)
                let data = try JSONEncoder().encode(configuration)
                try data.write(to: fileUrl, options: [.atomic, .completeFileProtection])
           } catch {
               print("Failed to write data to file: \(error.localizedDescription)")
           }
    }
}

class ConfigurationView : UIView {
    let s : UISwitch = .init()
    let load = UIButton()
    let c  = UILabel()
    var imageView: UIImageView? = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.systemBackground
        
        load.backgroundColor = .systemMint
        load.layer.cornerRadius = 5.0
        load.tag = 3
        load.setTitle("back", for: .normal)
        load.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        load.setTitleColor(.white, for: .normal)
        load.addTarget(self, action: #selector(xbackpress), for: .touchUpInside)
        load.frame = .init(x: 10, y: frame.height - 50, width: 100, height: 30)
        
        let ls = UILabel.init()
        ls.frame = .init(x: 30, y: 60, width: 200, height: 20)
        ls.text = "Use Custom Games"
        
        s.frame = .init(x: frame.width-80, y: 60, width: 100, height: 20)
        s.addTarget(self, action: #selector(xonswitch), for: .valueChanged)
                
        c.text = "https://solacesoftware.com"
        
        let symbolImage = UIImage(systemName: "gear.circle")
        imageView = UIImageView(image: symbolImage)

        super.addSubview(s); super.addSubview(ls);
        super.addSubview(load); super.addSubview(imageView!);
        super.addSubview(c)
        
        ConfigurationRepository().loadConfig()
        s.isOn = useCustomGames
    }
    
    deinit {
      //  DispatchQueue.global(qos: .background).async {
       //     ConfigurationRepository().saveConfg()
       // }
    }
    
    override func layoutSubviews() {
        s.frame = .init(x: frame.width-80, y: 60, width: 100, height: 20)
        load.frame = .init(x: 10, y: frame.height - 50, width: 100, height: 30)
        imageView?.frame = .init(x: frame.width-80, y: frame.height - 50, width: 40, height: 30)
        c.frame = .init(x: frame.width/2 - 175, y: frame.height - 50, width: 250, height: 30)
        
        if(frame.height > frame.width) {
            c.frame = .init(x: frame.width/2 - 175, y: frame.height - 100, width: 250, height: 30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func xonswitch() {
        useCustomGames = !useCustomGames
    }
    
    @objc func yonswitch() {
        playAudio = !playAudio
    }
    
    @objc func xbackpress() {
        let viewController = ViewController()
        self.window?.rootViewController = viewController
    }
}

class ConfigurationViewController : UIViewController {
    override func viewDidLoad() {
        let v = ConfigurationView.init(frame: self.view.frame)
        self.view = v
    }
}
