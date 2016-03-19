//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Javier González Rojo on 19/3/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    //MARK: - Variables
    var pokemon: Pokemon!

    //MARK: - ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - IBActions
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Helper functions
    func updateUI() {
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        pokedexLbl.text = "\(pokemon.pokedexId)"
        descriptionLbl.text = pokemon.pokeDescription
        
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No evolutions"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            
            var str = "Next Evolution: \(pokemon.nextEvolText)"
            if pokemon.nextEvoLevel != "" {
                str += " - LVL \(pokemon.nextEvoLevel)"
            }
        }
        
    }
}
