import HealthKit

// Check if HealthKit is available on the device
if HKHealthStore.isHealthDataAvailable() {
    // Create a HealthKit store
    let healthStore = HKHealthStore()
    
    // Define the types of data you want to read and write (in this case, calories burned)
    let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    
    // Request authorization to read and write calorie data
    healthStore.requestAuthorization(toShare: [calorieType], read: [calorieType]) { (success, error) in
        if success {
            // Authorization granted, now you can read and write calorie data
            
            // Create a sample of calorie data (for example, 200 calories burned)
            let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 200.0)
            let calorieSample = HKQuantitySample(type: calorieType, quantity: calorieQuantity, start: Date(), end: Date())
            
            // Save the calorie data to HealthKit
            healthStore.save(calorieSample, withCompletion: { (success, error) in
                if success {
                    print("Calorie data saved successfully!")
                } else {
                    print("Error saving calorie data: \(error?.localizedDescription ?? "Unknown error")")
                }
            })
            
            // Query and retrieve calorie data
            let query = HKSampleQuery(sampleType: calorieType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                if let samples = results as? [HKQuantitySample] {
                    for sample in samples {
                        let calories = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                        print("Calories burned: \(calories)")
                    }
                }
            }
            
            healthStore.execute(query)
        } else {
            print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
} else {
    print("HealthKit is not available on this device.")
}
