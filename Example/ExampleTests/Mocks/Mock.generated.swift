// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.1.0
// Required Sourcery: 1.6.0


import SwiftyMocky
import XCTest
import CompoundFetchedResultsController
import CoreData
import Foundation
@testable import FetchedDataSource


// MARK: - FetchedCompositionalDataSourceDelegate
@available(iOS 14.0, *)
open class FetchedCompositionalDataSourceDelegateMock: FetchedCompositionalDataSourceDelegate, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        addInvocation(.m_controller__controllerdidChangeContentWith_snapshot(Parameter<NSFetchedResultsController<NSFetchRequestResult>>.value(`controller`), Parameter<NSDiffableDataSourceSnapshotReference>.value(`snapshot`)))
		let perform = methodPerformValue(.m_controller__controllerdidChangeContentWith_snapshot(Parameter<NSFetchedResultsController<NSFetchRequestResult>>.value(`controller`), Parameter<NSDiffableDataSourceSnapshotReference>.value(`snapshot`))) as? (NSFetchedResultsController<NSFetchRequestResult>, NSDiffableDataSourceSnapshotReference) -> Void
		perform?(`controller`, `snapshot`)
    }

    open func willChangeContent() {
        addInvocation(.m_willChangeContent)
		let perform = methodPerformValue(.m_willChangeContent) as? () -> Void
		perform?()
    }

    open func didChangeContent() {
        addInvocation(.m_didChangeContent)
		let perform = methodPerformValue(.m_didChangeContent) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_controller__controllerdidChangeContentWith_snapshot(Parameter<NSFetchedResultsController<NSFetchRequestResult>>, Parameter<NSDiffableDataSourceSnapshotReference>)
        case m_willChangeContent
        case m_didChangeContent

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_controller__controllerdidChangeContentWith_snapshot(let lhsController, let lhsSnapshot), .m_controller__controllerdidChangeContentWith_snapshot(let rhsController, let rhsSnapshot)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsController, rhs: rhsController, with: matcher), lhsController, rhsController, "_ controller"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSnapshot, rhs: rhsSnapshot, with: matcher), lhsSnapshot, rhsSnapshot, "didChangeContentWith snapshot"))
				return Matcher.ComparisonResult(results)

            case (.m_willChangeContent, .m_willChangeContent): return .match

            case (.m_didChangeContent, .m_didChangeContent): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_controller__controllerdidChangeContentWith_snapshot(p0, p1): return p0.intValue + p1.intValue
            case .m_willChangeContent: return 0
            case .m_didChangeContent: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_controller__controllerdidChangeContentWith_snapshot: return ".controller(_:didChangeContentWith:)"
            case .m_willChangeContent: return ".willChangeContent()"
            case .m_didChangeContent: return ".didChangeContent()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func controller(_ controller: Parameter<NSFetchedResultsController<NSFetchRequestResult>>, didChangeContentWith snapshot: Parameter<NSDiffableDataSourceSnapshotReference>) -> Verify { return Verify(method: .m_controller__controllerdidChangeContentWith_snapshot(`controller`, `snapshot`))}
        public static func willChangeContent() -> Verify { return Verify(method: .m_willChangeContent)}
        public static func didChangeContent() -> Verify { return Verify(method: .m_didChangeContent)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func controller(_ controller: Parameter<NSFetchedResultsController<NSFetchRequestResult>>, didChangeContentWith snapshot: Parameter<NSDiffableDataSourceSnapshotReference>, perform: @escaping (NSFetchedResultsController<NSFetchRequestResult>, NSDiffableDataSourceSnapshotReference) -> Void) -> Perform {
            return Perform(method: .m_controller__controllerdidChangeContentWith_snapshot(`controller`, `snapshot`), performs: perform)
        }
        public static func willChangeContent(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_willChangeContent, performs: perform)
        }
        public static func didChangeContent(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_didChangeContent, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - NSFetchedResultsControllerProtocol

open class NSFetchedResultsControllerProtocolMock: NSFetchedResultsControllerProtocol, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    public var delegate: NSFetchedResultsControllerDelegate? {
		get {	invocations.append(.p_delegate_get); return __p_delegate ?? optionalGivenGetterValue(.p_delegate_get, "NSFetchedResultsControllerProtocolMock - stub value for delegate was not defined") }
		set {	invocations.append(.p_delegate_set(.value(newValue))); __p_delegate = newValue }
	}
	private var __p_delegate: (NSFetchedResultsControllerDelegate)?





    open func isIdentical(to object: NSFetchedResultsControllerProtocol) -> Bool {
        addInvocation(.m_isIdentical__to_object(Parameter<NSFetchedResultsControllerProtocol>.value(`object`)))
		let perform = methodPerformValue(.m_isIdentical__to_object(Parameter<NSFetchedResultsControllerProtocol>.value(`object`))) as? (NSFetchedResultsControllerProtocol) -> Void
		perform?(`object`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isIdentical__to_object(Parameter<NSFetchedResultsControllerProtocol>.value(`object`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isIdentical(to object: NSFetchedResultsControllerProtocol). Use given")
			Failure("Stub return value not specified for isIdentical(to object: NSFetchedResultsControllerProtocol). Use given")
		}
		return __value
    }

    open func performFetch() throws {
        addInvocation(.m_performFetch)
		let perform = methodPerformValue(.m_performFetch) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_performFetch).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_isIdentical__to_object(Parameter<NSFetchedResultsControllerProtocol>)
        case m_performFetch
        case p_delegate_get
		case p_delegate_set(Parameter<NSFetchedResultsControllerDelegate?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_isIdentical__to_object(let lhsObject), .m_isIdentical__to_object(let rhsObject)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsObject, rhs: rhsObject, with: matcher), lhsObject, rhsObject, "to object"))
				return Matcher.ComparisonResult(results)

            case (.m_performFetch, .m_performFetch): return .match
            case (.p_delegate_get,.p_delegate_get): return Matcher.ComparisonResult.match
			case (.p_delegate_set(let left),.p_delegate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<NSFetchedResultsControllerDelegate?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_isIdentical__to_object(p0): return p0.intValue
            case .m_performFetch: return 0
            case .p_delegate_get: return 0
			case .p_delegate_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_isIdentical__to_object: return ".isIdentical(to:)"
            case .m_performFetch: return ".performFetch()"
            case .p_delegate_get: return "[get] .delegate"
			case .p_delegate_set: return "[set] .delegate"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func delegate(getter defaultValue: NSFetchedResultsControllerDelegate?...) -> PropertyStub {
            return Given(method: .p_delegate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func isIdentical(to object: Parameter<NSFetchedResultsControllerProtocol>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isIdentical__to_object(`object`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isIdentical(to object: Parameter<NSFetchedResultsControllerProtocol>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isIdentical__to_object(`object`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func performFetch(willThrow: Error...) -> MethodStub {
            return Given(method: .m_performFetch, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func performFetch(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_performFetch, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func isIdentical(to object: Parameter<NSFetchedResultsControllerProtocol>) -> Verify { return Verify(method: .m_isIdentical__to_object(`object`))}
        public static func performFetch() -> Verify { return Verify(method: .m_performFetch)}
        public static var delegate: Verify { return Verify(method: .p_delegate_get) }
		public static func delegate(set newValue: Parameter<NSFetchedResultsControllerDelegate?>) -> Verify { return Verify(method: .p_delegate_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func isIdentical(to object: Parameter<NSFetchedResultsControllerProtocol>, perform: @escaping (NSFetchedResultsControllerProtocol) -> Void) -> Perform {
            return Perform(method: .m_isIdentical__to_object(`object`), performs: perform)
        }
        public static func performFetch(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_performFetch, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

