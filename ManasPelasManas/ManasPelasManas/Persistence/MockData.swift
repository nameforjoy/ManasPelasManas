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
    
    init() {
        createUsers()
    }
    
    //MARK: Criação de objetos para mock
    func createUsers() {
        let user1 = User(userId: UUID(), name:  "Brenda Santos", bio: "Oi, eu sou a Brenda! Sou inteligente, forte e também enigmática, misteriosa e honesta. Muito dedicada, vou a fundo em tudo o que procuro entender. Tenho uma força de vontade incrível e uma grande capacidade para lidar com situações difíceis. Gosto muito de fazer novas amizades e aproveitar uma boa conversa :) Vamos caminhar juntas e quem sabe nos tornar boas amigas?", bornDate: "12/05/1998", authenticated: 1, photo: "leticia")
        let user2 = User(userId: UUID(), name: "Julia Silva", bio: "Sou uma garota discreta e tímida. Prefiro ficar na minha, vivo com simplicidade. Prática, super responsável e pé no chão, sou bem madura para a minha idade. Tenho uma vida agitada e sempre preciso andar pelas ruas. Gostaria muito de ter uma companhia para andar comigo, principalmente nos meus percursos noturnos.", bornDate: "25/01/2000", authenticated: 0, photo: "mari")
        
        self.users?.append(user1)
        self.users?.append(user2)
    }
    
    func createJourneys() {
        let journey1 = Journey(ownerId: self.users[0].userId, journeyId: UUID(), has_path: self.paths[0], date: createFomattedDate(date: "01/09/2019"), initialHour: createFormattedHour(hour: "01/09/2019T09:30"), finalHour: createFormattedHour(hour: "01/09/2019T09:30"))
        self.journeys.append(journey1)
    }
    
    func createPaths() {
        let path1 = Path(pathId: UUID(), originLat: -22.817889, originLong: -47.068661, originRadius: 400, destinyLat: -22.821561, destinyLong: -47.088216, destinyRadius: 200)
        
        self.paths.append(path1)
    }
    
    //MARK: Métodos auxiliares
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return (formatter.date(from: hour))!
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
