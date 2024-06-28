---
tags: Swift, HealthKit
lastModified: 2024-05-19
---

## HealthKit integration in Swift

HealthKit is a framework provided by Apple that allows us to read and write data to the Health app on Apple devices. This guide demonstrates the basic setup for requesting authorization, reading, and writing HealthKit data.

<br>

#### Basic auth request

To interact with HealthKit, you must first request authorization from the user. This involves specifying the data types you want to read from and write to HealthKit.

##### Implementation

```swift
class HealthKitManager {
    
    static let shared = HealthKitManager()
    
    let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        
        guard let waterIntake = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else { return }
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: [waterIntake], read: healthKitTypesToRead)
        } catch {
            print("Error: access health kit error \(error)")
            throw error
        }
    }
}
```
<br>

#### Explanation
    - Health Store: The HKHealthStore instance is used to request authorization and interact with HealthKit data.
    - Authorization: The requestAuthorization function requests permission to read and write specific HealthKit data types.

HKObjectType is used to represent different types of data that can be stored in HealthKit, such as workouts, steps...
- Quantity Types:
    - .stepCount: Steps taken.
    - .heartRate: Heart rate in beats per minute (bpm)
    - .distance: Distance traveled in meters
    - .activeEnergyBurned: Active energy burned in calories
    - .basalEnergyBurned: Basal energy burned in calories (calories burned at rest)
    - .sleepAnalysis: Sleep analysis data (requires special permission)
    
    <br>
    
- Characteristic Types:
    - .biologicalSex: Biological sex (male, female, etc.)
    - .bloodType: Blood type (A, B, AB, O, etc.)
    - .birthday: Date of birth

<br>

#### Writing data to Health App

To write data to HealthKit, create a sample of the specific data type and save it using the HKHealthStore instance.

```swift
func saveWaterIntake(amount: Double) async {
    let healthStore = HKHealthStore()
    guard let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else { return }
    let quantity = HKQuantity(unit: HKUnit.liter(), doubleValue: amount / 1000)
    let sample = HKQuantitySample(type: waterType, quantity: quantity, start: Date(), end: Date())
    do {
        try await healthStore.save(sample)
    } catch {
        print("Health kit save error \(error)")
    }
}
```

##### Explanation
    - Water Intake: The saveWaterIntake function converts the water amount from milliliters to liters and creates an HKQuantitySample.
    - Save Data: The sample is then saved to HealthKit using the save method of HKHealthStore.

<br>

##### Get data from Health app

```swift
func getAgeAndBodyWeight(completion: @escaping (Date?, Double?, Error?) -> Void) {
        
    var kg: Double = 0
    let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        
    guard let birthdayComponents = try? healthStore.dateOfBirthComponents() else {
        completion(nil, nil, nil)
            return
    }
    guard let dateOfBirth = Calendar.current.date(from: birthdayComponents) else { return }
        
    let weightQuery = HKStatisticsQuery(quantityType: weightType, quantitySamplePredicate: nil, options: .discreteAverage) { (query, result, error) in
        if let error = error {
            print("Get Weight Error \(error)")
            completion(nil, nil, error)
        }
        guard let value = result?.averageQuantity()?.doubleValue(for: .gram()) else { return }
        let inKg = value / 1000
        kg = inKg.rounded(toDecimalPlaces: 2)
        completion(dateOfBirth, kg, nil)
    }
    self.healthStore.execute(weightQuery)
}
```
<br>

#### Conclusion

This guide provides a basic structure for integrating HealthKit into your Swift app. The examples demonstrate how to request authorization, read, and write data to the Health app. You can extend the HealthKitManager with more functionality and customize it according to your app's requirements.
