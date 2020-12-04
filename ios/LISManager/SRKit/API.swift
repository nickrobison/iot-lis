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
        firstName
        lastName
        birthDate
        street
        streetTwo
        city
        state
        zipCode
        gender
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
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
          GraphQLField("birthDate", type: .scalar(String.self)),
          GraphQLField("street", type: .scalar(String.self)),
          GraphQLField("streetTwo", type: .scalar(String.self)),
          GraphQLField("city", type: .scalar(String.self)),
          GraphQLField("state", type: .scalar(String.self)),
          GraphQLField("zipCode", type: .scalar(String.self)),
          GraphQLField("gender", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(internalId: GraphQLID? = nil, firstName: String? = nil, lastName: String? = nil, birthDate: String? = nil, street: String? = nil, streetTwo: String? = nil, city: String? = nil, state: String? = nil, zipCode: String? = nil, gender: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Patient", "internalId": internalId, "firstName": firstName, "lastName": lastName, "birthDate": birthDate, "street": street, "streetTwo": streetTwo, "city": city, "state": state, "zipCode": zipCode, "gender": gender])
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

      public var firstName: String? {
        get {
          return resultMap["firstName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return resultMap["lastName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastName")
        }
      }

      public var birthDate: String? {
        get {
          return resultMap["birthDate"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "birthDate")
        }
      }

      public var street: String? {
        get {
          return resultMap["street"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "street")
        }
      }

      public var streetTwo: String? {
        get {
          return resultMap["streetTwo"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "streetTwo")
        }
      }

      public var city: String? {
        get {
          return resultMap["city"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "city")
        }
      }

      public var state: String? {
        get {
          return resultMap["state"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "state")
        }
      }

      public var zipCode: String? {
        get {
          return resultMap["zipCode"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "zipCode")
        }
      }

      public var gender: String? {
        get {
          return resultMap["gender"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "gender")
        }
      }
    }
  }
}
