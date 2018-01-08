# Flexi-FizzBuzzBazz-iOS
An iOS Fizz-Buzz app with Bazz option, written in Swift 4 with Xcode 9, for the iPhone

### Description
This iOS app is ported from the C# Web Forms app https://github.com/kchindev/Flexi-FizzBuzzBazz-Web that generates a list of items representing the consecutive sequence of integers from **Start** to **End**.  When the integer is a multiple of **Fizz**, the string "Fizz" is added instead. Likewise, for multiples of **Buzz**, "Buzz" is added. For multiples of both **Fizz** and **Buzz**, "FizzBuzz" is added.

If the optional **Bazz** value is given, then "FizzBuzz" becomes "FizzBuzzBazz" for items that meet the optional condition.

The user interface is laid out and implemented in code without using storyboard.

### Code hightlights
- FlexiViewController.swift
  - User interface code that implements 5 input fields, an option picker, and a table view for displaying the result.
- GoFizzBuzzBazz.swift
  - Implements the **_FizzBuzzBazz_** logic
- AppDelegate.swift
  - Implements the entry ponit to the FlexiViewController user interface.
