//===--- WrappingIterators.swift ------------------------------------------===//
//
// This source file is part of the SwiftXML.org open source project
//
// Copyright (c) 2021-2023 Stefan Springer (https://stefanspringer.com)
// and the SwiftXML project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
//===----------------------------------------------------------------------===//

import Foundation

/**
 The XNodeIterator does the work of making sure that an XML tree can be manipulated
 during iteration. It is ignorant about what precise iteration takes place. The
 precise iteration is implemented in "iteratorImplementation" which implements
 the XIteratorProtocol.
 */
public final class XBidirectionalContentIterator: XContentIterator {
    
    var previousIterator: XBidirectionalContentIterator? = nil
    var nextIterator: XBidirectionalContentIterator? = nil
    
    public typealias Element = XContent
    
    var nodeIterator: XContentIteratorProtocol
    
    public init(nodeIterator: XContentIteratorProtocol) {
        self.nodeIterator = nodeIterator    }
    
    weak var current: Element? = nil
    var prefetched = false
    
    public override func next() -> XContent? {
        if prefetched {
            prefetched = false
            return current
        }
        current?.removeContentIterator(self)
        current = nodeIterator.next()
        current?.addContentIterator(self)
        return current
    }
    
    public override func previous() -> XContent? {
        prefetched = false
        current?.removeContentIterator(self)
        current = nodeIterator.previous()
        current?.addContentIterator(self)
        return current
    }
    
    public func prefetch() {
        current?.removeContentIterator(self)
        current = nodeIterator.next()
        current?.addContentIterator(self)
        prefetched = true
    }
}

public final class XBidirectionalTextIterator: XTextIterator {
    
    var previousIterator: XBidirectionalTextIterator? = nil
    var nextIterator: XBidirectionalTextIterator? = nil
    
    public typealias Element = XText
    
    var textIterator: XTextIteratorProtocol
    
    public init(textIterator: XTextIteratorProtocol) {
        self.textIterator = textIterator    }
    
    weak var current: XText? = nil
    var prefetched = false
    
    public override func next() -> XText? {
        if prefetched {
            prefetched = false
            return current
        }
        current?.removeTextIterator(self)
        current = textIterator.next()
        current?.addTextIterator(self)
        return current
    }
    
    public override func previous() -> XText? {
        prefetched = false
        current?.removeTextIterator(self)
        current = textIterator.previous()
        current?.addTextIterator(self)
        return current
    }
    
    public func prefetch() {
        current?.removeTextIterator(self)
        current = textIterator.next()
        current?.addTextIterator(self)
        prefetched = true
    }
}


public final class XBidirectionalElementIterator: XElementIterator {
    
    var previousIterator: XBidirectionalElementIterator? = nil
    var nextIterator: XBidirectionalElementIterator? = nil
    
    public typealias Element = XElement
    
    var elementIterator: XElementIteratorProtocol
    
    public init(elementIterator: XElementIteratorProtocol) {
        self.elementIterator = elementIterator
    }
    
    weak var current: XElement? = nil
    var prefetched = false
    
    public override func next() -> XElement? {
        if prefetched {
            prefetched = false
            return current
        }
        current?.removeElementIterator(self)
        current = elementIterator.next()
        current?.addElementIterator(self)
        return current
    }
    
    public override func previous() -> XElement? {
        prefetched = false
        current?.removeElementIterator(self)
        current = elementIterator.previous()
        current?.addElementIterator(self)
        return current
    }
    
    public func prefetch() {
        current?.removeElementIterator(self)
        current = elementIterator.next()
        current?.addElementIterator(self)
        prefetched = true
    }
}

public final class XXBidirectionalElementNameIterator: XElementIterator {
    
    public typealias Element = XElement
    
    var elementIterator: XElementIteratorProtocol
    
    var keepLast: Bool
    
    public init(elementIterator: XElementIteratorProtocol, keepLast: Bool = false) {
        self.elementIterator = elementIterator
        self.keepLast = keepLast
    }
    
    weak var current: XElement? = nil
    var prefetched = false
    
    public override func next() -> XElement? {
        if prefetched {
            prefetched = false
            return current
        }
        let next = elementIterator.next()
        if keepLast && next == nil {
            return nil
        }
        else {
            current?.removeNameIterator(self)
            current = next
            current?.addNameIterator(self)
            return current
        }
    }
    
    public override func previous() -> XElement? {
        prefetched = false
        current?.removeNameIterator(self)
        current = elementIterator.previous()
        current?.addNameIterator(self)
        return current
    }
    
    public func prefetch() {
        current?.removeNameIterator(self)
        current = elementIterator.next()
        current?.addNameIterator(self)
        prefetched = true
    }
}
