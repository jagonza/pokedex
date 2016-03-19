//
//  Pokemon.swift
//  pokedex
//
//  Created by Javier González Rojo on 17/3/16.
//  Copyright © 2016 Javier González Rojo. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoId: String!
    private var _nextEvoText: String!
    private var _nextEvoLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var pokeDescription: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLevel: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    var pokemonUrl: String {
        return _pokemonUrl
    }
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dic = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dic["weight"] as? String {
                    self._weight = weight
                }
                if let height = dic["height"] as? String {
                    self._height = height
                }
                if let attack = dic["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dic["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dic["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let typeName = types[0]["name"] {
                        self._type = typeName.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let typeName = types[x]["name"] {
                                self._type! += " / \(typeName.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArray = dic["descriptions"] as? [Dictionary<String,String>] where descArray.count > 0 {
                    
                    let descUri = descArray[0]["resource_uri"]!
                    let url = NSURL(string: "\(URL_BASE)\(descUri)")
                    Alamofire.request(.GET, url!).responseJSON(completionHandler: { response in
                    
                        let descResult = response.result
                        if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                            if let description = descDict["description"] as? String {
                                self._description = description
                            }
                        }
                        
                        completed()
                        
                    })
                    
                    
                } else{
                    self._description = ""
                }
                
                if let evolutions = dic["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") ==  nil {

                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvoId = num
                                self._nextEvoText = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvoLevel = "\(lvl)"
                                }
                            }

                        }
                    }
                }
                
            }

        }
        
    }
    
}