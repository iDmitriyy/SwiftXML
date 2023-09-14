//===--- ChainedIterators.swift -------------------------------------------===//
//
// This source file is part of the SwiftXML.org open source project
//
// Copyright (c) 2021-2023 Stefan Springer (https://stefanspringer.com) and the SwiftXML project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
//===----------------------------------------------------------------------===//

import Foundation


public class XElementIteratorDependingOnElementIterator: XElementIterator {
    
    private var iterator1: TypedIterator<XElement>
    private var element1: XElement? = nil
    private var started = false
    let nextSequenceGetter: (XElement) -> XElementSequence
    private var iterator2: XElementIterator? = nil
    
    init(sequence: any Sequence<XElement>, nextSequenceGetter: @escaping (XElement) -> XElementSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XElement? {
        if !started {
            element1 = iterator1.next()
            started = true
        }
        while let theElement1 = element1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theElement1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                element1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XElementIteratorDependingOnContentIterator: XElementIterator {
    
    private var iterator1: TypedIterator<XContent>
    private var content1: XContent? = nil
    private var started = false
    let nextSequenceGetter: (XContent) -> XElementSequence
    private var iterator2: XElementIterator? = nil
    
    init(sequence: any Sequence<XContent>, nextSequenceGetter: @escaping (XContent) -> XElementSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XElement? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XTextIteratorDependingOnContentIterator: XTextIterator {
    
    private var iterator1: TypedIterator<XContent>
    private var content1: XContent? = nil
    private var started = false
    let nextSequenceGetter: (XContent) -> XTextSequence
    private var iterator2: XTextIterator? = nil
    
    init(sequence: any Sequence<XContent>, nextSequenceGetter: @escaping (XContent) -> XTextSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XText? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XElementIteratorDependingOnTextIterator: XElementIterator {
    
    private var iterator1: TypedIterator<XText>
    private var content1: XText? = nil
    private var started = false
    let nextSequenceGetter: (XText) -> XElementSequence
    private var iterator2: XElementIterator? = nil
    
    init(sequence: any Sequence<XText>, nextSequenceGetter: @escaping (XText) -> XElementSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XElement? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XContentIteratorDependingOnElementIterator: XContentIterator {
    
    private var iterator1: TypedIterator<XElement>
    private var content1: XElement? = nil
    private var started = false
    let nextSequenceGetter: (XElement) -> XContentSequence
    private var iterator2: XContentIterator? = nil
    
    init(sequence: any Sequence<XElement>, nextSequenceGetter: @escaping (XElement) -> XContentSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XContent? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XTextIteratorDependingOnElementIterator: XTextIterator {
    
    private var iterator1: TypedIterator<XElement>
    private var content1: XElement? = nil
    private var started = false
    let nextSequenceGetter: (XElement) -> XTextSequence
    private var iterator2: XTextIterator? = nil
    
    init(sequence: any Sequence<XElement>, nextSequenceGetter: @escaping (XElement) -> XTextSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XText? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XContentIteratorDependingOnTextIterator: XContentIterator {
    
    private var iterator1: TypedIterator<XText>
    private var content1: XText? = nil
    private var started = false
    let nextSequenceGetter: (XText) -> XContentSequence
    private var iterator2: XContentIterator? = nil
    
    init(sequence: any Sequence<XText>, nextSequenceGetter: @escaping (XText) -> XContentSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XContent? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XTextIteratorDependingOnTextIterator: XTextIterator {
    
    private var iterator1: TypedIterator<XText>
    private var content1: XText? = nil
    private var started = false
    let nextSequenceGetter: (XText) -> XTextSequence
    private var iterator2: XTextIterator? = nil
    
    init(sequence: any Sequence<XText>, nextSequenceGetter: @escaping (XText) -> XTextSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XText? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XContentIteratorDependingOnContentIterator: XContentIterator {
    
    private var iterator1: TypedIterator<XContent>
    private var content1: XContent? = nil
    private var started = false
    let nextSequenceGetter: (XContent) -> XContentSequence
    private var iterator2: XContentIterator? = nil
    
    init(sequence: any Sequence<XContent>, nextSequenceGetter: @escaping (XContent) -> XContentSequence) {
        iterator1 = TypedIterator(for: sequence)
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    public override func next() -> XContent? {
        if !started {
            content1 = iterator1.next()
            started = true
        }
        while let theContent1 = content1 {
            let theIterator2 = iterator2 ?? {
                let newIterator2 = nextSequenceGetter(theContent1).makeIterator()
                iterator2 = newIterator2
                return newIterator2
            }()
            if let theNext = theIterator2.next() {
                return theNext
            }
            else {
                iterator2 = nil
                content1 = iterator1.next()
            }
        }
        return nil
    }
}

public class XContentDependingOnContentIterator: XContentIterator {
    
    private var iterator1: TypedIterator<XContent>
    private var content1: XContent? = nil
    let contentGetter: (XContent) -> XContent?
    
    init(sequence: any Sequence<XContent>, contentGetter: @escaping (XContent) -> XContent?) {
        iterator1 = TypedIterator(for: sequence)
        self.contentGetter = contentGetter
    }
    
    public override func next() -> XContent? {
        var content2: XContent? = nil
        while content2 == nil {
            content1 = iterator1.next()
            if let theContent1 = content1 {
                content2 = contentGetter(theContent1)
            }
            else {
                return nil
            }
        }
        return content2
    }
}

public class XContentDependingOnElementIterator: XContentIterator {
    
    private var iterator1: TypedIterator<XElement>
    private var element1: XElement? = nil
    let contentGetter: (XElement) -> XContent?
    
    init(sequence: any Sequence<XElement>, contentGetter: @escaping (XElement) -> XContent?) {
        iterator1 = TypedIterator(for: sequence)
        self.contentGetter = contentGetter
    }
    
    public override func next() -> XContent? {
        var content2: XContent? = nil
        while content2 == nil {
            element1 = iterator1.next()
            if let theContent1 = element1 {
                content2 = contentGetter(theContent1)
            }
            else {
                return nil
            }
        }
        return content2
    }
}

public class XElementDependingOnContentIterator: XElementIterator {
    
    private var iterator1: TypedIterator<XContent>
    private var content1: XContent? = nil
    let elementGetter: (XContent) -> XElement?
    
    init(sequence: any Sequence<XContent>, elementGetter: @escaping (XContent) -> XElement?) {
        iterator1 = TypedIterator(for: sequence)
        self.elementGetter = elementGetter
    }
    
    public override func next() -> XElement? {
        var element2: XElement? = nil
        while element2 == nil {
            content1 = iterator1.next()
            if let theContent1 = content1 {
                element2 = elementGetter(theContent1)
            }
            else {
                return nil
            }
        }
        return element2
    }
}

public class XNameSequenceDependingOnElementSequence: XStringSequence {
    
    let sequence: any Sequence<XElement>
    
    init(sequence: any Sequence<XElement>) {
        self.sequence = sequence
    }
    
    override public func makeIterator() -> XNameDependingOnElementIterator {
        return XNameDependingOnElementIterator(sequence: sequence)
    }
}

public class XNameDependingOnElementIterator: XStringIterator {
    
    private var iterator: TypedIterator<XElement>
    
    init(sequence: any Sequence<XElement>) {
        iterator = TypedIterator(for: sequence)
    }
    
    public override func next() -> String? {
        if let element = iterator.next() {
            return element.name
        }
        else {
            return nil
        }
    }
}

public class XAttributeValueSequenceDependingOnElementSequence: XStringSequence {
    
    let sequence: any Sequence<XElement>
    private let attributeName: String?
    
    init(sequence: any Sequence<XElement>, attributeName: String?) {
        self.sequence = sequence
        self.attributeName = attributeName
    }
    
    override public func makeIterator() -> XAttributeValueDependingOnElementIterator {
        return XAttributeValueDependingOnElementIterator(sequence: sequence, attributeName: attributeName)
    }
}

public class XAttributeValueDependingOnElementIterator: XStringIterator {
    
    private var iterator: TypedIterator<XElement>
    private let attributeName: String?
    
    init(sequence: any Sequence<XElement>, attributeName: String?) {
        iterator = TypedIterator(for: sequence)
        self.attributeName = attributeName
    }
    
    public override func next() -> String? {
        if let element = iterator.next() {
            if let attributeName {
                return element[attributeName]
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}

public class XElementDependingOnElementIterator: XElementIterator {
    
    private var iterator1: TypedIterator<XElement>
    private var element1: XElement? = nil
    let elementGetter: (XElement) -> XElement?
    
    init(sequence: any Sequence<XElement>, elementGetter: @escaping (XElement) -> XElement?) {
        iterator1 = TypedIterator(for: sequence)
        self.elementGetter = elementGetter
    }
    
    public override func next() -> XElement? {
        var element2: XElement? = nil
        while element2 == nil {
            element1 = iterator1.next()
            if let theContent1 = element1 {
                element2 = elementGetter(theContent1)
            }
            else {
                return nil
            }
        }
        return element2
    }
}

public class XElementSequenceDependingOnElementSequence: XElementSequence {
    
    let sequence: any Sequence<XElement>
    let nextSequenceGetter: (XElement) -> XElementSequence
    
    init(sequence: any Sequence<XElement>, nextSequenceGetter: @escaping (XElement) -> XElementSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XElementIterator {
        return XElementIteratorDependingOnElementIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XElementSequenceDependingOnContentSequence: XElementSequence {
    
    let sequence: any Sequence<XContent>
    let nextSequenceGetter: (XContent) -> XElementSequence
    
    init(sequence: any Sequence<XContent>, nextSequenceGetter: @escaping (XContent) -> XElementSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XElementIterator {
        return XElementIteratorDependingOnContentIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XTextSequenceDependingOnContentSequence: XTextSequence {
    
    let sequence: any Sequence<XContent>
    let nextSequenceGetter: (XContent) -> XTextSequence
    
    init(sequence: any Sequence<XContent>, nextSequenceGetter: @escaping (XContent) -> XTextSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XTextIterator {
        return XTextIteratorDependingOnContentIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XTextSequenceDependingOnElementSequence: XTextSequence {
    
    let sequence: any Sequence<XElement>
    let nextSequenceGetter: (XElement) -> XTextSequence
    
    init(sequence: any Sequence<XElement>, nextSequenceGetter: @escaping (XElement) -> XTextSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XTextIterator {
        return XTextIteratorDependingOnElementIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XElementSequenceDependingOnTextSequence: XElementSequence {
    
    let sequence: any Sequence<XText>
    let nextSequenceGetter: (XText) -> XElementSequence
    
    init(sequence: any Sequence<XText>, nextSequenceGetter: @escaping (XText) -> XElementSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XElementIterator {
        return XElementIteratorDependingOnTextIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XContentSequenceDependingOnElementSequence: XContentSequence {
    
    let sequence: any Sequence<XElement>
    let nextSequenceGetter: (XElement) -> XContentSequence
    
    init(sequence: any Sequence<XElement>, nextSequenceGetter: @escaping (XElement) -> XContentSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XContentIterator {
        return XContentIteratorDependingOnElementIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XContentSequenceDependingOnTextSequence: XContentSequence {
    
    let sequence: any Sequence<XText>
    let nextSequenceGetter: (XText) -> XContentSequence
    
    init(sequence: any Sequence<XText>, nextSequenceGetter: @escaping (XText) -> XContentSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XContentIterator {
        return XContentIteratorDependingOnTextIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XTextSequenceDependingOnTextSequence: XTextSequence {
    
    let sequence: any Sequence<XText>
    let nextSequenceGetter: (XText) -> XTextSequence
    
    init(sequence: any Sequence<XText>, nextSequenceGetter: @escaping (XText) -> XTextSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XTextIterator {
        return XTextIteratorDependingOnTextIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XContentSequenceDependingOnContentSequence: XContentSequence {
    
    let sequence: any Sequence<XContent>
    let nextSequenceGetter: (XContent) -> XContentSequence
    
    init(sequence: any Sequence<XContent>, nextSequenceGetter: @escaping (XContent) -> XContentSequence) {
        self.sequence = sequence
        self.nextSequenceGetter = nextSequenceGetter
    }
    
    override public func makeIterator() -> XContentIterator {
        return XContentIteratorDependingOnContentIterator(sequence: sequence, nextSequenceGetter: nextSequenceGetter)
    }
}

public class XContentDependingOnContentSequence: XContentSequence {
    
    let sequence: any Sequence<XContent>
    let contentGetter: (XContent) -> XContent?
    
    init(sequence: any Sequence<XContent>, contentGetter: @escaping (XContent) -> XContent?) {
        self.sequence = sequence
        self.contentGetter = contentGetter
    }
    
    override public func makeIterator() -> XContentIterator {
        return XContentDependingOnContentIterator(sequence: sequence, contentGetter: contentGetter)
    }
}

public class XElementDependingOnContentSequence: XElementSequence {
    
    let sequence: any Sequence<XContent>
    let elementGetter: (XContent) -> XElement?
    
    init(sequence: any Sequence<XContent>, elementGetter: @escaping (XContent) -> XElement?) {
        self.sequence = sequence
        self.elementGetter = elementGetter
    }
    
    override public func makeIterator() -> XElementIterator {
        return XElementDependingOnContentIterator(sequence: sequence, elementGetter: elementGetter)
    }
}

public class XContentDependingOnElementSequence: XContentSequence {
    
    let sequence: any Sequence<XElement>
    let contentGetter: (XElement) -> XContent?
    
    init(sequence: any Sequence<XElement>, contentGetter: @escaping (XElement) -> XContent?) {
        self.sequence = sequence
        self.contentGetter = contentGetter
    }
    
    override public func makeIterator() -> XContentIterator {
        return XContentDependingOnElementIterator(sequence: sequence, contentGetter: contentGetter)
    }
}

public class XElementDependingOnElementSequence: XElementSequence {
    
    let sequence: any Sequence<XElement>
    let elementGetter: (XElement) -> XElement?
    
    init(sequence: any Sequence<XElement>, elementGetter: @escaping (XElement) -> XElement?) {
        self.sequence = sequence
        self.elementGetter = elementGetter
    }
    
    override public func makeIterator() -> XElementIterator {
        return XElementDependingOnElementIterator(sequence: sequence, elementGetter: elementGetter)
    }
}

public func collect(@XContentBuilder builder: @escaping () -> [XContent]) -> (() -> [XContent]) {
    return builder
}

extension Sequence<XContent> {
    
    public func clone() -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.clone() })
    }
    
    public func shallowClone() -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.shallowClone() })
    }
    
    public var ancestors: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors }) }
    }
    
    public func ancestors(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(condition) })
    }
    
    public func ancestors(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(while: condition) })
    }
    
    public func ancestors(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(until: condition) })
    }
    
    public func ancestors(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(untilAndIncluding: condition) })
    }
    
    public func ancestors(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(name) })
    }
    
    public func ancestors(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(names) })
    }
    
    public func ancestors(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(names) })
    }
    
    public var ancestorsIncludingSelf: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf }) }
    }
    
    public func ancestorsIncludingSelf(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(condition) })
    }
    
    public func ancestorsIncludingSelf(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(name) })
    }
    
    public func ancestorsIncludingSelf(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(names) })
    }
    
    public func ancestorsIncludingSelf(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(names) })
    }
    
    public func ancestorsIncludingSelf(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(while: condition) })
    }
    
    public func ancestorsIncludingSelf(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(until: condition) })
    }
    
    public func ancestorsIncludingSelf(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(untilAndIncluding: condition) })
    }
    
    public var content: XContentSequence {
        get { XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.content }) }
    }
    
    public func content(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.content(condition) })
    }
    
    public func content(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.content(while: condition) })
    }
    
    public func content(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.content(until: condition) })
    }
    
    public func content(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.content(untilAndIncluding: condition) })
    }
    
    public var contentReversed: XContentSequence {
        get { XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed }) }
    }
    
    public func contentReversed(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(condition) })
    }
    
    public func contentReversed(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(while: condition) })
    }
    
    public func contentReversed(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(until: condition) })
    }
    
    public func contentReversed(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(untilAndIncluding: condition) })
    }
    
    public var texts: XTextSequence {
        get { XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.texts }) }
    }
    
    public func texts(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.texts(condition) })
    }
    
    public func texts(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.texts(while: condition) })
    }
    
    public func texts(until condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.texts(until: condition) })
    }
    
    public func texts(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.texts(untilAndIncluding: condition) })
    }
    
    public var textsReversed: XTextSequence {
        get { XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed }) }
    }
    
    public func textsReversed(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(condition) })
    }
    
    public func textsReversed(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(while: condition) })
    }
    
    public func textsReversed(until condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(until: condition) })
    }
    
    public func textsReversed(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(untilAndIncluding: condition) })
    }
    
    public var allTexts: XTextSequence {
        get { XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allTexts }) }
    }
    
    public func allTexts(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(condition) })
    }
    
    public func allTexts(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(while: condition) })
    }
    
    public func allTexts(until condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(until: condition) })
    }
    
    public func allTexts(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(untilAndIncluding: condition) })
    }
    
    public var children: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children }) }
    }
    
    public func children(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(condition) })
    }
    
    public func children(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(name) })
    }
    
    public func children(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(names) })
    }
    
    public func children(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(names) })
    }
    
    public func children(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(while: condition) })
    }
    
    public func children(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(until: condition) })
    }
    
    public func children(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.children(untilAndIncluding: condition) })
    }
    
    public var childrenReversed: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed }) }
    }
    
    public func childrenReversed(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(condition) })
    }
    
    public func childrenReversed(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(name) })
    }
    
    public func childrenReversed(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(names) })
    }
    
    public func childrenReversed(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(names) })
    }
    
    public func childrenReversed(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(while: condition) })
    }
    
    public func childrenReversed(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(until: condition) })
    }
    
    public func childrenReversed(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(untilAndIncluding: condition) })
    }
    
    public var next: XContentSequence {
        get { XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.next }) }
    }
    
    public func next(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.next(condition) })
    }
    
    public func next(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.next(while: condition) })
    }
    
    public func next(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.next(until: condition) })
    }
    
    public func next(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.next(untilAndIncluding: condition) })
    }
    
    public var previous: XContentSequence {
        get { XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previous }) }
    }
    
    public func previous(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previous(condition) })
    }
    
    public func previous(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previous(while: condition) })
    }
    
    public func previous(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previous(until: condition) })
    }
    
    public func previous(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previous(untilAndIncluding: condition) })
    }
    
    public var nextTexts: XTextSequence {
        get { XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextTexts }) }
    }
    
    public func nextTexts(_ condition: @escaping (XText) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextTexts(condition) })
    }
    
    public func nextTexts(while condition: @escaping (XText) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextTexts(while: condition) })
    }
    
    public func nextTexts(until condition: @escaping (XText) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextTexts(until: condition) })
    }
    
    public func nextTexts(untilAndIncluding condition: @escaping (XText) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextTexts(untilAndIncluding: condition) })
    }
    
    public var previousTexts: XTextSequence {
        get { XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousTexts }) }
    }
    
    public func previousTexts(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousTexts(condition) })
    }
    
    public func previousTexts(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousTexts(while: condition) })
    }
    
    public func previousTexts(until condition: @escaping (XText) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousTexts(until: condition) })
    }
    
    public func previousTexts(untilAndIncluding condition: @escaping (XText) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousTexts(untilAndIncluding: condition) })
    }
    
    public var nextElements: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements }) }
    }
    
    public func nextElements(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(condition) })
    }
    
    public func nextElements(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(name) })
    }
    
    public func nextElements(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(names) })
    }
    
    public func nextElements(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(names) })
    }
    
    public func nextElements(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(while: condition) })
    }
    
    public func nextElements(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(until: condition) })
    }
    
    public func nextElements(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(untilAndIncluding: condition) })
    }
    
    public var previousElements: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousElements }) }
    }
    
    public func previousElements(_ condition: @escaping (XContent) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(condition) })
    }
    
    public func previousElements(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(name) })
    }
    
    public func previousElements(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(names) })
    }
    
    public func previousElements(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(names) })
    }
    
    public func previousElements(while condition: @escaping (XContent) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(while: condition) })
    }
    
    public var allContent: XContentSequence {
        get { XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContent }) }
    }
    
    public func allContent(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContent(condition) })
    }
    
    public func allContent(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContent(while: condition) })
    }
    
    public func allContent(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContent(until: condition) })
    }
    
    public func allContent(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContent(untilAndIncluding: condition) })
    }
    
    public var allContentIncludingSelf: XContentSequence {
        get { XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf }) }
    }
    
    public func allContentIncludingSelf(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(condition) })
    }
    
    public func allContentIncludingSelf(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(while: condition) })
    }
    
    public func allContentIncludingSelf(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(until: condition) })
    }
    
    public func allContentIncludingSelf(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(untilAndIncluding: condition) })
    }
    
    public var descendants: XElementSequence {
        get { XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants }) }
    }
    
    public func descendants(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(condition) })
    }
    
    public func descendants(_ names: [String]) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(names) })
    }
    
    public func descendants(_ names: String...) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(names) })
    }
    
    public func descendants(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(name) })
    }
    
    public func descendants(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(while: condition) })
    }
    
    public func descendants(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(until: condition) })
    }
    
    public func descendants(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnContentSequence(sequence: self, nextSequenceGetter: { content in content.descendants(untilAndIncluding: condition) })
    }
    
    public var previousTouching: XContentSequence {
        get { XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.previousTouching }) }
    }
    
    public func previousTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.previousTouching(condition) })
    }
    
    public var previousInTreeTouching: XContentSequence {
        get { XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.previousInTreeTouching }) }
    }
    
    public func previousInTreeTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.previousInTreeTouching(condition) })
    }
    
    public var nextTouching: XContentSequence {
        get { XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.nextTouching }) }
    }
    
    public func nextTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.nextTouching(condition) })
    }
    
    public var nextInTreeTouching: XContentSequence {
        get { XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.nextInTreeTouching }) }
    }
    
    public func nextInTreeTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in content.nextInTreeTouching(condition) })
    }
    
    public var parent: XElementSequence {
        get { XElementDependingOnContentSequence(sequence: self, elementGetter: { content in content.parent }) }
    }
    
    public func parent(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementDependingOnContentSequence(sequence: self, elementGetter: { content in content.parent(condition) })
    }
    
    public func parent(_ name: String) -> XElementSequence {
        XElementDependingOnContentSequence(sequence: self, elementGetter: { content in content.parent(name) })
    }
    
    public func parent(_ names: [String]) -> XElementSequence {
        XElementDependingOnContentSequence(sequence: self, elementGetter: { content in content.parent(names) })
    }
    
    public func parent(_ names: String...) -> XElementSequence {
        parent(names)
    }
    
    public func applying(_ f: @escaping (XContent) -> ()) -> XContentSequence {
        XContentDependingOnContentSequence(sequence: self, contentGetter: { content in f(content); return content })
    }
    
    public func insertPrevious(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        self.forEach { content in
            content._insertPrevious(insertionMode, builder())
        }
    }
    
    public func insertPrevious(_ insertionMode: InsertionMode = .following, _ contentGetter: @escaping (XContent) -> [XContent]) {
        self.forEach { content in
            content._insertPrevious(insertionMode, contentGetter(content))
        }
    }
    
    public func insertNext(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        self.forEach { content in
            content._insertNext(insertionMode, builder())
        }
    }
    
    public func insertNext(_ insertionMode: InsertionMode = .following, _ contentGetter: @escaping (XContent) -> [XContent]) {
        self.forEach { content in content._insertNext(insertionMode, contentGetter(content)) }
    }
    
    public func replace(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        self.forEach { content in content.replace(insertionMode, builder: builder) }
    }
    
    public func replace(_ insertionMode: InsertionMode = .following, _ contentGetter: (XContent) -> (() -> [XContent])) {
        self.forEach { content in content.replace(insertionMode, builder: contentGetter(content) ) }
    }
    
    public func remove() {
        self.forEach { content in content.remove() }
    }
    
    public func echo(pretty: Bool = false, indentation: String = "  ", terminator: String = "\n") {
        self.forEach { content in content.echo(pretty: pretty, indentation: indentation, terminator: terminator) }
    }
}

extension Sequence<XElement> {
    
    public var name: XStringSequence {
        get { XNameSequenceDependingOnElementSequence(sequence: self) }
    }
    
    public subscript(attributeName: String) -> XStringSequence {
        get { XAttributeValueSequenceDependingOnElementSequence(sequence: self, attributeName: attributeName) }
    }
    
    public func clone() -> XElementSequence {
        XElementDependingOnElementSequence(sequence: self, elementGetter: { element in element.clone() })
    }
    
    public func shallowClone() -> XElementSequence {
        XElementDependingOnElementSequence(sequence: self, elementGetter: { element in element.shallowClone() })
    }
    
    public var ancestors: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestors }) }
    }
    
    public func ancestors(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(condition) })
    }
    
    public func ancestors(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(name) })
    }
    
    public func ancestors(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(while: condition) })
    }
    
    public func ancestors(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(until: condition) })
    }
    
    public func ancestors(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestors(untilAndIncluding: condition) })
    }
    
    public var ancestorsIncludingSelf: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf }) }
    }
    
    public func ancestorsIncludingSelf(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(condition) })
    }
    
    public func ancestorsIncludingSelf(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(name) })
    }
    
    public func ancestorsIncludingSelf(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(while: condition) })
    }
    
    public func ancestorsIncludingSelf(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(until: condition) })
    }
    
    public func ancestorsIncludingSelf(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.ancestorsIncludingSelf(untilAndIncluding: condition) })
    }
    
    public var content: XContentSequence {
        get { XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.content }) }
    }
    
    public func content(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.content(condition) })
    }
    
    public func content(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.content(while: condition) })
    }
    
    public func content(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.content(until: condition) })
    }
    
    public func content(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.content(untilAndIncluding: condition) })
    }
    
    public var contentReversed: XContentSequence {
        get { XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed }) }
    }
    
    public func contentReversed(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(condition) })
    }
    
    public func contentReversed(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(while: condition) })
    }
    
    public func contentReversed(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(until: condition) })
    }
    
    public func contentReversed(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.contentReversed(untilAndIncluding: condition) })
    }
    
    public var texts: XTextSequence {
        get { XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.texts }) }
    }
    
    public func texts(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.texts(condition) })
    }
    
    public func texts(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.texts(while: condition) })
    }
    
    public func texts(until condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.texts(until: condition) })
    }
    
    public func texts(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.texts(untilAndIncluding: condition) })
    }
    
    public var textsReversed: XTextSequence {
        get { XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed }) }
    }
    
    public func textsReversed(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(condition) })
    }
    
    public func textsReversed(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(while: condition) })
    }
    
    public func textsReversed(until condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(until: condition) })
    }
    
    public func textsReversed(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.textsReversed(untilAndIncluding: condition) })
    }
    
    public var allTexts: XTextSequence {
        get { XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allTexts }) }
    }
    
    public func allTexts(_ condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(condition) })
    }
    
    public func allTexts(while condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(while: condition) })
    }
    
    public func allTexts(until condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(until: condition) })
    }
    
    public func allTexts(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XTextSequence {
        XTextSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allTexts(untilAndIncluding: condition) })
    }
    
    public var children: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.children }) }
    }
    
    public func children(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.children(condition) })
    }
    
    public func children(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.children(name) })
    }
    
    public func children(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.children(while: condition) })
    }
    
    public func children(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.children(until: condition) })
    }
    
    public func children(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.children(untilAndIncluding: condition) })
    }
    
    public var childrenReversed: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed }) }
    }
    
    public func childrenReversed(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(condition) })
    }
    
    public func childrenReversed(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(name) })
    }
    
    public func childrenReversed(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(while: condition) })
    }
    
    public func childrenReversed(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(until: condition) })
    }
    
    public func childrenReversed(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.childrenReversed(untilAndIncluding: condition) })
    }
    
    public var next: XContentSequence {
        get { XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.next }) }
    }
    
    public func next(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.next(condition) })
    }
    
    public func next(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.next(while: condition) })
    }
    
    public func next(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.next(until: condition) })
    }
    
    public func next(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.next(untilAndIncluding: condition) })
    }
    
    public var previous: XContentSequence {
        get { XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previous }) }
    }
    
    public func previous(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previous(condition) })
    }
    
    public func previous(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previous(while: condition) })
    }
    
    public func previous(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previous(until: condition) })
    }
    
    public func previous(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previous(untilAndIncluding: condition) })
    }
    
    public var nextElements: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.nextElements }) }
    }
    
    public func nextElements(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(condition) })
    }
    
    public func nextElements(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(name) })
    }
    
    public func nextElements(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(while: condition) })
    }
    
    public func nextElements(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(until: condition) })
    }
    
    public func nextElements(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.nextElements(untilAndIncluding: condition) })
    }
    
    public var previousElements: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previousElements }) }
    }
    
    public func previousElements(_ condition: @escaping (XContent) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(condition) })
    }
    
    public func previousElements(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(name) })
    }
    
    public func previousElements(while condition: @escaping (XContent) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(while: condition) })
    }
    
    public func previousElements(until condition: @escaping (XContent) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(until: condition) })
    }
    
    public func previousElements(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.previousElements(untilAndIncluding: condition) })
    }
    
    public var allContent: XContentSequence {
        get { XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContent }) }
    }
    
    public func allContent(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContent(condition) })
    }
    
    public func allContent(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContent(while: condition) })
    }
    
    public func allContent(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContent(until: condition) })
    }
    
    public func allContent(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContent(untilAndIncluding: condition) })
    }
    
    public var allContentIncludingSelf: XContentSequence {
        get { XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf }) }
    }
    
    public func allContentIncludingSelf(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(condition) })
    }
    
    public func allContentIncludingSelf(while condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(while: condition) })
    }
    
    public func allContentIncludingSelf(until condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(until: condition) })
    }
    
    public func allContentIncludingSelf(untilAndIncluding condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.allContentIncludingSelf(untilAndIncluding: condition) })
    }
    
    public var descendants: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.descendants }) }
    }
    
    public func descendants(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.descendants(condition) })
    }
    
    public func descendants(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.descendants(name) })
    }
    
    public func descendants(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.descendants(while: condition) })
    }
    
    public func descendants(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.descendants(until: condition) })
    }
    
    public func descendants(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { content in content.descendants(untilAndIncluding: condition) })
    }
    
    public var descendantsIncludingSelf: XElementSequence {
        get { XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { element in element.descendantsIncludingSelf }) }
    }
    
    public func descendantsIncludingSelf(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { element in element.descendantsIncludingSelf(condition) })
    }
    
    public func descendantsIncludingSelf(_ name: String) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { element in element.descendantsIncludingSelf(name) })
    }
    
    public func descendantsIncludingSelf(while condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { element in element.descendantsIncludingSelf(while: condition) })
    }
    
    public func descendantsIncludingSelf(until condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { element in element.descendantsIncludingSelf(until: condition) })
    }
    
    public func descendantsIncludingSelf(untilAndIncluding condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementSequenceDependingOnElementSequence(sequence: self, nextSequenceGetter: { element in element.descendantsIncludingSelf(untilAndIncluding: condition) })
    }
    
    public var previousTouching: XContentSequence {
        get { XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.previousTouching }) }
    }
    
    public func previousTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.previousTouching(condition) })
    }
    
    public var previousInTreeTouching: XContentSequence {
        get { XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.previousInTreeTouching }) }
    }
    
    public func previousInTreeTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.previousInTreeTouching(condition) })
    }
    
    public var nextTouching: XContentSequence {
        get { XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.nextTouching }) }
    }
    
    public func nextTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.nextTouching(condition) })
    }
    
    public var nextInTreeTouching: XContentSequence {
        get { XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.nextInTreeTouching }) }
    }
    
    public func nextInTreeTouching(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.nextInTreeTouching(condition) })
    }
    
    public var parent: XElementSequence {
        get { XElementDependingOnElementSequence(sequence: self, elementGetter: { content in content.parent }) }
    }
    
    public func parent(_ condition: @escaping (XElement) -> Bool) -> XElementSequence {
        XElementDependingOnElementSequence(sequence: self, elementGetter: { content in content.parent(condition) })
    }
    
    public func parent(_ name: String) -> XElementSequence {
        XElementDependingOnElementSequence(sequence: self, elementGetter: { content in content.parent(name) })
    }
    
    public var firstContent: XContentSequence {
        get { XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.firstContent }) }
    }
    
    public func firstContent(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.firstContent(condition) })
    }
    
    public var lastContent: XContentSequence {
        get { XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.lastContent }) }
    }
    
    public func lastContent(_ condition: @escaping (XContent) -> Bool) -> XContentSequence {
        XContentDependingOnElementSequence(sequence: self, contentGetter: { content in content.lastContent(condition) })
    }
    
    public func applying(_ f: @escaping (XElement) -> ()) -> XElementSequence {
        XElementDependingOnElementSequence(sequence: self, elementGetter: { element in f(element); return element })
    }
    
    public func add(@XContentBuilder builder: () -> [XContent]) {
        self.forEach { element in element._add(builder()) }
    }
    
    public func add(_ contentGetter: @escaping (XElement) -> [XContent]) {
        self.forEach { element in element._add(contentGetter(element)) }
    }
    
    public func addFirst(@XContentBuilder builder: () -> [XContent]) {
        self.forEach { element in element._addFirst(builder()) }
    }
    
    public func addFirst(_ contentGetter: @escaping (XElement) -> [XContent]) {
        self.forEach { element in element._addFirst(contentGetter(element)) }
    }
    
    public func setContent(_ contentGetter: @escaping (XElement) -> [XContent]) {
        self.forEach { element in element._setContent(contentGetter(element)) }
    }
    
    public func insertPrevious(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        self.forEach { element in element._insertPrevious(insertionMode, builder()) }
    }
    
    public func insertPrevious(_ insertionMode: InsertionMode = .following, _ contentGetter: @escaping (XElement) -> [XContent]) {
        self.forEach { element in element._insertPrevious(insertionMode, contentGetter(element)) }
    }
    
    public func insertNext(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        self.forEach { element in element._insertNext(insertionMode, builder()) }
    }
    
    public func insertNext(_ insertionMode: InsertionMode = .following, _ contentGetter: @escaping (XElement) -> [XContent]) {
        self.forEach { element in element._insertNext(insertionMode, contentGetter(element)) }
    }
    
    public func replace(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        self.forEach { element in element.replace(insertionMode, builder: builder) }
    }
    
    public func replace(_ insertionMode: InsertionMode = .following, _ contentGetter: (XElement) -> (() -> [XContent])) {
        self.forEach { element in element.replace(insertionMode, builder: contentGetter(element) ) }
    }
    
    public func clear() {
        self.forEach { element in element.clear() }
    }
    
    public func remove() {
        self.forEach { element in element.remove() }
    }
    
    public func echo(pretty: Bool = false, indentation: String = "  ", terminator: String = "\n") {
        self.forEach { element in element.echo(pretty: pretty, indentation: indentation, terminator: terminator) }
    }
    
}
