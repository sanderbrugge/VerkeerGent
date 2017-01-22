import RealmSwift


//standaard Realm object klasse voor een melding toe te voegen in een db
class MeldingObject : Object {
    dynamic var type = ""
    dynamic var transport = ""
    dynamic var message = ""
    dynamic var datum = ""
    
}
