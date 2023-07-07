
import UIKit

// +State
public extension UIScrollView {
    
    struct State: OptionSet {
        
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let bouncingTop = State(rawValue: 1 << 0)
        static let bouncingBottom = State(rawValue: 1 << 1)
        static let scrollingUp = State(rawValue: 1 << 2)
        static let scrollingDown = State(rawValue: 1 << 3)
        static let bouncing: State = [.bouncingTop, .bouncingBottom]
        static let scrolling: State = [.scrollingUp, .scrollingDown]
        
        static let unknown = State(rawValue: 1 << 10)
    }
    
    var state: State {
        if self.isBouncingTop() {
            return .bouncingTop
        } else if self.isBouncingBottom() {
            return .bouncingBottom
        } else if self.isScrollingUp() {
            return .scrollingUp
        } else if self.isScrollingDown() {
            return .scrollingDown
        } else {
            return .unknown
        }
    }
}

// +Bouncing
extension UIScrollView {
    
    // MARK: - Accessible
    
    @objc func isBouncing() -> Bool { self._isBouncing() }
    @objc func isBouncingTop() -> Bool { self._isBouncingTop() }
    @objc func isBouncingBottom() -> Bool { self._isBouncingBottom() }
    
    // MARK: - Unaccessible
    
    fileprivate func _isBouncing() -> Bool {
        return self._isBouncingTop() || self.isBouncingBottom()
    }
    
    fileprivate func _isBouncingTop() -> Bool {
        let offsetY = self.contentOffset.y
        return self.contentOffset.y <= -self.contentInset.top
    }
    
    fileprivate func _isBouncingBottom() -> Bool {
        return self.contentOffset.y >= self.offsetBottomLimit()
    }
    
    fileprivate func offsetBottomLimit() -> CGFloat {
        let contentHeight = self.contentSize.height
        let frameHeight = self.frame.height
        return contentHeight - frameHeight
    }
}

// +Scrolling
extension UIScrollView {
    // MARK: - Accessible
    
    @objc func isScrolling() -> Bool { self._isScrolling() }
    @objc func isScrollingUp() -> Bool { self._isScrollingUp() }
    @objc func isScrollingDown() -> Bool { self._isScrollingDown() }
    
    // MARK: - Unaccessible
    
    fileprivate func _isScrolling() -> Bool {
        return self._isScrollingUp() || self._isScrollingDown()
    }
    fileprivate func _isScrollingUp() -> Bool {
        let velocityY = self.panGestureRecognizer.velocity(in: self.superview).y
        return velocityY > 0
    }
    fileprivate func _isScrollingDown() -> Bool {
        let velocityY = self.panGestureRecognizer.velocity(in: self.superview).y
        return velocityY < 0
    }
}

