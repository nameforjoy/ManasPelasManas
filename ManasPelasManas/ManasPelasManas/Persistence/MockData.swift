//
//  MockData.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 30/01/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class MockData {
    var users: [User]! = []
    var paths: [Path]! = []
    var journeys: [Journey]! = []
    
    //IDs
    let user1Id = UUID()
    let user2Id = UUID()
    
    init() {
        createUsers()
        createJourneys()
    }
    
    //MARK: Criação de objetos para mock
    func createUsers() {
        let user1 = User(userId: user1Id, name:  "Brenda Santos", bio: "Oi, eu sou a Brenda! Sou inteligente, forte e também enigmática, misteriosa e honesta. Muito dedicada, vou a fundo em tudo o que procuro entender. Tenho uma força de vontade incrível e uma grande capacidade para lidar com situações difíceis. Gosto muito de fazer novas amizades e aproveitar uma boa conversa :) Vamos caminhar juntas e quem sabe nos tornar boas amigas?", bornDate: "12/05/1998", authenticated: 1, photo: "leticia")
        let user2 = User(userId: user2Id, name: "Julia Silva", bio: "Sou uma garota discreta e tímida. Prefiro ficar na minha, vivo com simplicidade. Prática, super responsável e pé no chão, sou bem madura para a minha idade. Tenho uma vida agitada e sempre preciso andar pelas ruas. Gostaria muito de ter uma companhia para andar comigo, principalmente nos meus percursos noturnos.", bornDate: "25/01/2000", authenticated: 0, photo: "mari")
        
        self.users?.append(user1)
        self.users?.append(user2)
    }
    
    func createJourneys() {
        createPaths()
        
        let journey1 = Journey(ownerId: user1Id, journeyId: UUID(), has_path: self.paths[0], initialHour: createFormattedHour(hour: "01/09/2019T09:30"), finalHour: createFormattedHour(hour: "01/09/2019T10:30"))
        self.journeys.append(journey1)
    }
    
    func createPaths() {
        let pathCBtoMORAS = Path(pathId: UUID(), originLat: -22.817889, originLong: -47.068661, originRadius: 400, destinyLat: -22.821561, destinyLong: -47.088216, destinyRadius: 200)
        let pathELDORADOtoAV2 = Path(pathId: UUID(), originLat: -22.812198, originLong: -47.061481, originRadius: 300, destinyLat: -22.821149, destinyLong: -47.076600, destinyRadius: 600)
        let pathELDORADOtoMORAS = Path(pathId: UUID(), originLat: -22.812198, originLong: -47.061481, originRadius: 300, destinyLat: -22.821561, destinyLong: -47.088216, destinyRadius: 200)
        let pathIQtoMC = Path(pathId: UUID(), originLat: -22.817829, originLong: -47.068113, originRadius: 500, destinyLat: -22.825397, destinyLong: -47.079328, destinyRadius: 600)
            
        self.paths.append(pathCBtoMORAS)
        self.paths.append(pathELDORADOtoAV2)
        self.paths.append(pathELDORADOtoMORAS)
        self.paths.append(pathIQtoMC)
    }
    
    //MARK: Métodos auxiliares
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return (formatter.date(from: hour))!
    }
    
    func getAgeFromBornDate(user: User) -> Int? {
        let now = Date()
        let birthday: Date = createFomattedDate(date: user.bornDate ?? "01/01/2001")
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year
    }
    
    func createFomattedDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return (formatter.date(from: date))!
    }
    
    
    
    //MARK: Métodos DAO
    func getAuthenticatedUser() -> User? {
        for user in self.users! {
            if user.authenticated == 1 {
                return user
            }
        }
        return nil
    }
    
    func findUserById(id: UUID) -> User? {
        for user in self.users! {
           if user.userId == id {
               return user
           }
        }
        return nil
    }
    
    func findPathById(id: UUID) -> Path? {
        for path in self.paths! {
            if path.pathId == id {
                return path
            }
         }
         return nil
    }
    
    func findJourneyById(id: UUID) -> Journey? {
        for journey in self.journeys! {
            if journey.journeyId == id {
                return journey
            }
         }
         return nil
    }
    
}
