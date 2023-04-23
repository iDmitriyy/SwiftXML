//===--- Nodes.swift ------------------------------------------------------===//
//
// This source file is part of the SwiftXML.org open source project
//
// Copyright (c) 2021-2023 Stefan Springer (https://stefanspringer.com)
// and the SwiftXML project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
//===----------------------------------------------------------------------===//

import Foundation
import SwiftXMLInterfaces
import SwiftXMLParser

func moving(_ content: [XContent], action: () -> ()) {
    content.forEach { ($0 as? AutoCombining)?.prepareForMove() }
    action()
    content.forEach { ($0 as? AutoCombining)?.resetAfterMove() }
}

public enum InsertionMode { case skipping; case following }

public class XNode {
    
    public var attached = [String:Any]()
    
    var _sourceRange: XTextRange? = nil
    
    public var sourceRange: XTextRange? { _sourceRange }
    
    /**
     The reference to the original node after cloning.
     But this is a weak reference, the clone must be contained by
     other means to exist.
     */
    weak var _backLink: XNode? = nil
    
    public var backLink: XNode? {
        get {
            return _backLink
        }
    }
    
    public func backLink(_ condition: (XNode) -> Bool) -> XNode? {
        let node = _backLink
        if let theNode = node, condition(theNode) {
            return node
        }
        else {
            return nil
        }
    }
    
    /**
     The oldest source of cloning.
     */
    public var finalBackLink: XNode? {
        get {
            var ref = _backLink
            while let further = ref?._backLink {
                ref = further
            }
            return ref
        }
    }
    
    public func finalBackLink(_ condition: (XNode) -> Bool) -> XNode? {
        let node = finalBackLink
        if let theNode = node, condition(theNode) {
            return node
        }
        else {
            return nil
        }
    }
    
    public var backLinkPath: [XNode]? {
        get {
            var ref = _backLink
            if let theRef = ref {
                var path = [XNode]()
                path.append(theRef)
                while let further = ref?._backLink {
                    ref = further
                    path.append(further)
                }
                return path
            }
            else {
                return nil
            }
        }
    }
    
    public weak var document: XDocument? {
        get {
            return (self as? XBranchInternal)?._document ?? self.parent?._document
        }
    }
    
    /**
     Make a shallow clone (without content).
     */
    public func shallowClone() -> XNode {
        let theClone = XNode()
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public func clone() -> XNode {
        return shallowClone()
    }
    
    private var contentIterators = WeakList<XBidirectionalContentIterator>()
    
    func addContentIterator(_ nodeIterator: XBidirectionalContentIterator) {
        contentIterators.append(nodeIterator)
    }
    
    func removeContentIterator(_ nodeIterator: XBidirectionalContentIterator) {
        contentIterators.remove(nodeIterator)
    }
    
    func gotoPreviousOnContentIterators() {
        contentIterators.forEach { _ = $0.previous() }
    }
    
    func prefetchOnContentIterators() {
        contentIterators.forEach { $0.prefetch() }
    }
    
    weak var _parent: XBranchInternal? = nil
    
    public weak var parent: XElement? {
        get {
            return _parent as? XElement
        }
    }
    
    public func parent(_ condition: (XElement) -> Bool) -> XElement? {
        let element = parent
        if let theElement = element, condition(theElement) {
            return theElement
        }
        else {
            return nil
        }
    }
    
    public func parent(_ name: String) -> XElement? {
        let element = parent
        if let theElement = element, theElement.name == name {
            return theElement
        }
        else {
            return nil
        }
    }
    
    public func parent(_ names: [String]) -> XElement? {
        let element = parent
        if let theElement = element, names.contains(theElement.name) {
            return theElement
        }
        else {
            return nil
        }
    }
    
    public func parent(_ names: String...) -> XElement? {
        parent(names)
    }
    
    weak var _previous: XContent? = nil
    var _next: XContent? = nil
    
    var hasPrevious: Bool { _previous != nil }
    var hasNext: Bool { _previous != nil }
    
    public var previousTouching: XContent? {
        get {
            var content = _previous
            while let spot = content as? _Isolator_ {
                content = spot._previous
            }
            return content
        }
    }
    
    public var nextTouching: XContent? {
        get {
            var content = _next
            while let spot = content as? _Isolator_ {
                content = spot._next
            }
            return content
        }
    }
    
    public func previousTouching(_ condition: (XContent) -> Bool) -> XContent? {
        let content = previousTouching
        if let theContent = content, condition(theContent) {
            return theContent
        }
        else {
            return nil
        }
    }
    
    public func nextTouching(_ condition: (XContent) -> Bool) -> XContent? {
        let content = nextTouching
        if let theContent = content, condition(theContent) {
            return theContent
        }
        else {
            return nil
        }
    }
    
    weak var _previousInTree: XNode? = nil
    weak var _nextInTree: XNode? = nil
    
    public var previousInTreeTouching: XContent? {
        get {
            var content = _previousInTree
            while let spot = content as? _Isolator_ {
                content = spot._previousInTree
            }
            return content as? XContent
        }
    }
    
    public var nextInTreeTouching: XContent? {
        get {
            var content = _nextInTree
            while let spot = content as? _Isolator_ {
                content = spot._nextInTree
            }
            return content as? XContent
        }
    }
    
    public func previousInTreeTouching(_ condition: (XContent) -> Bool) -> XContent? {
        let content = previousInTreeTouching
        if let theContent = content, condition(theContent) {
            return theContent
        }
        else {
            return nil
        }
    }
    
    public func nextInTreeTouching(_ condition: (XContent) -> Bool) -> XContent? {
        let content = nextInTreeTouching
        if let theContent = content, condition(theContent) {
            return theContent
        }
        else {
            return nil
        }
    }
    
    func getLastInTree() -> XNode {
        return self
    }
    
    public var lastInTree: XNode { get { getLastInTree() } }
    
    public func applying(_ f: (XNode) -> ()) -> XNode {
        f(self)
        return self
    }
    
    public func havingProperties(_ f: (XNode) -> Bool) -> XNode? {
        return f(self) ? self : nil
    }
    
    public func hasProperties(_ f: (XNode) -> Bool) -> Bool {
        return f(self)
    }
    
    public func traverse(down: (XNode) throws -> (), up: ((XNode) throws -> ())? = nil) rethrows {
        let directionIndicator = XDirectionIndicator()
        try XTraversalSequence(node: self, directionIndicator: directionIndicator).forEach { node in
            if directionIndicator.up {
                if let branch = node as? XBranchInternal {
                    try up?(branch)
                }
            }
            else {
                try down(node)
            }
        }
    }
    
    public func traverse(down: (XNode) async throws -> (), up: ((XNode) async throws -> ())? = nil) async rethrows {
        let directionIndicator = XDirectionIndicator()
        try await XTraversalSequence(node: self, directionIndicator: directionIndicator).forEachAsync { node in
            if directionIndicator.up {
                if let branch = node as? XBranchInternal {
                    try await up?(branch)
                }
            }
            else {
                try await down(node)
            }
        }
    }
    
    func produceEntering(production: XProduction) throws {
        // to be implemented by subclass
    }
    
    public func applyProduction(production: XProduction) throws {
        try (self as? XDocument)?.produceEntering(production: production)
        try traverse { node in
            try node.produceEntering(production: production)
        } up: { branch in
            if let element = branch as? XElement {
                try element.produceLeaving(production: production)
            }
            else if let document = branch as? XDocument {
                try document.produceLeaving(production: production)
            }
        }
        try (self as? XDocument)?.produceLeaving(production: production)
    }
    
    public func write(toWriter writer: Writer, usingProduction production: XProduction = XDefaultProduction()) throws {
        production.setWriter(writer)
        try self.applyProduction(production: production)
    }
    
    public func write(toFileHandle fileHandle: FileHandle, usingProduction production: XProduction = XDefaultProduction()) throws {
        try write(toWriter: FileWriter(fileHandle), usingProduction: production)
    }
    
    public func write(toFile path: String, usingProduction production: XProduction = XDefaultProduction()) throws {
        let fileManager = FileManager.default
    
        fileManager.createFile(atPath: path,  contents:Data("".utf8), attributes: nil)
        
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            try write(toFileHandle: fileHandle, usingProduction: production)
            fileHandle.closeFile()
        }
        else {
            print("ERROR: cannot write to [\(path)]");
        }
        
    }
    
    public func write(toURL url: URL, usingProduction production: XProduction = XDefaultProduction()) throws {
        try write(toFile: url.path, usingProduction: production)
    }
    
    public func echo(usingProduction production: XProduction, terminator: String = "\n") {
        do {
            try write(toFileHandle: FileHandle.standardOutput, usingProduction: production); print(terminator, terminator: "")
        }
        catch {
            // writing to standard output does not really throw
        }
    }
    
    public func echo(pretty: Bool = false, indentation: String = "  ", terminator: String = "\n") {
        echo(usingProduction: pretty ? XPrettyPrintProduction(indentation: indentation) : XDefaultProduction(), terminator: terminator)
    }
    
    public func serialized(usingProduction production: XProduction) -> String {
        let writer = CollectingWriter()
        do {
            try write(toWriter: writer, usingProduction: production)
        }
        catch {
            // CollectingWriter does not really throw
        }
        return writer.description
    }
    
    public func serialized(pretty: Bool = false, indentation: String = "  ") -> String {
        serialized(usingProduction: pretty ? XPrettyPrintProduction(indentation: indentation) : XDefaultProduction())
    }
    
    public var text: String {
        if let meAsBranch = self as? XBranch {
            if let text = meAsBranch.firstContent as? XText, text._next == nil {
                return text.value
            }
            var texts = [String]()
            meAsBranch.traverse { node in
                if let text = node as? XText {
                    texts.append(text.value)
                }
            }
            return texts.joined()
        }
        else if let meAsText = self as? XText {
            return meAsText.value
        }
        else {
            return ""
        }
    }
}

public class XContent: XNode {
    
    public override func clone() -> XContent {
        _ = super.clone()
        return self
    }
    
    public override func shallowClone() -> XContent {
        _ = super.shallowClone()
        return self
    }
    
    /**
     Correct the tree order after this node has been inserted.
     */
    func setTreeOrderWhenInserting() {
        
        let lastInMyTree = getLastInTree()
        
        // set _previousInTree & _nextInTree for "self" tree:
        self._previousInTree = _previous?.getLastInTree() ?? _parent
        lastInMyTree._nextInTree = self._previousInTree?._nextInTree // let it be nil for the last node in the document!
        
        // set _previousInTree or _nextInTree for them:
        self._previousInTree?._nextInTree = self
        lastInMyTree._nextInTree?._previousInTree = lastInMyTree
        
        // set _lastInTree:
        if self === _parent?.__lastContent, let oldParentLastInTree = _parent?.lastInTree {
            var ancestor = _parent
            repeat {
                if let element = ancestor as? XElement {
                    element._lastInTree = lastInMyTree
                }
                else if let document = ancestor as? XDocument {
                    document._lastInTree = lastInMyTree
                }
                ancestor = ancestor?._parent
            } while ancestor?.getLastInTree() === oldParentLastInTree
        }
    }
    
    func setTreeOrderWhenRemoving() {
        
        let theLastInTree = getLastInTree()
        
        // correct _previousInTree and _nextInTree for remaining tree:
        _previousInTree?._nextInTree = theLastInTree._nextInTree
        theLastInTree._nextInTree?._previousInTree = _previousInTree
        
        // set _lastInTree for remaining tree:
        var ancestor = _parent
        while let theAncestor = ancestor, theAncestor.getLastInTree() === theLastInTree {
            if let element = theAncestor as? XElement {
                element._lastInTree = _previousInTree ?? theAncestor
            }
            else if let document = theAncestor as? XDocument {
                document._lastInTree = _previousInTree ?? theAncestor
            }
            ancestor = ancestor?._parent
        }
        
        // correct in own tree:
        _previousInTree = nil
        theLastInTree._nextInTree = nil
    }
    
    /**
     Removes the node from the tree structure and the tree order,
     but keeps it in the document.
     */
    func _removeKeep() {
        
        let oldPrevious = _previous
        let oldNext = _next
        
        // correction in iterators:
        gotoPreviousOnContentIterators()
        
        // tree order:
        setTreeOrderWhenRemoving()
        
        // tree structure:
        if let thePrevious = _previous {
            thePrevious._next = _next
        }
        if let theNext = _next {
            theNext._previous = _previous
        }
        if let theParent = _parent {
            if theParent.__firstContent === self {
                theParent.__firstContent = _next
            }
            if theParent.__lastContent === self {
                theParent.__lastContent = _previous
            }
        }
        
        _next = nil
        _previous = nil
        _parent = nil
        
        if let thePreviousText = oldPrevious as? XText, let theNextText = oldNext as? XText, !(thePreviousText.isolated || theNextText.isolated) {
            thePreviousText.value += theNextText.value
            thePreviousText._whitespace = thePreviousText._whitespace + theNextText._whitespace
            theNextText.value = ""
        } else if let thePreviousLiteral = oldPrevious as? XLiteral, let theNextLiteral = oldNext as? XLiteral, !(thePreviousLiteral.isolated || theNextLiteral.isolated) {
            thePreviousLiteral.value += theNextLiteral.value
            theNextLiteral.value = ""
        }
    }
    
    /**
     Removes the content from the tree structure and the tree order and
     the document.
     */
    public func remove() {
        _removeKeep()
        if let meAsElement = self as? XElement {
            meAsElement.gotoPreviousOnNameIterators()
            meAsElement.document?.unregisterElement(element: meAsElement)
        }
    }
    
    public override var previousInTreeTouching: XContent? { get { _previousInTree as? XContent } }
    public override var nextInTreeTouching: XContent? { get { _nextInTree as? XContent } }
    
    public override var lastInTree: XContent { get { getLastInTree() as! XContent } }
    
    func _insertPrevious(_ node: XContent) {
        
        func _insertPreviousBase(_ node: XContent) {
            node._removeKeep()
            
            if _parent?.__firstContent === self {
                _parent?.__firstContent = node
            }
            
            _previous?._next = node
            node._previous = _previous
            node._next = self
            _previous = node
            node._parent = _parent
            
            // set tree order:
            node.setTreeOrderWhenInserting()
            
            // set document:
            if let theDocument = _parent?._document, let element = node as? XElement, !(element._document === theDocument) {
                element.setDocument(document: theDocument)
            }
        }
        
        if let newAsText = node as? XText {
            if !newAsText.isolated {
                if let selfAsText = self as? XText, !selfAsText.isolated {
                    selfAsText._value = newAsText._value + selfAsText._value
                    selfAsText._whitespace = newAsText._whitespace + selfAsText._whitespace
                    newAsText.value = ""
                    return
                }
                if let previousAsText = _previous as? XText, !previousAsText.isolated {
                    previousAsText._value = previousAsText._value + newAsText._value
                    previousAsText._whitespace = previousAsText._whitespace + newAsText._whitespace
                    newAsText.value = ""
                    return
                }
            }
            _insertPreviousBase(node)
            return
        }
        
        if let newAsLiteral = node as? XLiteral {
            if !newAsLiteral.isolated {
                if let selfAsLiteral = self as? XText, !selfAsLiteral.isolated {
                    selfAsLiteral._value = newAsLiteral._value + selfAsLiteral._value
                    newAsLiteral.value = ""
                    return
                }
                if let previousAsLiteral = _previous as? XLiteral, !previousAsLiteral.isolated {
                    previousAsLiteral._value = previousAsLiteral._value + newAsLiteral._value
                    newAsLiteral.value = ""
                    return
                }
            }
            _insertPreviousBase(node)
            return
        }
        
        _insertPreviousBase(node)
    }
    
    func _insertPrevious(_ text: String) {
        if !text.isEmpty {
            if let selfAsText = self as? XText, !selfAsText.isolated {
                selfAsText._value = text + selfAsText._value
                selfAsText._whitespace = .UNKNOWN
            } else if let previousAsText = _previous as? XText, !previousAsText.isolated {
                previousAsText._value = previousAsText._value + text
                previousAsText._whitespace = .UNKNOWN
            } else {
                _insertPrevious(XText(text))
            }
        }
    }
    
    func _insertPrevious(_ insertionMode: InsertionMode, _ content: [XContent]) {
        if insertionMode == .skipping {
            prefetchOnContentIterators()
        }
        let isolator = _Isolator_()
        _insertPrevious(isolator)
        moving(content) {
            content.forEach { isolator._insertPrevious($0) }
        }
        isolator.remove()
    }
    
    public func insertPrevious(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        _insertPrevious(insertionMode, builder())
    }
    
    func _insertNext(_ node: XContent) {
        
        func _insertNextBase(_ node: XContent) {
            node._removeKeep()
            
            if _parent?.__lastContent === self {
                _parent?.__lastContent = node
            }
            
            _next?._previous = node
            node._previous = self
            node._next = _next
            _next = node
            node._parent = _parent
            
            // set tree order:
            node.setTreeOrderWhenInserting()
            
            // set document:
            if let theDocument = _parent?._document, let element = node as? XElement, !(element._document === theDocument) {
                element.setDocument(document: theDocument)
            }
        }
        
        if let newAsText = node as? XText, !newAsText.isolated {
            if let selfAsText = self as? XText, !selfAsText.isolated {
                selfAsText._value = selfAsText._value + newAsText._value
                selfAsText._whitespace = selfAsText._whitespace + newAsText._whitespace
                newAsText.value = ""
                return
            }
            if let nextAsText = _next as? XText, !nextAsText.isolated {
                nextAsText._value = newAsText._value + nextAsText._value
                nextAsText._whitespace = newAsText._whitespace + nextAsText._whitespace
                newAsText.value = ""
                return
            }
            _insertNextBase(node)
            return
        }
        
        if let newAsLiteral = node as? XText, !newAsLiteral.isolated {
            if let selfAsLiteral = self as? XText, !selfAsLiteral.isolated {
                selfAsLiteral._value = selfAsLiteral._value + newAsLiteral._value
                newAsLiteral.value = ""
                return
            }
            if let nextAsLiteral = _next as? XText, !nextAsLiteral.isolated {
                nextAsLiteral._value = newAsLiteral._value + nextAsLiteral._value
                newAsLiteral.value = ""
                return
            }
            _insertNextBase(node)
            return
        }
        
        _insertNextBase(node)
    }
    
    func _insertNext(_ text: String) {
        if !text.isEmpty {
            if let selfAsText = self as? XText, !selfAsText.isolated {
                selfAsText._value = selfAsText._value + text
                selfAsText._whitespace = .UNKNOWN
            } else if let nextAsText = self as? XText, !nextAsText.isolated {
                nextAsText._value = text + nextAsText._value
                nextAsText._whitespace = .UNKNOWN
            } else {
                _insertNext(XText(text))
            }
        }
    }
    
    func _insertNext(_ insertionMode: InsertionMode, _ content: [XContent]) {
        if insertionMode == .skipping {
            prefetchOnContentIterators()
        }
        let isolator = _Isolator_()
        _insertNext(isolator)
        moving(content) {
            content.forEach { isolator._insertPrevious($0) }
        }
        isolator.remove()
    }
    
    public func insertNext(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        _insertNext(insertionMode, builder())
    }
    
    /**
     Replace the node by other nodes.
     */
    public func replace(_ insertionMode: InsertionMode = .following, _ content: [XContent]) {
        if insertionMode == .following {
            gotoPreviousOnContentIterators()
        }
        else {
            prefetchOnContentIterators()
        }
        let isolator = _Isolator_()
        _insertPrevious(isolator)
        moving(content) {
            content.forEach { isolator._insertPrevious($0) }
        }
        if isolator._next === self {
            remove()
        }
        isolator.remove()
    }
    
    public func replace(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        replace(insertionMode, builder())
    }
    
    public var asSequence: XContentSequence { get { XContentSelfSequence(content: self) } }
    
}

public extension String {
    var asSequence: XContentSequence { get { XText(self).asSequence } }
}

class _Isolator_: XContent {
    
    public override init() {}
}

public protocol XBranch: XNode {
    var firstContent: XContent? { get }
    func firstContent(_ condition: (XContent) -> Bool) -> XContent?
    var lastContent: XContent? { get }
    func lastContent(_ condition: (XContent) -> Bool) -> XContent?
    var isEmpty: Bool { get }
    func add(@XContentBuilder builder: () -> [XContent])
    func addFirst(@XContentBuilder builder: () -> [XContent])
    func setContent(@XContentBuilder builder: () -> [XContent])
    func clear()
    func trimWhiteSpace()
}

protocol XBranchInternal: XBranch {
    var __firstContent: XContent? { get set }
    var __lastContent: XContent? { get set }
    var _document: XDocument? { get set }
    //var _lastInTree: XNode! { get set }
}

extension XBranchInternal {
    
    /**
     I am the clone, add the content!
     */
    func _addClones(from source: XBranchInternal, pointingToClone: Bool = false) {
        source.content.forEach { node in
            // we need a reference from the clone to the origin first:
            _add(node.shallowClone())
        }
        allContent.forEach { node in
            if let element = node as? XElement {
                // using the reference to the origin here:
                (element._backLink as? XElement)?.content.forEach { node in
                    element._add(node.shallowClone())
                }
            }
            // change the reference if desired differently:
            if pointingToClone {
                let source = node._backLink
                node._backLink = source?._backLink
                source?._backLink = node
            }
        }
    }
    
    var _firstContent: XContent? {
        get {
            var content = __firstContent
            while let spot = content as? _Isolator_ {
                content = spot._next
            }
            return content
        }
    }
    
    public var firstContent: XContent? { _firstContent }
    
    func _firstContent(_ condition: (XContent) -> Bool) -> XContent? {
        let node = firstContent
        if let theNode = node, condition(theNode) {
            return node
        }
        else {
            return nil
        }
    }
    
    public func firstContent(_ condition: (XContent) -> Bool) -> XContent? {
        return _firstContent(condition)
    }
    
    var _lastContent: XContent? {
        get {
            var content = __lastContent
            while let spot = content as? _Isolator_ {
                content = spot._previous
            }
            return content
        }
    }
    
    public var lastContent: XContent? { _lastContent }
    
    func _lastContent(_ condition: (XContent) -> Bool) -> XContent? {
        let node = lastContent
        if let theNode = node, condition(theNode) {
            return node
        }
        else {
            return nil
        }
    }
    
    public func lastContent(_ condition: (XContent) -> Bool) -> XContent? {
        return _lastContent(condition)
    }
    
    public var singleContent: XContent? { _singleContent }
    
    public var _singleContent: XContent? {
        if let firstContent, firstContent.nextTouching == nil {
            return firstContent
        } else {
            return nil
        }
    }
    
    var _isEmpty: Bool { _firstContent == nil }
    
    public var isEmpty: Bool { _isEmpty }
    
    /**
     Clear the contents of the node.
     */
    public func _clear() {
        var node = __firstContent
        while let theNode = node {
            theNode.remove()
            node = theNode._next
        }
    }
    
    /**
     Clear the contents of the node.
     */
    public func clear() {
        _clear()
    }
    
    /**
     Add content as last content.
     */
    func _add(_ node: XContent) {
        if let lastAsText = lastContent as? XText, let newAsText = node as? XText, !(lastAsText.isolated || newAsText.isolated) {
            lastAsText._value = lastAsText._value + newAsText._value
            lastAsText._whitespace = lastAsText._whitespace + newAsText._whitespace
            newAsText.value = ""
        }
        else if let lastAsLiteral = lastContent as? XLiteral, let newAsLiteral = node as? XLiteral, !(lastAsLiteral.isolated || newAsLiteral.isolated) {
            lastAsLiteral._value = lastAsLiteral._value + newAsLiteral._value
            newAsLiteral.value = ""
        }
        else {
            node._removeKeep()
            
            // insert into new chain:
            if let theLastChild = __lastContent {
                theLastChild._next = node
                node._previous = theLastChild
            }
            else {
                __firstContent = node
                node._previous = nil
            }
            __lastContent = node
            node._next = nil
            
            // set parent:
            node._parent = self
            
            // set tree order:
            node.setTreeOrderWhenInserting()
            
            // set document:
            if _document != nil, let element = node as? XElement, !(element._document === _document) {
                element.setDocument(document: _document)
            }
        }
    }
    
    func _add(_ text: String) {
        if !text.isEmpty {
            if let lastAsText = lastContent as? XText {
                lastAsText._value = lastAsText._value + text
                lastAsText._whitespace = .UNKNOWN
            }
            else {
                _add(XText(text))
            }
        }
    }
    
    func _add(_ content: [XContent]) {
        moving(content) {
            content.forEach { _add($0) }
        }
    }
    
    public func add(@XContentBuilder builder: () -> [XContent]) {
        return _add(builder())
    }
    
    /**
     Add content as first content.
     */
    func _addFirst(_ node: XContent) {
        if let firstAsText = firstContent as? XText, let newAsText = node as? XText, !(firstAsText.isolated || newAsText.isolated) {
            firstAsText._value = newAsText._value + firstAsText._value
            firstAsText._whitespace = newAsText._whitespace + firstAsText._whitespace
            newAsText.value = ""
        }
        else if let firstAsLiteral = firstContent as? XLiteral, let newAsLiteral = node as? XLiteral, !(firstAsLiteral.isolated || newAsLiteral.isolated) {
            firstAsLiteral._value = newAsLiteral._value + firstAsLiteral._value
            newAsLiteral.value = ""
        }
        else {
            node._removeKeep()
            
            // insert into new chain:
            if let theFirstChild = __firstContent {
                theFirstChild._previous = node
                node._next = theFirstChild
            }
            else {
                __lastContent = node
                node._next = nil
            }
            __firstContent = node
            node._previous = nil
            
            // set parent:
            node._parent = self
            
            // set tree order:
            node.setTreeOrderWhenInserting()
            
            // set document:
            if _document != nil, let element = node as? XElement, !(element._document === _document) {
                element.setDocument(document: _document)
            }
        }
    }
    
    func _addFirst(_ text: String) {
        if !text.isEmpty {
            if let firstAsText = firstContent as? XText {
                firstAsText._value = text + firstAsText._value
                firstAsText._whitespace = .UNKNOWN
            }
            else {
                _addFirst(XText(text))
            }
        }
    }
    
    func _addFirst(_ content: [XContent]) {
        moving(content) {
            content.reversed().forEach { _addFirst($0) }
        }
    }
    
    public func addFirst(@XContentBuilder builder: () -> [XContent]) {
        _addFirst(builder())
    }
    
    /**
     Set the contents of the branch.
     */
    func _setContent(_ content: [XContent]) {
        let isolator = _Isolator_()
        _addFirst(isolator)
        moving(content) {
            content.forEach { isolator._insertPrevious($0) }
        }
        isolator.next.forEach { $0.remove() }
        isolator.remove()
    }
    
    /**
     Set the contents of the branch.
     */
    public func setContent(@XContentBuilder builder: () -> [XContent]) {
        _setContent(builder())
    }
    
    func produceLeaving(production: XProduction) throws {
        // to be implemented by subclass
    }
    
    func _trimWhiteSpace() {
        self.traverse { node in
            if let text = node as? XText {
                text.value = text.value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
}

public protocol XContentLike {}

extension XContent: XContentLike {}

extension String: XContentLike {}

extension XContentSequence: XContentLike {}
extension XElementSequence: XContentLike {}
extension XContentLikeSequence: XContentLike {}

extension Array: XContentLike where Element == XContentLike? {}

public extension Array where Element == XContentLike? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XElement {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XElement? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XText {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XText? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XInternalEntity {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XInternalEntity? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XExternalEntity {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XExternalEntity? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XCDATASection {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XCDATASection? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XProcessingInstruction {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XProcessingInstruction? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XComment {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension Array where Element == XComment? {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromArray(fromArray: self) }
    }
}

public extension LazyFilterSequence where Base == XElementSequence {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromLazyElementFilterSequence(fromSequence: self) }
    }
}

public extension LazyFilterSequence where Base == XContentSequence {
    var asContent: XContentLikeSequence {
        get { XContentLikeSequenceFromLazyContentFilterSequence(fromSequence: self) }
    }
}

final class AttributeProperties {
    
    private var attributeIterators = WeakList<XBidirectionalAttributeIterator>()
    
    func addAttributeIterator(_ attributeIterator: XBidirectionalAttributeIterator) {
        attributeIterators.append(attributeIterator)
    }
    
    func removeAttributeIterator(_ attributeIterator: XBidirectionalAttributeIterator) {
        attributeIterators.remove(attributeIterator)
    }
    
    func gotoPreviousOnAttributeIterators() {
        attributeIterators.forEach { _ = $0.previous() }
    }
    
    func prefetchOnAttributeIterators() {
        attributeIterators.forEach { $0.prefetch() }
    }
    
    var value: String
    weak var element: XElement?
    
    weak var previousWithSameName: AttributeProperties? = nil
    var nextWithSameName: AttributeProperties? = nil
    
    init(value: String, element: XElement) {
        self.value = value
        self.element = element
    }
    
    // prevent stack overflow when destroying the list of elements with same name,
    // to be applied on the first element in that list,
    // cf. https://forums.swift.org/t/deep-recursion-in-deinit-should-not-happen/54987
    // !!! This should not be necessary anymore with Swift 5.7 or on masOS 13. !!!
    func removeFollowingWithSameName() {
        var node = self
        while isKnownUniquelyReferenced(&node.nextWithSameName) {
            (node, node.nextWithSameName) = (node.nextWithSameName!, nil)
        }
    }
}

final class XNodeSampler {
    
    var nodes = [XContent]()
    
    func add(_ thing: XContentLike) {
        if let node = thing as? XContent {
            nodes.append(node)
        }
        else if let s = thing as? String {
            nodes.append(XText(s))
        }
        else if let sequence = thing as? XContentSequence {
            sequence.forEach { self.add($0) }
        }
        else if let sequence = thing as? XElementSequence {
            sequence.forEach { self.add($0) }
        }
        else if let sequence = thing as? XContentLikeSequence {
            sequence.forEach { self.add($0) }
        }
        else if let array = thing as? [XContentLike?] {
            array.forEach { if let contentLike = $0 { self.add(contentLike) } }
        }
    }
}

@resultBuilder
public struct XContentBuilder {
    
    public static func buildBlock(_ components: XContentLike?...) -> [XContent] {
        let sampler = XNodeSampler()
        components.forEach { if let nodeLike = $0 { sampler.add(nodeLike) } }
        return sampler.nodes
    }
    
    @available(macOS 13.0.0, *)
    public static func buildBlock<T: XContent>(_ sequences: any Sequence<T>...) -> [XContent] {
        let sampler = XNodeSampler()
        sequences.forEach{ $0.forEach { sampler.add($0 as! XContent) } }
        return sampler.nodes
    }
    
}

public final class XElement: XContent, XBranchInternal, CustomStringConvertible {
    
    func setDocument(document newDocument: XDocument?) {
        
        // set document:
        var node: XNode? = self
        repeat {
            if let element = node as? XElement {
                if !(newDocument === element._document) {
                    element._document?.unregisterElement(element: element)
                    element._document = newDocument
                    newDocument?.registerElement(element: element)
                }
            }
            if self._lastInTree === node {
                break
            }
            node = node?._nextInTree
        } while node != nil
    }
    
    var __firstContent: XContent?
    
    var __lastContent: XContent?
    
    weak var _lastInTree: XNode!
    
    override func getLastInTree() -> XNode {
        return _lastInTree
    }
    
    weak var _document: XDocument? = nil
    
    private var elementIterators = WeakList<XBidirectionalElementIterator>()
    
    func addElementIterator(_ elementIterator: XBidirectionalElementIterator) {
        elementIterators.append(elementIterator)
    }
    
    func removeElementIterator(_ elementIterator: XBidirectionalElementIterator) {
        elementIterators.remove(elementIterator)
    }
    
    func gotoPreviousOnElementIterators() {
        elementIterators.forEach { _ = $0.previous() }
    }
    
    func prefetchOnElementIterators() {
        elementIterators.forEach { $0.prefetch() }
    }
    
    private var nameIterators = WeakList<XElementNameIterator>()
        
    func addNameIterator(_ elementIterator: XElementNameIterator) {
        nameIterators.append(elementIterator)
    }
    
    func removeNameIterator(_ elementIterator: XElementNameIterator) {
        nameIterators.remove(elementIterator)
    }
    
    func gotoPreviousOnNameIterators() {
        nameIterators.forEach { _ = $0.previous() }
    }
    
    func prefetchOnNameIterators() {
        nameIterators.forEach { $0.prefetch() }
    }
    
    var _attributes = [String:AttributeProperties]()
    
    public override var backLink: XElement? { get { super.backLink as? XElement } }
    public override var finalBackLink: XElement? { get { super.finalBackLink as? XElement } }
    
    public var description: String {
        get {
            """
            <\(name)\(_attributes.isEmpty == false ? " " : "")\(_attributes.map { (attributeName,attributeValue) in "\(attributeName)=\"\(escapeDoubleQuotedValue(attributeValue.value))\"" }.joined(separator: " ") ?? "")>
            """
        }
    }
    
    public func copyAttributes(from other: XElement) {
        for (attributeName,attributeValue) in other._attributes {
            self[attributeName] = attributeValue.value
        }
    }
    
    public override func shallowClone() -> XElement {
        let theClone = XElement(name)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        theClone.copyAttributes(from: self)
        return theClone
    }
    
    public override func clone() -> XElement {
        let theClone = shallowClone()
        theClone._addClones(from: self)
        return theClone
    }
    
    public override func applying(_ f: (XElement) -> ()) -> XElement {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XElement) -> Bool) -> XElement? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XElement) -> Bool) -> Bool {
        return f(self)
    }
    
    var _name: String
    
    public var name: String {
        get { _name }
        set(newName) {
            if newName != _name {
                if let theDocument = _document {
                    gotoPreviousOnNameIterators()
                    nameIterators.forEach { _ = $0.previous() }
                    theDocument.unregisterElement(element: self)
                    _name = newName
                    theDocument.registerElement(element: self)
                }
                else {
                    _name = newName
                }
            }
        }
    }
    
    public func hasEqualValues(as other: XElement) -> Bool {
        return self.name == other.name
        && self.attributeNames.allSatisfy { self[$0] == other[$0] }
            && other.attributeNames.allSatisfy { self[$0] != nil }
    }
    
    public var xPath: String {
        get {
            let myName = name
            return "/" + ([
                self.ancestors.reversed().map {
                    let itsName = $0.name
                    return "\(itsName)[\($0.previousElements.filter { $0.name == itsName }.count+1)]"
                }.joined(separator: "/"),
                "\(name)[\(previousElements.filter { $0.name == myName }.count+1)]"
            ].joinedNonEmpties(separator: "/") ?? "")
        }
    }
    
    public var attributeNames: [String] {
        get {
            return Array(_attributes.keys)
        }
    }
    
    weak var previousWithSameName: XElement? = nil
    var nextWithSameName: XElement? = nil
    
    public var asElementSequence: XElementSequence { get { XElementSelfSequence(element: self) } }
    
    override func _insertPrevious(_ insertionMode: InsertionMode, _ content: [XContent]) {
        if insertionMode == .skipping {
            prefetchOnElementIterators()
        }
        super._insertPrevious(insertionMode, content)
    }
    
    override func _insertNext(_ insertionMode: InsertionMode, _ content: [XContent]) {
        if insertionMode == .skipping {
            prefetchOnElementIterators()
        }
        super._insertNext(insertionMode, content)
    }
    
    /**
     Replace the node by other nodes.
     */
    public override func replace(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        if insertionMode == .following {
            gotoPreviousOnElementIterators()
        }
        else {
            prefetchOnElementIterators()
        }
        super.replace(insertionMode, builder: builder)
    }
    
    // ------------------------------------------------------------------------
    // repeat methods from XBranchInternal:
    
    public var firstContent: XContent? { _firstContent }
    
    public func firstContent(_ condition: (XContent) -> Bool) -> XContent? {
        return _firstContent(condition)
    }
    
    public var lastContent: XContent? { _lastContent }
    
    public func lastContent(_ condition: (XContent) -> Bool) -> XContent? {
        return _lastContent(condition)
    }
    
    public var singleContent: XContent? { _singleContent }
    
    public var isEmpty: Bool { _isEmpty }
    
    public func add(@XContentBuilder builder: () -> [XContent]) {
        return _add(builder())
    }
    
    public func addFirst(@XContentBuilder builder: () -> [XContent]) {
        return _addFirst(builder())
    }
    
    public func setContent(@XContentBuilder builder: () -> [XContent]) {
        return _setContent(builder())
    }
    
    public func clear() {
        return _clear()
    }
    
    // ------------------------------------------------------------------------
    
    // prevent stack overflow when destroying the list of elements with same name,
    // to be applied on the first element in that list,
    // cf. https://forums.swift.org/t/deep-recursion-in-deinit-should-not-happen/54987
    // !!! This should not be necessary anymore with Swift 5.7 or on masOS 13. !!!
    func removeFollowingWithSameName() {
        var node = self
        while isKnownUniquelyReferenced(&node.nextWithSameName) {
            (node, node.nextWithSameName) = (node.nextWithSameName!, nil)
        }
    }
    
    public subscript(attributeName: String) -> String? {
        get {
            return _attributes[attributeName]?.value
        }
        set(newValue) {
            if let theNewValue = newValue {
                if let existingAttribute = _attributes[attributeName] {
                    let oldValue = existingAttribute.value
                    existingAttribute.value = theNewValue
                    _document?.attributeValueChanged(element: self, name: attributeName, oldValue: oldValue, newValue: theNewValue)
                }
                else {
                    let newAttribute = AttributeProperties(value: theNewValue, element: self)
                    _attributes[attributeName] = newAttribute
                    _document?.registerAttribute(attributeProperties: newAttribute, withName: attributeName)
                    _document?.attributeValueChanged(element: self, name: attributeName, oldValue: nil, newValue: theNewValue)
                }
            }
            else if let existingAttribute = _attributes.removeValue(forKey: attributeName) {
                let oldValue = existingAttribute.value
                _attributes[attributeName] = nil
                _document?.unregisterAttribute(attributeProperties: existingAttribute, withName: attributeName)
                _document?.attributeValueChanged(element: self, name: attributeName, oldValue: oldValue, newValue: nil)
            }
        }
    }
    
    public init(_ name: String, _ attributes: [String:String?]? = nil, attached: [String:Any?]? = nil) {
        self._name = name
        super.init()
        self._lastInTree = self
        if let theAttributes = attributes {
            setAttributes(attributes: theAttributes)
        }
        attached?.forEach { (key,value) in
            if let value {
                self.attached[key] =  value
            }
        }
    }
    
    public convenience init(_ name: String, _ attributes: [String:String?]? = nil, attached: [String:Any?]? = nil, adjustDocument _adjustDocument: Bool = false, @XContentBuilder builder: () -> [XContent]) {
        self.init(name, attributes, attached: attached)
        self.add(builder: builder)
        if _adjustDocument {
            adjustDocument()
        }
    }
    
    init(_ name: String, document: XDocument) {
        self._name = name
        super.init()
        self._document = document
    }
    
    public override func _removeKeep() {
        
        // correction in iterators:
        gotoPreviousOnElementIterators()
        _attributes.values.forEach { attributeProperty in
            attributeProperty.gotoPreviousOnAttributeIterators()
        }
        
        super._removeKeep()
    }
    
    func setAttributes(attributes newAtttributeValues: [String:String?]? = nil) {
        newAtttributeValues?.forEach { name, value in
            self[name] = value
        }
    }
    
    public func adjustDocument() {
        setDocument(document: _document)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeElementStartBeforeAttributes(element: self)
        try production.sortAttributeNames(attributeNames: Array(_attributes.keys), element: self).forEach { attributeName in
            try production.writeAttribute(name: attributeName, value: self[attributeName]!, element: self)
        }
        try production.writeElementStartAfterAttributes(element: self)
    }
    
    func produceLeaving(production: XProduction) throws {
        try production.writeElementEnd(element: self)
    }
    
    public func trimWhiteSpace() {
        self._trimWhiteSpace()
    }
    
    public func trimmimgWhiteSpace() -> XElement {
        self._trimWhiteSpace()
        return self
    }
}

protocol AutoCombining {
    func prepareForMove()
    func resetAfterMove()
}

public final class XText: XContent, AutoCombining, CustomStringConvertible {
    
    var _textIterators = WeakList<XBidirectionalTextIterator>()
    
    func gotoPreviousOnTextIterators() {
        _textIterators.forEach { _ = $0.previous() }
    }
    
    func prefetchOnTextIterators() {
        _textIterators.forEach { $0.prefetch() }
    }
    
    func addTextIterator(_ textIterator: XBidirectionalTextIterator) {
        _textIterators.append(textIterator)
    }
    
    func removeTextIterator(_ textIterator: XBidirectionalTextIterator) {
        _textIterators.remove(textIterator)
    }
    
    public override func _removeKeep() {
        
        // correction in iterators:
        _textIterators.forEach { _ = $0.previous() }
        
        super._removeKeep()
    }
    
    override func _insertPrevious(_ insertionMode: InsertionMode, _ content: [XContent]) {
        if insertionMode == .skipping {
            prefetchOnTextIterators()
        }
        super._insertPrevious(insertionMode, content)
    }
    
    override func _insertNext(_ insertionMode: InsertionMode, _ content: [XContent]) {
        if insertionMode == .skipping {
            prefetchOnTextIterators()
        }
        super._insertNext(insertionMode, content)
    }
    
    public override func replace(_ insertionMode: InsertionMode = .following, @XContentBuilder builder: () -> [XContent]) {
        if insertionMode == .following {
            gotoPreviousOnTextIterators()
        }
        else {
            prefetchOnTextIterators()
        }
        super.replace(insertionMode, builder: builder)
    }
    
    public override var backLink: XText? { get { super.backLink as? XText } }
    public override var finalBackLink: XText? { get { super.finalBackLink as? XText } }
    
    var _value: String
    
    public var value: String {
        get {
            return _value
        }
        set (newText) {
            _value = newText
            _whitespace = .UNKNOWN
            if newText.isEmpty {
                self.remove()
            }
        }
    }
    
    public var description: String {
        get {
            _value
        }
    }
    
    var _isolated: Bool = false
    var _moving: Bool = false
    
    func prepareForMove() {
        _moving = true
    }
    
    func resetAfterMove() {
        _moving = false
        if !_isolated {
            intendCombiningWithNeighbours()
        }
    }
    
    func intendCombiningWithNeighbours() {
        if let previous = _previous as? XText, !previous.isolated {
            _value = previous._value + _value
            previous.value = ""
        }
        if let next = _next as? XText, !next.isolated {
            _value = _value + next._value
            next.value = ""
        }
    }
    
    public var isolated: Bool {
        get {
            return _moving || _isolated
        }
        set (newIsolatedValue) {
            if _isolated && newIsolatedValue == false {
                intendCombiningWithNeighbours()
            }
            _isolated = newIsolatedValue
        }
    }
    
    var _whitespace: WhitespaceIndicator
    
    public var whitespace: WhitespaceIndicator { _whitespace }
    
    public init(_ text: String, isolated: Bool = false, whitespace: WhitespaceIndicator = .UNKNOWN) {
        _value = text
        _isolated = isolated
        _whitespace = whitespace
    }
    
    public var isWhitespace: Bool {
        if _whitespace == .UNKNOWN {
            if _value.contains(regex: #"^\s+$"#) {
                _whitespace = .WHITESPACE
            }
            else {
                _whitespace = .NOT_WHITESPACE
            }
        }
        return _whitespace == .WHITESPACE
    }
    
    public func trim() {
        self.value = self.value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func trimming() -> XText {
        self.value = self.value.trimmingCharacters(in: .whitespacesAndNewlines)
        return self
    }
    
    public override func applying(_ f: (XText) -> ()) -> XText {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XText) -> Bool) -> XText? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XText) -> Bool) -> Bool {
        return f(self)
    }
    
    public override func produceEntering(production: XProduction) throws {
        try production.writeText(text: self)
    }
    
    public override func shallowClone() -> XText {
        let theClone = XText(_value, whitespace: _whitespace)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XText {
        return shallowClone()
    }
}

/*
 `XLiteral` has a text value that is meant to be serialized "as is" without XML-escaping.
 */
public final class XLiteral: XContent, AutoCombining, CustomStringConvertible {
    
    public override var backLink: XLiteral? { get { super.backLink as? XLiteral } }
    public override var finalBackLink: XLiteral? { get { super.finalBackLink as? XLiteral } }
    
    var _value: String
    
    public var value: String {
        get {
            return _value
        }
        set (newText) {
            _value = newText
            if newText.isEmpty {
                self.remove()
            }
        }
    }
    
    public var description: String {
        get {
            _value
        }
    }
    
    var _isolated: Bool = false
    var _moving: Bool = false
    
    func prepareForMove() {
        _moving = true
    }
    
    func resetAfterMove() {
        _moving = false
        if !_isolated {
            intendCombiningWithNeighbours()
        }
    }
    
    func intendCombiningWithNeighbours() {
        if let previous = _previous as? XLiteral, !previous.isolated {
            _value = previous._value + _value
            previous.value = ""
        }
        if let next = _next as? XLiteral, !next.isolated {
            _value = _value + next._value
            next.value = ""
        }
    }
    
    public var isolated: Bool {
        get {
            return _moving || _isolated
        }
        set (newIsolatedValue) {
            if _isolated && newIsolatedValue == false {
                intendCombiningWithNeighbours()
            }
            _isolated = newIsolatedValue
        }
    }
    
    public init(_ text: String) {
        self._value = text
    }
    
    public override func applying(_ f: (XLiteral) -> ()) -> XLiteral {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XLiteral) -> Bool) -> XLiteral? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XLiteral) -> Bool) -> Bool {
        return f(self)
    }
    
    public override func produceEntering(production: XProduction) throws {
        try production.writeLiteral(literal: self)
    }
    
    public override func shallowClone() -> XLiteral {
        let theClone = XLiteral(_value)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XLiteral {
        return shallowClone()
    }
}

public final class XInternalEntity: XContent {
    
    public override var backLink: XInternalEntity? { get { super.backLink as? XInternalEntity } }
    public override var finalBackLink: XInternalEntity? { get { super.finalBackLink as? XInternalEntity } }
    
    var _name: String
    
    public var name: String {
        get {
            return _name
        }
        set(newName) {
            _name = newName
        }
    }
    
    public init(_ name: String) {
        self._name = name
    }
    
    public override func applying(_ f: (XInternalEntity) -> ()) -> XInternalEntity {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XInternalEntity) -> Bool) -> XInternalEntity? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XInternalEntity) -> Bool) -> Bool {
        return f(self)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeInternalEntity(internalEntity: self)
    }
    
    public override func shallowClone() -> XInternalEntity {
        let theClone = XInternalEntity(_name)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XInternalEntity {
        return shallowClone()
    }
}

public final class XExternalEntity: XContent {
    
    public override var backLink: XExternalEntity? { get { super.backLink as? XExternalEntity } }
    public override var finalBackLink: XExternalEntity? { get { super.finalBackLink as? XExternalEntity } }
    
    var _name: String
    
    public var name: String {
        get {
            return _name
        }
        set(newName) {
            _name = newName
        }
    }
    
    public init(_ name: String) {
        self._name = name
    }
    
    public override func applying(_ f: (XExternalEntity) -> ()) -> XExternalEntity {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XExternalEntity) -> Bool) -> XExternalEntity? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XExternalEntity) -> Bool) -> Bool {
        return f(self)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeExternalEntity(externalEntity: self)
    }
    
    public override func shallowClone() -> XExternalEntity {
        let theClone = XExternalEntity(_name)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XExternalEntity {
        return shallowClone()
    }
}

public final class XProcessingInstruction: XContent, CustomStringConvertible {
    
    public override var backLink: XProcessingInstruction? { get { super.backLink as? XProcessingInstruction } }
    public override var finalBackLink: XProcessingInstruction? { get { super.finalBackLink as? XProcessingInstruction } }
    
    var _target: String
    var _data: String?
    
    public var description: String {
        get {
            """
            <?\(_target)\(_data?.isEmpty == false ? " " : "")\(_data ?? "")?>
            """
        }
    }
    
    public var target: String {
        get {
            return _target
        }
        set(newTarget) {
            _target = newTarget
        }
    }
    
    public var data: String? {
        get {
            return _data
        }
        set(newData) {
            _data = newData
        }
    }
    
    public init(target: String, data: String?) {
        self._target = target
        self._data = data
    }
    
    public override func applying(_ f: (XProcessingInstruction) -> ()) -> XProcessingInstruction {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XProcessingInstruction) -> Bool) -> XProcessingInstruction? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XProcessingInstruction) -> Bool) -> Bool {
        return f(self)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeProcessingInstruction(processingInstruction: self)
    }
    
    public override func shallowClone() -> XProcessingInstruction {
        let theClone = XProcessingInstruction(target: _target, data: _data)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XProcessingInstruction {
        return shallowClone()
    }
}

public final class XComment: XContent {
    
    public override var backLink: XComment? { get { super.backLink as? XComment } }
    public override var finalBackLink: XComment? { get { super.finalBackLink as? XComment } }
    
    var _value: String
    
    public var value: String {
        get {
            return _value
        }
        set(newText) {
            _value = newText
        }
    }
    
    public init(_ text: String) {
        self._value = text
    }
    
    public override func applying(_ f: (XComment) -> ()) -> XComment {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XComment) -> Bool) -> XComment? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XComment) -> Bool) -> Bool {
        return f(self)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeComment(comment: self)
    }
    
    public override func shallowClone() -> XComment {
        let theClone = XComment(_value)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XComment {
        return shallowClone()
    }
}

public final class XCDATASection: XContent {
    
    public override var backLink: XCDATASection? { get { super.backLink as? XCDATASection } }
    public override var finalBackLink: XCDATASection? { get { super.finalBackLink as? XCDATASection } }
    
    var _value: String
    
    public var value: String {
        get {
            return _value
        }
        set(newText) {
            _value = newText
        }
    }
    
    public init(_ text: String) {
        self._value = text
    }
    
    public override func applying(_ f: (XCDATASection) -> ()) -> XCDATASection {
        f(self)
        return self
    }
    
    public override func havingProperties(_ f: (XCDATASection) -> Bool) -> XCDATASection? {
        return f(self) ? self : nil
    }
    
    public override func hasProperties(_ f: (XCDATASection) -> Bool) -> Bool {
        return f(self)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeCDATASection(cdataSection: self)
    }
    
    public override func shallowClone() -> XCDATASection {
        let theClone = XCDATASection(_value)
        theClone._backLink = self
        theClone._sourceRange = self._sourceRange
        return theClone
    }
    
    public override func clone() -> XCDATASection {
        return shallowClone()
    }
}

public class XDeclarationInInternalSubset {
    
    var _sourceRange: XTextRange? = nil
    
    public var sourceRange: XTextRange? { _sourceRange }
    
    var _name: String = ""
    
    public var name: String {
        get {
            return _name
        }
        set(newName) {
            _name = newName
        }
    }
    
    public init(name: String) {
        self._name = name
    }
    
    func produceEntering(production: XProduction) throws {}
    
    func clone() -> XDeclarationInInternalSubset {
        let theClone = XDeclarationInInternalSubset(name: _name)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 internal entity declaration
 */
public final class XInternalEntityDeclaration: XDeclarationInInternalSubset {
    
    var _value: String
    
    public var value: String {
        get {
            return _value
        }
        set(newValue) {
            _value = newValue
        }
    }
    
    public init(name: String, value: String) {
        self._value = value
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeInternalEntityDeclaration(internalEntityDeclaration: self)
    }
    
    public override func clone() -> XInternalEntityDeclaration {
        let theClone = XInternalEntityDeclaration(name: _name, value: _value)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 parsed external entity declaration
 */
public final class XExternalEntityDeclaration: XDeclarationInInternalSubset {
    
    var _publicID: String?
    var _systemID: String
    
    public var publicID: String? {
        get {
            return _publicID
        }
        set(newPublicID) {
            _publicID = newPublicID
        }
    }
    
    public var systemID: String {
        get {
            return _systemID
        }
        set(newSystemID) {
            _systemID = newSystemID
        }
    }
    
    public init(name: String, publicID: String?, systemID: String) {
        self._publicID = publicID
        self._systemID = systemID
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeExternalEntityDeclaration(externalEntityDeclaration: self)
    }
    
    public override func clone() -> XExternalEntityDeclaration {
        let theClone = XExternalEntityDeclaration(name: _name, publicID: _publicID, systemID: _systemID)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 unparsed external entity declaration
 */
public final class XUnparsedEntityDeclaration: XDeclarationInInternalSubset {
    
    var _publicID: String?
    var _systemID: String
    var _notationName: String
    
    public var publicID: String? {
        get {
            return _publicID
        }
        set(newPublicID) {
            _publicID = newPublicID
        }
    }
    
    public var systemID: String {
        get {
            return _systemID
        }
        set(newSystemID) {
            _systemID = newSystemID
        }
    }
    
    public var notationName: String {
        get {
            return _notationName
        }
        set(newNotationName) {
            _notationName = newNotationName
        }
    }
    
    public init(name: String, publicID: String?, systemID: String, notationName: String) {
        self._publicID = publicID
        self._systemID = systemID
        self._notationName = notationName
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeUnparsedEntityDeclaration(unparsedEntityDeclaration: self)
    }
    
    public override func clone() -> XUnparsedEntityDeclaration {
        let theClone = XUnparsedEntityDeclaration(name: _name, publicID: _publicID, systemID: _systemID, notationName: _notationName)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 notation declaration
 */
public final class XNotationDeclaration: XDeclarationInInternalSubset {
    
    var _publicID: String?
    var _systemID: String?
    
    public var publicID: String? {
        get {
            return _publicID
        }
        set(newPublicID) {
            _publicID = newPublicID
        }
    }
    
    public var systemID: String? {
        get {
            return _systemID
        }
        set(newSystemID) {
            _systemID = newSystemID
        }
    }
    
    public init(name: String, publicID: String?, systemID: String?) {
        self._publicID = publicID
        self._systemID = systemID
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeNotationDeclaration(notationDeclaration: self)
    }
    
    public override func clone() -> XNotationDeclaration {
        let theClone = XNotationDeclaration(name: _name, publicID: _publicID, systemID: _systemID)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 element declaration
 */
public final class XElementDeclaration: XDeclarationInInternalSubset {
    
    var _literal: String
    
    public var literal: String {
        get {
            return _literal
        }
        set(newLiteral) {
            _literal = newLiteral
        }
    }
    
    public init(name: String, literal: String) {
        self._literal = literal
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeElementDeclaration(elementDeclaration: self)
    }
    
    public override func clone() -> XElementDeclaration {
        let theClone = XElementDeclaration(name: _name, literal: _literal)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 attribute list declaration
 */
public final class XAttributeListDeclaration: XDeclarationInInternalSubset {
    
    var _literal: String
    
    public var literal: String {
        get {
            return _literal
        }
        set(newLiteral) {
            _literal = newLiteral
        }
    }
    
    public init(name: String, literal: String) {
        self._literal = literal
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeAttributeListDeclaration(attributeListDeclaration: self)
    }
    
    public override func clone() -> XAttributeListDeclaration {
        let theClone = XAttributeListDeclaration(name: _name, literal: _literal)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}

/**
 parameter entity declaration
 */
public final class XParameterEntityDeclaration: XDeclarationInInternalSubset {
    
    var _value: String
    
    public var value: String {
        get {
            return _value
        }
        set(newValue) {
            _value = newValue
        }
    }
    
    public init(name: String, value: String) {
        self._value = value
        super.init(name: name)
    }
    
    override func produceEntering(production: XProduction) throws {
        try production.writeParameterEntityDeclaration(parameterEntityDeclaration: self)
    }
    
    public override func clone() -> XParameterEntityDeclaration {
        let theClone = XParameterEntityDeclaration(name: _name, value: _value)
        theClone._sourceRange = self._sourceRange
        return theClone
    }
}
