import Foundation

struct SaveData : Codable {
    var time: Int
    var time_limit: Int
    var level: Int
    var score : Int
    var name: String
    var GameType: String
    var puzzleCrossword: [String]
    var completeCrossword: [String]
    var puzzle: [Int]
    var complete: [Int]
    var initiallySet: [Int]
    var guesses: [Int]
    var positions: [VirtualPoint]
    var orientations: [Orientation]
}

struct VirtualPoint : Codable {
    var x: Int
    var y: Int
}

struct SaveDataMetadata {
    var name = ""
    var id = 0
}

class Archiver {
    private var count : Int? = .none
    
    private func initCount() throws {
        do {
            if(count == nil) {
                let url = URL.documentsDirectory.appending(path: "count.txt")
                let str = try String(contentsOf: url)
                count = Int(str)!
            }
        } catch {
            if(error.localizedDescription.contains("because there is no such file")) {
                let str = "1"
                let url = URL.documentsDirectory.appending(path: "count.txt")
                try str.write(to: url, atomically: true, encoding: .utf8)
                count = 1
            }
        }
    }
    
    private func updateCount()  {
        do {
            let str = (count! + 1).description
            let url = URL.documentsDirectory.appending(path: "count.txt")
            try str.write(to: url, atomically: true, encoding: .utf8)
            count = count! + 1
        } catch {
            print(error)
        }
    }
    
    private func decrementCount() {
        do {
            try initCount()
            let str = (count! - 1).description
            let url = URL.documentsDirectory.appending(path: "count.txt")
            try str.write(to: url, atomically: true, encoding: .utf8)
            count = count! - 1
        } catch {
            print(error)
        }
    }
    
    private func createUrl(metadata: SaveDataMetadata) -> URL {
        return URL.documentsDirectory.appending(path: String(metadata.id) + "-" + metadata.name + "-.txt")
    }
    
    init() {}
    
    func loadMetadata() throws -> [SaveDataMetadata] {
        let fileURLs = try FileManager.default.contentsOfDirectory(
                  at: URL.documentsDirectory,
                  includingPropertiesForKeys: nil,
                  options: .skipsHiddenFiles
        )
        var result : [SaveDataMetadata] = []
        fileURLs.forEach { url in
            let str = url.lastPathComponent
            let s = str.split(separator: "-")
            if(s.count == 3) {
                result.append(.init(name: String(s[1]), id: Int(s[0])!))
            }
        }
        return result
    }
    
    func load(id: Int, name: String) throws -> SaveData {
        let url = createUrl(metadata: .init(name: name, id: id))
        let data = try Data(contentsOf: url)
        let result = try JSONDecoder().decode(SaveData.self, from: data)
        return result
    }
        
    func delete(metadata: SaveDataMetadata) throws {
        do {
            let url = createUrl(metadata: metadata)
            try FileManager.default.removeItem(at: url)
            decrementCount()
        } catch {
            print("unable to delte")
        }
    }
    
    func save(data: SaveData) throws {
        if(count == nil) {
            try initCount()
        }
        
        let id = count
        let url = createUrl(metadata: .init(name: data.name, id: id!))
        let data = try JSONEncoder().encode(data)
        try data.write(to: url)
        updateCount()
    }
}
