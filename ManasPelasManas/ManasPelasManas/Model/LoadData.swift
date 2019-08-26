//
//  LoadData.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

class LoadData {
    var user1: User
    var user2: User
    var user3: User
    var user4: User

    
    init() {
        //Alguns exemplos de mock
        self.user1 = User(userId: 1, name: "Hermione", bio: "Eu adoro voar nas vassouras!", bornDate: LoadData.createFomattedDate(date: "19/09/1979"), photo: "hermione.photo", authenticated: true)
        self.user2 = User(userId: 2, name: "Annalise", bio: "Oie!", bornDate: LoadData.createFomattedDate(date: "11/08/1965"), photo: "annalise.photo", authenticated: false)
        self.user3 = User(userId: 3, name: "Cristina", bio: "Olar!", bornDate: LoadData.createFomattedDate(date: "20/07/1971"), photo: "cristina.photo", authenticated: false)
        self.user4 = User(userId: 4, name: "Daenerys", bio: "Dracarys", bornDate: LoadData.createFomattedDate(date: "23/10/1986"), photo: "daenerys.photo", authenticated: false)
        
        
        let cb = createCircularRegion(latitude: -22.817889, longitude: -47.068661, radius: 120, referencia: "CB")
        let moras = createCircularRegion(latitude: -22.821561, longitude: -47.088216, radius: 120, referencia: "Moradia")
        let av3 = createCircularRegion(latitude: -22.811373, longitude: -47.075498, radius: 500, referencia: "AV3")
        let eldorado = createCircularRegion(latitude: -22.813339, longitude: -47.061741, radius: 1000, referencia: "Eldorado")
        let iq = createCircularRegion(latitude: -22.819317, longitude: -47.067570, radius: 100, referencia: "IQ")
        let ru = createCircularRegion(latitude: -22.817365, longitude: -47.072196, radius: 50, referencia: "RU")
        
        
        let path1 = Path(pathId: 1, origin: eldorado, destiny: av3)
        let path2 = Path(pathId: 2, origin: iq, destiny: moras)
        let path3 = Path(pathId: 3, origin: cb, destiny: moras)
        let path4 = Path(pathId: 4, origin: av3, destiny: ru)
        
        let journey1 = Journey(journeyId: 1, userId: 1, path: path1, date: LoadData.createFomattedDate(date: "30/08/2019"), initialHour: createFormattedHour(hour: "30/08/2019T07:30"), finalHour: createFormattedHour(hour: "30/08/2019T08:00"), status: .requested)
        let journey2 = Journey(journeyId: 2, userId: 1, path: path2, date: LoadData.createFomattedDate(date: "31/08/2019"), initialHour: createFormattedHour(hour: "31/08/2019T20:45"), finalHour: createFormattedHour(hour: "31/08/2019T21:30"), status: .requested)
        let journey3 = Journey(journeyId: 3, userId: 2, path: path3, date: LoadData.createFomattedDate(date: "31/08/2019"), initialHour: createFormattedHour(hour: "31/08/2019T20:15"), finalHour: createFormattedHour(hour: "31/08/2019T21:15"), status: .requested)
        let journey4 = Journey(journeyId: 4, userId: 3, path: path3, date: LoadData.createFomattedDate(date: "01/09/2019"), initialHour: createFormattedHour(hour: "01/09/2019T20:15"), finalHour: createFormattedHour(hour: "01/09/2019T21:15"), status: .requested)
        let journey5 = Journey(journeyId: 5, userId: 4, path: path4, date: LoadData.createFomattedDate(date: "05/09/2019"), initialHour: createFormattedHour(hour: "05/09/2019T14:30"), finalHour: createFormattedHour(hour: "05/09/2019T15:00"), status: .requested)
        
        user1.journeys.append(journey1)
        user1.journeys.append(journey2)
        user2.journeys.append(journey3)
        user3.journeys.append(journey4)
        user4.journeys.append(journey5)
        
    }
    

    //Fazer guards!!
    static func createFomattedDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return (formatter.date(from: date))!
    }
    
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return (formatter.date(from: hour))!
    }
    
    
    func createCircularRegion(latitude: Double, longitude: Double , radius: Double, referencia: String) -> CLCircularRegion {
        guard let lat = CLLocationDegrees(exactly: latitude), let long = CLLocationDegrees(exactly: longitude) else {
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: -15.792953 , longitude: -47.886961), radius: 100, identifier: "brasilia")
        }
        let rad = CLLocationDistance(exactly: radius)!
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let cirularRegion = CLCircularRegion(center: coordinate, radius: rad, identifier: referencia)
        return cirularRegion
    }
}



