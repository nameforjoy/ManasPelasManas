//
//  DateHandler.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 26/08/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation

class DateHelper {
    
    private static func formatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        return dateFormatter
    }
    
    static func dateToString(date: Date, format: String) -> String {
        let dateFormatter = formatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func dateToStringAccessible(date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let dateFormatter = formatter()
        let dayString = dateFormatter.string(from: date)
        
        return "\(hour) horas e \(minute) minutos, " + "de " + dayString
    }
    
    static func dateToStringAccessible(initialHour: Date, finalHour: Date) -> String {
        let calendar = Calendar.current
        let iniHour = calendar.component(.hour, from: initialHour)
        let iniMinute = calendar.component(.minute, from: initialHour)
        let finHour = calendar.component(.hour, from: finalHour)
        let finMinute = calendar.component(.minute, from: finalHour)
        
        let dateFormatter = formatter()
        let dayString = dateFormatter.string(from: initialHour)
        
        return "\(dayString), entre \(iniHour) horas e \(iniMinute) minutos e as \(finHour) e \(finMinute) minutos"
    }
}
