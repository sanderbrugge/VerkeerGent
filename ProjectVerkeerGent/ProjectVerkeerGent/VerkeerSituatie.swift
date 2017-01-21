import SwiftyJSON
import Alamofire
import CoreLocation

class VerkeerSituatie {
    private let url = URL(string: "https://datatank.stad.gent/4/mobiliteit/verkeersmeldingenactueel.json")!
    
    //singleton met lazy loading door static zoals in de les
    static let shared = VerkeerSituatie()
    private init() {}
    
    //get data via alamofire met automatische validatie zoals gezien op: https://github.com/Alamofire/Alamofire
    func getData(
        completionHandler: @escaping ([Melding]?) -> ()){
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let data = response.result.value {
                    let json = JSON(data)
                    var meldingen: [Melding] = []
                    for result in json["result"].arrayValue{
                        
                        let type = result["type"].stringValue
                        let message = result["payload"]["message"].stringValue
                        let transport = result["transport"].stringValue
                        let location = CLLocationCoordinate2D(latitude: result["sourcePayload"]["location"]["x"].doubleValue, longitude: result["sourcePayload"]["location"]["y"].doubleValue)
                        //print(type,message,transport,location)
                        meldingen.append(Melding(type:type,transport: transport, message: message, location: location))
                        //let melding = Melding(type:type,transport: transport, message: message, location: location)
                        
                        
                    }
                    completionHandler(meldingen)
            }
                
                
            case .failure(let error):
                print(error)
            }
        }
       
    }
    
    //completionHandler pattern, zoals gevonden op stackoverflow, en raywenderlich
    func getMeldingen(completionHandler: @escaping ([Melding]?) -> ()){
        getData(completionHandler: completionHandler)
    }
}

