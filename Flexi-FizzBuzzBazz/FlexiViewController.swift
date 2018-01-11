//
//  FlexiViewController.swift
//  Flexi-FizzBuzzBazz
//
//  Created by Kean Chin on 1/7/18.
//  Copyright © 2018 Kean Chin. All rights reserved.
//

import Foundation

import UIKit

class FlexiViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let guide = view.safeAreaLayoutGuide
        layoutHeight = guide.layoutFrame.size.height
        layoutWidth = guide.layoutFrame.size.width
        
        //margins = view.safeAreaLayoutGuide
        margins = view.layoutMarginsGuide
        
        addInuptView()
        addRunResultView(previousControl: bazzInputText)
        addOnScreenKeyboardDoneButton()
    }

    func addOnScreenKeyboardDoneButton() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([leftFlexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        fizzInputText.inputAccessoryView = toolbar
        buzzInputText.inputAccessoryView = toolbar
        bazzInputText.inputAccessoryView = toolbar
        startInputText.inputAccessoryView = toolbar
        endInputText.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) // Dismiss keyboard
    }
    
    private let inputContainerView = UIView()
    private let runOptionContainerView = UIView()
    private let resultContainerView = UIView()
    private let bazzOptionButton = UIButton(type: .system)
    private var bazzOptionPicker = UIPickerView()
    private let fizzLabel = UILabel()
    private let fizzInputText = UITextField()
    private let buzzLabel = UILabel()
    private let buzzInputText = UITextField()
    private let startLabel = UILabel()
    private let startInputText = UITextField()
    private let endLabel = UILabel()
    private let endInputText = UITextField()
    private let bazzLabel = UILabel()
    private let bazzInputText = UITextField()
    private var margins = UILayoutGuide()
    private let doneButton = UIButton(type: .system)
    private let runButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let resultText = UILabel()
    private var resultTable = UITableView()
    private var resultData = [String]()
    private var layoutHeight: CGFloat = 0
    private var layoutWidth: CGFloat = 0
    
    @objc func handleDeviceOrientationChange() {
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            //print("landscapeLeft")
            //setLandscapeLayout()
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            //print("landscapeRight")
            //setLandscapeLayout()
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            //print("portrait")
            setPortraitLayout()
        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            //print("portraitUpsideDown")
            //setLandscapeLayout()
        }
    }
    
    private func setLandscapeLayout() {
    }
    
    private func setPortraitLayout() {
        // Adjust tableView height
        var heightOffset = margins.layoutFrame.minY // iPhone X = 44.0, SE and 8 Plus = 20.0
        if heightOffset > 20 { heightOffset = 0 }
        resultContainerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        resultContainerView.layoutIfNeeded()
        // Adjust for iPhones other than "iPhone X" (iPhone X has a safe area offset)
        resultTable.frame.size.height = resultContainerView.frame.size.height - heightOffset
    }
    
    func addInuptView() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false // Enable autolayout for container view
        view.addSubview(inputContainerView) // Must add view prior to adding constrains
        
        inputContainerView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        inputContainerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        inputContainerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.5).isActive = true
        
        setupInputLabelandField(label: fizzLabel, labelText: "Fizz", inputField: fizzInputText, previousTextField: nil, parentView: inputContainerView, margins: margins)
        
        setupInputLabelandField(label: buzzLabel, labelText: "Buzz", inputField: buzzInputText, previousTextField: fizzInputText, parentView: inputContainerView, margins: margins)
        
        setupInputLabelandField(label: startLabel, labelText: "Start", inputField: startInputText, previousTextField: buzzInputText, parentView: inputContainerView, margins: margins)
        
        setupInputLabelandField(label: endLabel, labelText: "End", inputField: endInputText, previousTextField: startInputText, parentView: inputContainerView, margins: margins)
        
        setupInputLabelandField(label: bazzLabel, labelText: "Bazz:", inputField: bazzInputText, previousTextField: endInputText, parentView: inputContainerView, margins: margins)
        bazzInputText.placeholder = "(Optional) integer"
        
        bazzOptionButton.setTitle(bazzOptionValues[0], for: UIControlState.normal)
        bazzOptionButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(bazzOptionButton)
        bazzOptionButton.centerYAnchor.constraint(equalTo: bazzLabel.centerYAnchor).isActive = true
        bazzOptionButton.leftAnchor.constraintEqualToSystemSpacingAfter(bazzLabel.rightAnchor, multiplier: 1).isActive = true
        bazzOptionButton.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
    }
    
    @objc private func handleOptionButton() {
        view.endEditing(true) // Dismiss keyboard
        
        bazzOptionPicker.isHidden = !bazzOptionPicker.isHidden
        doneButton.isHidden = !doneButton.isHidden
        runButton.isHidden = !doneButton.isHidden
        resultContainerView.isHidden = runButton.isHidden
        
        resultData.removeAll()
        resultTable.reloadData()
    }
    
    @objc private func handleRunButton() {
        view.endEditing(true) // Dismiss keyboard
        
        resultData.removeAll()
        resultTable.reloadData()
        
        let goFizzBuzzBazz = GoFizzBuzzBazz()
        
        goFizzBuzzBazz.Fizz = Int(fizzInputText.text!)
        goFizzBuzzBazz.Buzz = Int(buzzInputText.text!)
        
        var startNum : Int? = Int(startInputText.text!)
        if startNum == nil { startNum = 0 }
        
        var endNum: Int? = Int(endInputText.text!)
        if endNum == nil { endNum = 0 }
        
        var bazzNum: Int? = Int(bazzInputText.text!)
        if bazzNum == nil { bazzNum = 0 }
        
        var pFunc: (Int, Int) -> Bool = goFizzBuzzBazz.noBazz
        
        if bazzNum != 0 {
            switch(bazzOptionInx) {
            case 1: pFunc = goFizzBuzzBazz.iLessThanBazz
            case 2: pFunc = goFizzBuzzBazz.iEqualBazz
            case 3: pFunc = goFizzBuzzBazz.iGreaterThanBazz
            default: pFunc = goFizzBuzzBazz.noBazz
            }
        }
        
        resultData = goFizzBuzzBazz.FizzBuzzBazz(iStart: startNum!, iEnd: endNum!, iBazz: bazzNum!, predicateFunc: pFunc)
        resultTable.reloadData()
    }
    
    // MARK: Option picker for Bazz
    private let bazzOptionValues = ["(Not in use)", "Less than", "Equal to", "Greater than"]
    private var bazzOptionInx = 0
    func setupBazzOptionPicker(previousControl: UIView?, containerView: UIView, margins: UILayoutGuide) {
        bazzOptionPicker.translatesAutoresizingMaskIntoConstraints = false
        bazzOptionPicker.delegate = self
        bazzOptionPicker.dataSource = self
        bazzOptionPicker.showsSelectionIndicator = true
        containerView.addSubview(bazzOptionPicker)
        if previousControl != nil {
            bazzOptionPicker.topAnchor.constraint(equalTo: (previousControl?.bottomAnchor)!).isActive = true
        }
        else {
            bazzOptionPicker.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        }
        
        bazzOptionPicker.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bazzOptionPicker.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        bazzOptionPicker.isHidden = true
        
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(doneButton)
        doneButton.centerYAnchor.constraint(equalTo: bazzOptionPicker.centerYAnchor).isActive = true
        
        doneButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive = true
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        doneButton.isHidden = true
    }
    
    // Bazz option picker Done button
    @objc func handleDoneButton() {
        doneButton.isHidden = true
        bazzOptionPicker.isHidden = true
        runButton.isHidden = false
        resultContainerView.isHidden = false
    }
    
    // Bazz option picker components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bazzOptionValues.count
    }
    
    // Return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bazzOptionValues[row]
    }
    
    // Delegate method called when the row selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bazzOptionButton.setTitle(bazzOptionValues[row], for: .normal)
        bazzOptionInx = row
    }
    
    // MARK: General input setup function
    func setupInputLabelandField(label: UILabel, labelText: String, inputField: UITextField, previousTextField: UITextField?, parentView: UIView, margins: UILayoutGuide) {
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(label)
        
        if previousTextField != nil {
            label.topAnchor.constraint(equalTo: (previousTextField?.bottomAnchor)!, constant: 5).isActive = true
        }
        else {
            label.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5).isActive = true
        }
        
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        inputField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        inputField.placeholder = "Enter an integer"
        inputField.borderStyle = .roundedRect
        inputField.keyboardType = .numberPad
        
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(inputField)
        inputField.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        inputField.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
    }
    
    private func addRunResultView(previousControl: UIView) {
        runOptionContainerView.translatesAutoresizingMaskIntoConstraints = false // Enable autolayout for container view
        view.addSubview(runOptionContainerView)
        runOptionContainerView.topAnchor.constraint(equalTo: previousControl.bottomAnchor, constant: 5).isActive = true
        runOptionContainerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        runOptionContainerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        runOptionContainerView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        runOptionContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        setupBazzOptionPicker(previousControl: nil, containerView: runOptionContainerView, margins: margins)
        
        runButton.setTitle("Run", for: UIControlState.normal)
        runButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        runButton.translatesAutoresizingMaskIntoConstraints = false
        runOptionContainerView.addSubview(runButton)
        runButton.topAnchor.constraint(equalTo: runOptionContainerView.topAnchor).isActive = true
        runButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        runButton.addTarget(self, action: #selector(handleRunButton), for: .touchUpInside)
        runButton.isHidden = false
        
        addResultView(previousControl: runButton)
    }
    
    private func addResultView(previousControl: UIView) {
        resultContainerView.translatesAutoresizingMaskIntoConstraints = false // Enable autolayout for container view
        view.addSubview(resultContainerView) // Must add view prior to adding constrains
        resultContainerView.topAnchor.constraint(equalTo: previousControl.bottomAnchor, constant: 5).isActive = true
        resultContainerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        resultContainerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        resultContainerView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        
        resultTable = UITableView(frame: CGRect(x:0, y:0, width:layoutWidth * 0.9, height:  resultContainerView.frame.size.height), style: UITableViewStyle.plain) // Height will be adjusted in runtime in setPortraitLayout() because the container view height has not been established at this time.
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.register(UITableViewCell.self, forCellReuseIdentifier: "ResultItemCell")
        resultTable.translatesAutoresizingMaskIntoConstraints = false
        resultContainerView.addSubview(resultTable)
    }
    
    // MARK: Result Table View delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ResultItemCell")
        cell.textLabel!.text = resultData[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Result:"
    }
}
