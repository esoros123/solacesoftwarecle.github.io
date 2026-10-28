import Foundation

class PageGenerator {
    var _itemsPerPage = 0
    var arrayCount = 0
    var currentPage = 0
    
    func ArrayCount() -> Int {
        return arrayCount 
    }
    
    init(itemsPerPage: Int, arrCount: Int) {
        _itemsPerPage = itemsPerPage
        arrayCount = arrCount
    }
    
    func localToGlobal(localIndex: Int) -> Int {
        return (currentPage * _itemsPerPage) + localIndex
    }
    
    func currentIndex() -> Int {
        return currentPage * _itemsPerPage
    }
    
    func NextPage() -> Int {
        if((currentPage + 1) * _itemsPerPage > arrayCount - 1) {
            return currentPage * _itemsPerPage
        } else {
            currentPage += 1
            return currentPage * _itemsPerPage
        }
    }
    
    func PreviousPage() -> Int {
        if(currentPage != 0) {
            currentPage -= 1
            return currentPage * _itemsPerPage
        } else {
            return currentPage * _itemsPerPage
        }
    }
}
