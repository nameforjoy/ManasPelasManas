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
    @IBOutlet weak var bioTitleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createFakeUser()
        profilePhoto.image = UIImage(named: user!.photo)
        bioTitleLabel.text = user!.name + ", " + "19"
        bioLabel.text = user!.bio
    }
    
    func createFakeUser()
    {
        let dateString = "25/01/2000"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let date = dateFormatter.date(from: dateString) else { return }
        
        user = User(userId: 1, name: "Brenda Santos", bio: "Escorpiana, sempre buscando experiências diferentes. Adoro conhecer pessoas novas, e adoraria se essas caminhadas juntas fossem mais do que por segurança e se tornassem amizades de verdade. Ás vezes levo a Paçoca (minha cachorra e amor da minha vida) junto nos trajetos. Ela é um amor, não morde, e adora carinho :) Conheci o app por uma amiga, amei a ideia de nos juntarmos para nos sentirmos mais à vontade, e to ansiosíssima desde já para não andar com as chaves entre os dedos. Sou meio chata com pontualidade, mas aceita meus requests aí, pfvr, nunca te pedi nada hahahahah #EleNão", bornDate: date, photo: "user", authenticated: true)
    }
}
