# SwiftXML

A library written in Swift to process XML.

---
**NOTE**

This library is not in a "final" state yet. Also, when such a final state is reached, this repository might be further developed using a new URL. Further notice will be added here.

---

## Properties of the library

The library reads XML from a source into an XML document instance, and provides methods to transform (or manipulate) the document, and others to write the document to a file. (The reading of a JSON source into an XML document structure is also implemented, but currently only in experimental state.)

### Manipulation of an XML document

Other than some other libraries for XML, the manipulation of the document as built in memory is "in place", i.e. no new XML document is built. The goal is to be able to apply many isolated manipulations to an XML document efficiently. But it is always possible to clone a document easily with references to or from the old version.

All iteration over elements in the document using the according library functions are lazy by default. While iterating over elements in the document using the according library functions, the document tree can be changed without negatively affecting the iteration.

Part of the effiency is the possibility to efficiently find elements or attributes of a certain name without having to traverse the whole tree. An according iteration proceeds in the order by which the elements or attributes have been added to the document. When iterating in this manner, newly added elements or attributes are then also processed as part of the same iteration.

The user of the library can also provide a sets of rules to be applied. In such a rule, the user defines what to do with an element or attribute with a certain name. The set of rules can then be applied to a document, i.e. the rules are applied in the order of their definition. This is repeated, garanteeing that a rule is only applied once to the same object (if not detached from the document and added again), until no application takes places. So elements can be added during apllication of a rule and then later be processed by the same or another rule.

### Other properties

The library uses the [SwiftXMLParser](https://github.com/stefanspringer1/SwiftXMLParser) to parse XML which implements the according protocol from [XMLInterfaces](https://github.com/stefanspringer1/SwiftXMLInterfaces).

All parts of the XML source are retained in the XML document built in memory, including all comments and parts of an internal subset e.g. all entity or element definitions. (Elements definitions and attribute list definitions are, besides their reported element names, only retained as their original textual represenation, they are not parsed into any other representation.) 

In the current implementation, the XML library does not implement any validation, i.e. validation against a DTD or other XML schema. The user has to use other libaries (e.g. [Libxml2Validation](https://github.com/stefanspringer1/Libxml2Validation)) for such validation. To compensate for that, the user of the library can provide a function that decides if encountered whitespace between elements should be kept or not. Also, possible default values of attributes have to be set by the user if desired once the document tree is built.

This library gives full control of how to handle entities. Named entities can persist inside the document event if they are not defined. Named entity references are being scored as internal or external entity rerefences during parsing, the external entity references being those which are referenced by external entity definitions in the internal subset inside the document declaration of the document. Possible replacements of internal entity references by text can be controlled by the application.

No automated inclusion of external parsed entities takes place. The user of the library has to implements such features herself.

In the current state, the library does not recognize XML namespaces; elements or attributes with namespace prefixes are give the full name "prefix:unprefixed".

The encoding of the source should always be UTF-8 (ASCII is considered as a subset of it). The parser checks for correct UTF-8 encoding and also checks (according to the data used by the currently used Swift implementation) if a found codepoint is a valid Unicode codepoint.

For any error during parsing an error is thrown and no document is then provided.

## Reading XML

The following functions take a source and return an XML document instance (`XDocument`). The source can either be provided as a URL, a path to a file, a text, or binary data.

```Swift
func parseXML(
    fromURL: URL,
    sourceInfo: String?,
    internalEntityResolver: InternalEntityResolver?,
    eventHandlers: [XEventHandler]?,
    textAllowed: (() -> Bool)?
) throws -> XDocument
```

```Swift
func parseXML(
    fromPath: String,
    sourceInfo: String?,
    internalEntityResolver: InternalEntityResolver?,
    eventHandlers: [XEventHandler]?,
    textAllowed: (() -> Bool)?
) throws -> XDocument
```

```Swift
func parseXML(
    fromText: String,
    sourceInfo: String?,
    internalEntityResolver: InternalEntityResolver?,
    eventHandlers: [XEventHandler]?,
    textAllowed: (() -> Bool)?
) throws -> XDocument
```

```Swift
func parseXML(
    fromData: Data,
    sourceInfo: String?,
    internalEntityResolver: InternalEntityResolver?,
    eventHandlers: [XEventHandler]?,
    textAllowed: (() -> Bool)?
) throws -> XDocument
```

All internal entity references in attribute values have to be replaced by text during parsing. In order to achieve this (in case that internal entity references occur at all in attribute values in the source), an `InternalEntityResolver` can be provided. An `InternalEntityResolver` has to implement the following method:

```Swift
func resolve(
    entityWithName: String,
    forAttributeWithName: String?,
    atElementWithName: String?
) -> String?
```

This method is always called when an named entity reference is encountered (either in text or attribute) which is scored as an internal entity. It returns the textual replacement for the entity or `nil`. If the method returns `nil`, then the entity reference is not replaced by a text, but is kept. In the case of a named entity in an attribute value, an error is thrown when no replacement is given. The function arguments `forAttributeWithName` (name of the attribute) and `atElementWithName` (name of the element) have according values if and only if the entity is encountered inside an attribute value.

One a more event handlers can be given a `parseXML` call, which implement `XEventHandler` from [XMLInterfaces](https://github.com/stefanspringer1/SwiftXMLInterfaces). This allows for the user of the library to catch all events during parsing. E.g., the resolving of an internal entity reference could depend on the location inside the document, so this information can be collected by such an event handler.