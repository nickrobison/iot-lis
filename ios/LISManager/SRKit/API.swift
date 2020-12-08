// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class DeviceListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query DeviceList {
      deviceType {
        __typename
        internalId
        manufacturer
        model
        loincCode
      }
    }
    """

  public let operationName: String = "DeviceList"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deviceType", type: .list(.object(DeviceType.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deviceType: [DeviceType?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "deviceType": deviceType.flatMap { (value: [DeviceType?]) -> [ResultMap?] in value.map { (value: DeviceType?) -> ResultMap? in value.flatMap { (value: DeviceType) -> ResultMap in value.resultMap } } }])
    }

    public var deviceType: [DeviceType?]? {
      get {
        return (resultMap["deviceType"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [DeviceType?] in value.map { (value: ResultMap?) -> DeviceType? in value.flatMap { (value: ResultMap) -> DeviceType in DeviceType(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [DeviceType?]) -> [ResultMap?] in value.map { (value: DeviceType?) -> ResultMap? in value.flatMap { (value: DeviceType) -> ResultMap in value.resultMap } } }, forKey: "deviceType")
      }
    }

    public struct DeviceType: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["DeviceType"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("internalId", type: .scalar(GraphQLID.self)),
          GraphQLField("manufacturer", type: .scalar(String.self)),
          GraphQLField("model", type: .scalar(String.self)),
          GraphQLField("loincCode", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(internalId: GraphQLID? = nil, manufacturer: String? = nil, model: String? = nil, loincCode: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "DeviceType", "internalId": internalId, "manufacturer": manufacturer, "model": model, "loincCode": loincCode])
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

      public var manufacturer: String? {
        get {
          return resultMap["manufacturer"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "manufacturer")
        }
      }

      public var model: String? {
        get {
          return resultMap["model"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "model")
        }
      }

      public var loincCode: String? {
        get {
          return resultMap["loincCode"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "loincCode")
        }
      }
    }
  }
}

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

public final class AddPatientMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AddPatient($id: String, $firstName: String!, $lastName: String!, $middleName: String, $suffix: String, $birthDate: String!, $street: String!, $street2: String, $city: String, $state: String!, $zipCode: String!, $county: String, $email: String, $telephone: String!, $race: String, $ethnicity: String, $gender: String, $role: String, $employedInHealthcare: Boolean!, $residentCongregateSetting: Boolean!) {
      addPatient(lookupId: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, suffix: $suffix, birthDate: $birthDate, street: $street, streetTwo: $street2, city: $city, state: $state, zipCode: $zipCode, telephone: $telephone, role: $role, email: $email, county: $county, race: $race, ethnicity: $ethnicity, gender: $gender, residentCongregateSetting: $residentCongregateSetting, employedInHealthcare: $employedInHealthcare)
    }
    """

  public let operationName: String = "AddPatient"

  public var id: String?
  public var firstName: String
  public var lastName: String
  public var middleName: String?
  public var suffix: String?
  public var birthDate: String
  public var street: String
  public var street2: String?
  public var city: String?
  public var state: String
  public var zipCode: String
  public var county: String?
  public var email: String?
  public var telephone: String
  public var race: String?
  public var ethnicity: String?
  public var gender: String?
  public var role: String?
  public var employedInHealthcare: Bool
  public var residentCongregateSetting: Bool

  public init(id: String? = nil, firstName: String, lastName: String, middleName: String? = nil, suffix: String? = nil, birthDate: String, street: String, street2: String? = nil, city: String? = nil, state: String, zipCode: String, county: String? = nil, email: String? = nil, telephone: String, race: String? = nil, ethnicity: String? = nil, gender: String? = nil, role: String? = nil, employedInHealthcare: Bool, residentCongregateSetting: Bool) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.middleName = middleName
    self.suffix = suffix
    self.birthDate = birthDate
    self.street = street
    self.street2 = street2
    self.city = city
    self.state = state
    self.zipCode = zipCode
    self.county = county
    self.email = email
    self.telephone = telephone
    self.race = race
    self.ethnicity = ethnicity
    self.gender = gender
    self.role = role
    self.employedInHealthcare = employedInHealthcare
    self.residentCongregateSetting = residentCongregateSetting
  }

  public var variables: GraphQLMap? {
    return ["id": id, "firstName": firstName, "lastName": lastName, "middleName": middleName, "suffix": suffix, "birthDate": birthDate, "street": street, "street2": street2, "city": city, "state": state, "zipCode": zipCode, "county": county, "email": email, "telephone": telephone, "race": race, "ethnicity": ethnicity, "gender": gender, "role": role, "employedInHealthcare": employedInHealthcare, "residentCongregateSetting": residentCongregateSetting]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addPatient", arguments: ["lookupId": GraphQLVariable("id"), "firstName": GraphQLVariable("firstName"), "middleName": GraphQLVariable("middleName"), "lastName": GraphQLVariable("lastName"), "suffix": GraphQLVariable("suffix"), "birthDate": GraphQLVariable("birthDate"), "street": GraphQLVariable("street"), "streetTwo": GraphQLVariable("street2"), "city": GraphQLVariable("city"), "state": GraphQLVariable("state"), "zipCode": GraphQLVariable("zipCode"), "telephone": GraphQLVariable("telephone"), "role": GraphQLVariable("role"), "email": GraphQLVariable("email"), "county": GraphQLVariable("county"), "race": GraphQLVariable("race"), "ethnicity": GraphQLVariable("ethnicity"), "gender": GraphQLVariable("gender"), "residentCongregateSetting": GraphQLVariable("residentCongregateSetting"), "employedInHealthcare": GraphQLVariable("employedInHealthcare")], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addPatient: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addPatient": addPatient])
    }

    public var addPatient: String? {
      get {
        return resultMap["addPatient"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "addPatient")
      }
    }
  }
}

public final class AddPatientToQueueMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AddPatientToQueue($id: String!, $pregnancy: String, $symptoms: String, $firstTest: Boolean, $priorTestDate: String, $priorTestResult: String, $symptomOnset: String, $noSymptoms: Boolean) {
      addPatientToQueue(patientId: $id, pregnancy: $pregnancy, symptoms: $symptoms, firstTest: $firstTest, priorTestDate: $priorTestDate, priorTestResult: $priorTestResult, symptomOnset: $symptomOnset, noSymptoms: $noSymptoms)
    }
    """

  public let operationName: String = "AddPatientToQueue"

  public var id: String
  public var pregnancy: String?
  public var symptoms: String?
  public var firstTest: Bool?
  public var priorTestDate: String?
  public var priorTestResult: String?
  public var symptomOnset: String?
  public var noSymptoms: Bool?

  public init(id: String, pregnancy: String? = nil, symptoms: String? = nil, firstTest: Bool? = nil, priorTestDate: String? = nil, priorTestResult: String? = nil, symptomOnset: String? = nil, noSymptoms: Bool? = nil) {
    self.id = id
    self.pregnancy = pregnancy
    self.symptoms = symptoms
    self.firstTest = firstTest
    self.priorTestDate = priorTestDate
    self.priorTestResult = priorTestResult
    self.symptomOnset = symptomOnset
    self.noSymptoms = noSymptoms
  }

  public var variables: GraphQLMap? {
    return ["id": id, "pregnancy": pregnancy, "symptoms": symptoms, "firstTest": firstTest, "priorTestDate": priorTestDate, "priorTestResult": priorTestResult, "symptomOnset": symptomOnset, "noSymptoms": noSymptoms]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addPatientToQueue", arguments: ["patientId": GraphQLVariable("id"), "pregnancy": GraphQLVariable("pregnancy"), "symptoms": GraphQLVariable("symptoms"), "firstTest": GraphQLVariable("firstTest"), "priorTestDate": GraphQLVariable("priorTestDate"), "priorTestResult": GraphQLVariable("priorTestResult"), "symptomOnset": GraphQLVariable("symptomOnset"), "noSymptoms": GraphQLVariable("noSymptoms")], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addPatientToQueue: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addPatientToQueue": addPatientToQueue])
    }

    public var addPatientToQueue: String? {
      get {
        return resultMap["addPatientToQueue"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "addPatientToQueue")
      }
    }
  }
}

public final class TestResultListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TestResultList {
      testResults {
        __typename
        internalId
        patient {
          __typename
          internalId
        }
        dateTested
        result
      }
    }
    """

  public let operationName: String = "TestResultList"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("testResults", type: .list(.object(TestResult.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(testResults: [TestResult?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "testResults": testResults.flatMap { (value: [TestResult?]) -> [ResultMap?] in value.map { (value: TestResult?) -> ResultMap? in value.flatMap { (value: TestResult) -> ResultMap in value.resultMap } } }])
    }

    public var testResults: [TestResult?]? {
      get {
        return (resultMap["testResults"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [TestResult?] in value.map { (value: ResultMap?) -> TestResult? in value.flatMap { (value: ResultMap) -> TestResult in TestResult(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [TestResult?]) -> [ResultMap?] in value.map { (value: TestResult?) -> ResultMap? in value.flatMap { (value: TestResult) -> ResultMap in value.resultMap } } }, forKey: "testResults")
      }
    }

    public struct TestResult: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TestResult"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("internalId", type: .scalar(GraphQLID.self)),
          GraphQLField("patient", type: .object(Patient.selections)),
          GraphQLField("dateTested", type: .scalar(String.self)),
          GraphQLField("result", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(internalId: GraphQLID? = nil, patient: Patient? = nil, dateTested: String? = nil, result: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "TestResult", "internalId": internalId, "patient": patient.flatMap { (value: Patient) -> ResultMap in value.resultMap }, "dateTested": dateTested, "result": result])
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

      public var patient: Patient? {
        get {
          return (resultMap["patient"] as? ResultMap).flatMap { Patient(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "patient")
        }
      }

      public var dateTested: String? {
        get {
          return resultMap["dateTested"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dateTested")
        }
      }

      public var result: String? {
        get {
          return resultMap["result"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "result")
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
}

public final class AddTestResultMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AddTestResult($DeviceID: String!, $Result: String!, $PatientID: String!) {
      addTestResult(deviceId: $DeviceID, result: $Result, patientId: $PatientID)
    }
    """

  public let operationName: String = "AddTestResult"

  public var DeviceID: String
  public var Result: String
  public var PatientID: String

  public init(DeviceID: String, Result: String, PatientID: String) {
    self.DeviceID = DeviceID
    self.Result = Result
    self.PatientID = PatientID
  }

  public var variables: GraphQLMap? {
    return ["DeviceID": DeviceID, "Result": Result, "PatientID": PatientID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addTestResult", arguments: ["deviceId": GraphQLVariable("DeviceID"), "result": GraphQLVariable("Result"), "patientId": GraphQLVariable("PatientID")], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addTestResult: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addTestResult": addTestResult])
    }

    public var addTestResult: String? {
      get {
        return resultMap["addTestResult"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "addTestResult")
      }
    }
  }
}
