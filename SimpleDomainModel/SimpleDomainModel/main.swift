//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    // Converts money to/from USB, GBP, EURO, and CAN
    public func convert(_ to: String) -> Money {
        let currentAmount = Double(self.amount)
        var amountConverted : Double
        if ( self.currency == "USD" ) { // USD to __
            if (to == "GBP") { // USD to GBP
                amountConverted = currentAmount * 0.5
            } else if (to == "EUR") { // USD to EUR
                amountConverted = currentAmount * 1.5
            } else { // USD to CAN
                amountConverted = currentAmount * 1.25
            }
        } else if ( self.currency == "EUR" ) { // EUR to __
            if (to == "USD") { // EUR to USD
                amountConverted = currentAmount * (2.0/3.0)
            } else if (to == "GBP") { // EUR to GBP
                amountConverted = currentAmount * (1.0/3.0)
            } else { // EUR to CAN
                amountConverted = currentAmount * (5.0/6.0)
            }
        } else if ( self.currency == "CAN" ){ // CAN to __
            if (to == "USD") { // CAN to USD
                amountConverted = currentAmount * 0.8
            } else if (to == "GBP") { // CAN to GBP
                amountConverted = currentAmount * 0.4
            } else { // CAN to EUR
                amountConverted = currentAmount * 1.2
            }
        } else { // GBP to __
            if (to == "USD") { // GBP to USD
                amountConverted = currentAmount * 2.0
            } else if (to == "EUR") { // GBP to EUR
                amountConverted = currentAmount * 3.0
            } else { // GBP to CAN
                amountConverted = currentAmount * 2.5
            }
        }
        return Money(amount: Int(amountConverted), currency: to)
    }
    
    // Adds money. Returns money in currency of passed money.
    public func add(_ to: Money) -> Money {
        var thisMoney = self
        if self.currency != to.currency { // Only convert if adding to different currency
            thisMoney = thisMoney.convert(to.currency)
        }
        return Money(amount: thisMoney.amount + to.amount, currency: to.currency)
    }
    
    // Subtracts money. Returns money in currency of passed money.
    public func subtract(_ from: Money) -> Money {
        let thisMoney = self.convert(from.currency).amount
        return Money(amount: from.amount - thisMoney, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    // Calculates income based on salary or hourly rate
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let rate): return Int(rate * Double(hours))
        case .Salary(let income): return income
        }
    }
    
    // Raises the the salary or hourly rate with passed amount
    open func raise(_ amt : Double) {
        switch self.type {
        case .Salary(let income): self.type = .Salary(Int(Double(income) + amt))
        case .Hourly(let rate): self.type = .Hourly(rate + amt)
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    // Person's job
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            if self.age >= 16 {
                self._job = value
            }
        }
    }
    
    // Person's spouse
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if self.age >= 18 && (value?.age)! >= 18 { // Both to-be spouses must be 18 or older
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    // String representation of person in the form: '[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]'
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.title ?? "nil") spouse:\(self._spouse?.firstName ?? "nil")]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        self.members.append(spouse1)
        self.members.append(spouse2)
        
        if spouse1.age <= 21 && spouse2.age <= 21 { // Must have a family member that is >21 years old
            self.members.append(Person(firstName: "Legal", lastName: "Guardian", age: 22))
        }
    }
    
    // Adds child to family and sets their age to 0
    open func haveChild(_ child: Person) -> Bool {
        let newChild = child
        newChild.age = 0
        self.members.append(newChild)
        return true
    }
    
    // Returns the combined income of a household
    open func householdIncome() -> Int {
        var totalIncome = 0
        for member in members {
            if member.job != nil {
                totalIncome += (member.job?.calculateIncome(2000))!
            }
        }
        return totalIncome
    }
}





