import UIKit
import RealmSwift
class MeldingOverzichtViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var geenMeldingen: UIView!
    @IBOutlet weak var titel: UILabel!
    fileprivate var meldingen: [MeldingObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController!.delegate = self
         print("LOG: in meldingsoverzichtviewcontroller")
        
        
        
        tableView.addSubview(geenMeldingen)
        geenMeldingen.translatesAutoresizingMaskIntoConstraints = false
        tableView.addConstraints([
            //nieuwe manier
            geenMeldingen.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            geenMeldingen.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        geenMeldingen.isHidden = true

        
      
       
        getMeldingen()
        let aantal = meldingen.count
       updateTitel(aantal)
       // deleteAllInRealm()
        if meldingen.count <= 0 {
            self.showErrorView()
            self.tableView.reloadData()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl

    }
    private func showErrorView() {
        self.geenMeldingen.isHidden = false
        tableView.separatorStyle = .none
    }
    private func hideErrorView() {
        self.geenMeldingen.isHidden = true
        tableView.separatorStyle = .singleLine
    }

    
    /*
     test functie om hardcoded data toe te voegen in realm
     
     func setMelding(){
        let melding = MeldingObject()
        
        melding.message = "test message"
        melding.type = "test type"
        melding.transport = "test transp‡ort"
        let realm = try! Realm()
        try! realm.write {
            realm.add(melding)
        }
    }*/
   
    func deleteAllInRealm(){
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    //standaard realm structuur
    func getMeldingen(){
        
        let realm = try! Realm()
        
        let meldings = realm.objects(MeldingObject.self)
        
        for melding in meldings {
            meldingen.append(melding)
            print("\(melding.type)")
        }
    }
    func updateTitel(_ aantal: Int){
        if aantal == 1 {
            titel.text = "U heeft \(meldingen.count) melding geplaatst."
        } else {
            titel.text = "U heeft \(meldingen.count) meldingen geplaatst."
            
        }
    }
    //unwind van de segue om de data direct te herladen na een cancel, of een add
    @IBAction func unwindFromToegevoegd(_ segue: UIStoryboardSegue) {
        let source = segue.source as! AddMeldingViewController
        if let meldingObject = source.nieuweMelding {
            let melding = MeldingObject()
            let vandaag = Date()
            melding.type = meldingObject.type
            melding.transport = meldingObject.transport
            melding.message = meldingObject.message
            melding.datum = vandaag.toString()
            
            print("Vandaag: \(melding.datum)")
            
            meldingen.append(melding)
            refreshTableView()
        }
    }
    @IBAction func unwindFromNogAanwezig(_ segue: UIStoryboardSegue) {
        refreshTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    @IBAction func unwindFromVerwijderd(_ segue: UIStoryboardSegue) {
        //guard?
        
        let bron = segue.source as! MeldingDetailViewController
        if let melding = bron.melding {
            let realm = try! Realm()
            let meldingTeVerwijderen = realm.objects(MeldingObject.self).filter("datum = '\(melding.datum)'")
            
            let index = meldingen.index(of: melding)
            try! realm.write {
                realm.delete(meldingTeVerwijderen)
            }
            meldingen.remove(at: index!)
        }
    }
    func refreshTableView() {
        self.tableView.reloadData()
        let aantal = meldingen.count
        if aantal > 0 {
            self.hideErrorView()
            updateTitel(aantal)
        }
        self.tableView.refreshControl!.endRefreshing()
    }
   
    //segue "voorbereiden" om data door te sturen naar de gespecifiëerde ontvanger, in this case: detail controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            //case zort ervoor dat dit deel code enkel uitgevoerd wordt bij de segue naar het detail scherm
        case "bekijk":
            let navigationController = segue.destination as! UINavigationController
            let meldingDetailViewController = navigationController.topViewController as! MeldingDetailViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            meldingDetailViewController.melding = meldingen[selectedIndex]
        default:
            break
        }
       
    }

    
}
//extension voor splitview, zoals gezien in de les
extension MeldingOverzichtViewController: UITableViewDelegate {
    
}
extension MeldingOverzichtViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
//extension om de dag van vandaag om te zetten in een formaat dat gebruikt wordt bij het overzicht
extension Date {
    //gevolgd van stack overflow: http://stackoverflow.com/questions/38564893/date-formatting-not-working-in-swift-3
    func datumNaarStringVoorGUi() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - MMMM - yyyy"
        return dateFormatter.string(from: self)
    }
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy-HH-mm-ss"
        return dateFormatter.string(from: self)
    }
}
//extension (aanvulling op de klasse) zoals gezien in de les voor opvullen prototype cell (parkings)
extension MeldingOverzichtViewController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meldingen.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KorteInhoud", for: indexPath)
        let melding = meldingen[indexPath.row]
        print("MESSAGE: \(melding.message)")
        cell.textLabel!.text = "\(melding.type): \(melding.message)"
        return cell
    }
    
}
