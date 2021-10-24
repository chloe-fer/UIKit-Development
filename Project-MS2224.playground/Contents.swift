import UIKit

var greeting = "Hello, playground"


// Challenge 1: Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

extension UIView {
      
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: 10) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
    
}
    
// Challenge 2: Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.

extension Int {
    
    func times(action: () -> Void) {
        
//        for _ in 1 ... self {
//            action()
//        }
        
        guard self > 0 else { return }
        for _ in 0 ..< self {
            action()
        }
    }
    
}

let count = -5
count.times {
    print("WTF")
}

5.times {
 print("hello!")
}


// Challenge 3: Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds

extension Array where Element: Comparable {

    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        remove(at: index)
        
    }
    
}

var array = [1,2,3,4,4,5,4]
array.remove(item: 4)
