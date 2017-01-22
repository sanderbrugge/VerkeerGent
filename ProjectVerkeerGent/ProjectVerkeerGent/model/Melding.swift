import CoreLocation

class Melding {
    let type: String
    let transport: String
    let message: String
    let location: CLLocationCoordinate2D
    
    init(type: String, transport: String, message: String, location: CLLocationCoordinate2D){
        self.type = type
        self.transport = transport
        self.message = message
        self.location = location
    }
    
}
/*extension Melding {
    convenience init() throws{
        
    }
}*/
