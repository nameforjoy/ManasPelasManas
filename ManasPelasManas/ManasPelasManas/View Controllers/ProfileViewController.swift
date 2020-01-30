//
//  ProfileViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameContentLabel: UILabel!
    @IBOutlet weak var aboutMeContentLabel: UILabel!
    @IBOutlet weak var profileOverviewTitleLabel: UILabel!
    @IBOutlet weak var aboutMeTitleLabel: UILabel!
    
    @objc var currentUser: User?
    @objc var authenticatedUser: User?
    @objc var journeyTest: Journey?
    @objc var pathTest: Path?
    @objc var journeyMock: Journey?
    @objc var pathMock: Path?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
                //print(user?.objectID)
            } else if user == nil {
                self.createFakeJourney()
                self.createAuthenticatedUser()
                
            }
        }
    }
    
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.nameContentLabel.text = (user.name)! + ", 19"
        self.aboutMeContentLabel.text = (user.bio)!
    }
    
    
    func createCurrentUser()
    {
        //Criando objeto via CoreData
        
        self.currentUser = User()
        self.currentUser?.name = "Julia Silva"
        self.currentUser?.bio = "Sou uma garota discreta e tímida. Prefiro ficar na minha, vivo com simplicidade. Prática, super responsável e pé no chão, sou bem madura para a minha idade. Tenho uma vida agitada e sempre preciso andar pelas ruas. Gostaria muito de ter uma companhia para andar comigo, principalmente nos meus percursos noturnos."
        self.currentUser?.bornDate = Date()
        self.currentUser?.photo = "mari"
        self.currentUser?.authenticated = 0
        self.currentUser?.userId = UUID()
        
        //PARA AQUI!!!
        UserServices.createUser(user: self.currentUser!) { error in
            if (error == nil) {
                //treat error if necessary
                
                self.currentUser?.has_journeys = [self.journeyTest!]
                self.journeyTest?.ownerId = self.currentUser?.userId

                UserServices.updateUser(user: self.currentUser!, { (error) in
                    if (error == nil) {

                    }
                })
            }
        }
        
    }
    
    func createAuthenticatedUser() {
        let dateString = "25/01/2000"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let date = dateFormatter.date(from: dateString) else { return }
        
        self.authenticatedUser = User()
        self.authenticatedUser?.name = "Brenda Santos"
        self.authenticatedUser?.bio = "Oi, eu sou a Brenda! Sou inteligente, forte e também enigmática, misteriosa e honesta. Muito dedicada, vou a fundo em tudo o que procuro entender. Tenho uma força de vontade incrível e uma grande capacidade para lidar com situações difíceis. Gosto muito de fazer novas amizades e aproveitar uma boa conversa :) Vamos caminhar juntas e quem sabe nos tornar boas amigas?"
        self.authenticatedUser?.bornDate = date
        self.authenticatedUser?.photo = "leticia"
        self.authenticatedUser?.authenticated = 1
        self.authenticatedUser?.userId = UUID()
        
        UserServices.createUser(user: self.authenticatedUser!) { (error) in
            if (error == nil) {
                self.displayData(user: self.authenticatedUser!)
            }
        }
    }
    
    
    func createFakeJourney() {
        self.journeyTest = Journey()
        self.journeyTest?.initialHour = createFormattedHour(hour: "01/09/2019T09:30")
        self.journeyTest?.finalHour = createFormattedHour(hour: "05/09/2019T23:00")
        self.journeyTest?.journeyId = UUID()

        createCBToMorasPath()
        
        //treat error if necessary
        if(self.pathTest != nil) {

            //criar metodo no services para salvar path antes de criar journey
            self.pathTest?.managedObjectContext?.insert(self.journeyTest!)
            do {
                try self.pathTest?.managedObjectContext?.save()
            } catch {
                print("Ooops \(error)")
            }
            self.journeyTest!.has_path = self.pathTest!
            JourneyServices.createJourney(journey: self.journeyTest!, { (error) in
                if (error == nil) {
                    self.createCurrentUser()
                }
            })
        }
    }
    
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return (formatter.date(from: hour))!
    }
    
    func createCBToMorasPath() {
        pathTest = Path()
        self.pathTest?.pathId = UUID()
        self.pathTest?.originLat = -22.817889
        self.pathTest?.originLong = -47.068661
        self.pathTest?.originRadius = 400
        self.pathTest?.destinyLat = -22.821561
        self.pathTest?.destinyLong = -47.088216
        self.pathTest?.destinyRadius = 200
        
        PathServices.createPath(path: self.pathTest!) { error in
            if (error != nil) {
                //treat error
            }
        }
    }
}

