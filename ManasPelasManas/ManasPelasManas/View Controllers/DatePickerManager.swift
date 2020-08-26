//
//  DatePickerManager.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

protocol DatePickerParentView: class {
    func updateDateLabels(newDate: Date)
    func dismissDatePicker()
}

class DatePickerManager {
    
    weak var datePicker: UIDatePicker!
    weak var parentView: DatePickerParentView!

    init(datePicker: UIDatePicker, parentView: DatePickerParentView) {
        self.datePicker = datePicker
        self.parentView = parentView
        self.datePickerConfig()
    }

    func datePickerConfig() {
        self.datePicker.isHidden = true
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker: )), for: .valueChanged)

        // Define date boundaries, from current date up to 60 days after
        self.datePicker.minimumDate = Date()
        self.datePicker.maximumDate = Date().addingTimeInterval(TimeInterval(60*60*24*60))
    }

    @objc func dateChanged(datePicker: UIDatePicker) {
        self.parentView.updateDateLabels(newDate: datePicker.date)
    }

    func createToolbar(_ completion: (_ toolbar: UIToolbar) -> Void) {

        // Creates ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isUserInteractionEnabled = true

        // Creates Done Button with Flexible Space for Left Alignment
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem:.done, target: self, action: #selector(donePressed))
        done.tintColor = UIColor(named: "actionColor")

        // Includes items to the toolbar
        toolbar.setItems([flexButton, done], animated: false)

        completion(toolbar)
    }

    // Dismiss datepicker and saves data if necessary
    @objc func donePressed() {
        self.parentView.dismissDatePicker()
    }

    // Non-Working-Code
    // Expected behaviour:
    // Define maximumm range between starting and final time  for security
    func checkDateIntervalConsistency(selectedFirstCell: Bool, earlierDate: Date?, latestDate: Date?, datePicker: UIDatePicker) {
        let maxTimeDifferenceInHours = 8

        if selectedFirstCell && latestDate != nil {
            datePicker.maximumDate = latestDate
            datePicker.minimumDate = latestDate?.addingTimeInterval(TimeInterval(-maxTimeDifferenceInHours*60*60))
        } else if !selectedFirstCell && earlierDate != nil {
            datePicker.minimumDate = earlierDate
            datePicker.maximumDate = earlierDate?.addingTimeInterval(TimeInterval(maxTimeDifferenceInHours*60*60))
        }
    }
}
