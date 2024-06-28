---
tags: Swift, Dates
lastModified: 2024-03-23
---

## Working with Dates in Swift

We will cover the basics of handling dates in Swift, including creating dates, formatting, and manipulating them.


##### Current Date and Time

```swift
let now = Date()
let now: Date = .now
```
<br>

##### Adding time interval
```swift
let currentDate = Date()

// Add 30 minutes (1800 seconds) to the current date
let futureDate = currentDate.addingTimeInterval(1800)
```
<br>

##### To set some hardcoded date

```swift
var dateComponents = DateComponents()
dateComponents.year = 2023
dateComponents.month = 5
dateComponents.day = 19
let hadrcodedDate = Calendar.current.date(from: dateComponents) // this is optional, so you can go with if let option or nil coalescing(??)
```

<br>

##### Parsing date from beckend

```swift
struct SomeStruct: Codable, Identifiable {
    
    var id: UUID
    var dateString: String
    
    var formatedDate: String? {
        var formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formater.date(from: dateString) {
            return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        }
        return nil
    }
    
    var formatForDeliveryOrderMode: String? {
        var formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formater.date(from: dateString) {
            return "Your order will be delivered at: \(DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short))"
        }
        return nil
    }
}

let someStruct = SomeStruct(id: UUID(), dateString: "2024-03-27T18:36:36Z")
print(someStruct.formatedDate ?? "No Date") // output: 27 Mar 2024
print(someStruct.formatForDeliveryOrderMode ?? "No Date") // output: Your order will be delivered at: 7:36 PM
```
<br>

##### Comparing dates

```swift
final class Intake {
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    var timestamp: Date = Date()
    
    var intakeDay: Date {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: timestamp)
        let date = Calendar.current.date(from: components)
        return date ?? .now
    }
}

let components = Calendar.current.dateComponents([.day, .month, .year], from: .now)
let today = Calendar.current.date(from: components) ?? .now // time is disregarded

let intake: Intake = .init(timestamp: Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now)
let result = intake.intakeDay == today
print(result) // false

let intake1: Intake = .init(timestamp: .now)
let result1 = intake1.intakeDay == today
print(result1) // true

// without filtered components
let intake2: Intake = .init(timestamp: .now) // same day
let today2: Date = .now // same day

let res = today2 == intake2.timestamp
print(today2)
print(intake.timestamp)
print(res) // false
```




