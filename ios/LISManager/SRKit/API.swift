// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class PatientListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PatientList {
      patients {
        __typename
        internalId
      }
    }
    """

  public let operationName: String = "PatientList"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("patients", type: .list(.object(Patient.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(patients: [Patient?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "patients": patients.flatMap { (value: [Patient?]) -> [ResultMap?] in value.map { (value: Patient?) -> ResultMap? in value.flatMap { (value: Patient) -> ResultMap in value.resultMap } } }])
    }

    public var patients: [Patient?]? {
      get {
        return (resultMap["patients"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Patient?] in value.map { (value: ResultMap?) -> Patient? in value.flatMap { (value: ResultMap) -> Patient in Patient(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Patient?]) -> [ResultMap?] in value.map { (value: Patient?) -> ResultMap? in value.flatMap { (value: Patient) -> ResultMap in value.resultMap } } }, forKey: "patients")
      }
    }

    public struct Patient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Patient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("internalId", type: .scalar(GraphQLID.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(internalId: GraphQLID? = nil) {
        self.init(unsafeResultMap: ["__typename": "Patient", "internalId": internalId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var internalId: GraphQLID? {
        get {
          return resultMap["internalId"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "internalId")
        }
      }
    }
  }
}
