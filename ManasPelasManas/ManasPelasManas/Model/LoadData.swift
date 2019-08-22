//
//  LoadData.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

class loadData {
    
    init() {
        //Alguns exemplos de mock
        let user1 = User(userId: 1, name: "Hermione", bornDate: createFomattedDate(date: "19/09/1979"), photo: "hermione.photo", autenticated: true)
        let user2 = User(userId: 2, name: "Annalise", bornDate: createFomattedDate(date: "11/08/1965"), photo: "annalise.photo", autenticated: false)
        let user3 = User(userId: 3, name: "Cristina", bornDate: createFomattedDate(date: "20/07/1971"), photo: "cristina.photo", autenticated: false)
        let user4 = User(userId: 4, name: "Daenerys", bornDate: createFomattedDate(date: "23/10/1986"), photo: "daenerys.photo", autenticated: false)
        
        
        let cb = createCircularRegion(latitude: -22.817889, longitude: -47.068661, radius: 120, referencia: "CB")
        let moras = createCircularRegion(latitude: -22.821561, longitude: -47.088216, radius: 120, referencia: "Moradia")
        let av3 = createCircularRegion(latitude: -22.811373, longitude: -47.075498, radius: 50, referencia: "AV3")
        let eldorado = createCircularRegion(latitude: -22.813339, longitude: -47.061741, radius: 100, referencia: "Eldorado")
        let iq = createCircularRegion(latitude: -22.819317, longitude: -47.067570, radius: 70, referencia: "IQ")
        let ru = createCircularRegion(latitude: -22.817365, longitude: -47.072196, radius: 50, referencia: "RU")
        
        
        let path1 = Path(pathId: 1, origin: eldorado, destiny: av3)
        let path2 = Path(pathId: 2, origin: iq, destiny: moras)
        let path3 = Path(pathId: 3, origin: cb, destiny: moras)
        let path4 = Path(pathId: 4, origin: av3, destiny: ru)
        
        let journey1 = Journey(journeyId: 1, userId: 1, path: path1, date: createFomattedDate(date: "30/08/2019"), initialHour: createFormattedHour(hour: "07:30"), finalHour: createFormattedHour(hour: "08:00"), status: .requested)
        let journey2 = Journey(journeyId: 2, userId: 1, path: path2, date: createFomattedDate(date: "31/08/2019"), initialHour: createFormattedHour(hour: "20:45"), finalHour: createFormattedHour(hour: "21:30"), status: .requested)
        let journey3 = Journey(journeyId: 3, userId: 2, path: path3, date: createFomattedDate(date: "31/08/2019"), initialHour: createFormattedHour(hour: "20:15"), finalHour: createFormattedHour(hour: "21:15"), status: .requested)
        let journey4 = Journey(journeyId: 4, userId: 3, path: path3, date: createFomattedDate(date: "01/09/2019"), initialHour: createFormattedHour(hour: "20:15"), finalHour: createFormattedHour(hour: "21:15"), status: .requested)
        let journey5 = Journey(journeyId: 5, userId: 4, path: path4, date: createFomattedDate(date: "05/09/2019"), initialHour: createFormattedHour(hour: "14:30"), finalHour: createFormattedHour(hour: "15:00"), status: .requested)
        
        user1.journeys.append(journey1)
        user1.journeys.append(journey2)
        user2.journeys.append(journey3)
        user3.journeys.append(journey4)
        user4.journeys.append(journey5)
        
    }
    

    func createFomattedDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return (formatter.date(from: date))!
    }
    
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return (formatter.date(from: hour))!
    }
    
    
    func createCircularRegion(latitude: Double, longitude: Double , radius: Double, referencia: String) -> CLCircularRegion {
        //Criar guard
        let lat = CLLocationDegrees(exactly: latitude)!
        let long = CLLocationDegrees(exactly: longitude)!
        let rad = CLLocationDistance(exactly: radius)!
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let cirularRegion = CLCircularRegion(center: coordinate, radius: rad, identifier: referencia)
        return cirularRegion
    }
}



