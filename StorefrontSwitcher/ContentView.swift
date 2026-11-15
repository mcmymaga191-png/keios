import SwiftUI
import Darwin
import Foundation

struct Storefront: Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    var flag: String {
        if code == "xk" { return "🇽🇰" }
        return String(String.UnicodeScalarView(code.uppercased().unicodeScalars.compactMap {
            UnicodeScalar(127397 + $0.value)
        }))
    }
    var displayName: String { "\(flag)  \(name) (\(code.uppercased()))" }

    static let all: [Storefront] = [
        .init(id:"143610",code:"af",name:"Afghanistan"),
        .init(id:"143575",code:"al",name:"Albania"),
        .init(id:"143563",code:"dz",name:"Algeria"),
        .init(id:"143564",code:"ao",name:"Angola"),
        .init(id:"143538",code:"ai",name:"Anguilla"),
        .init(id:"143540",code:"ag",name:"Antigua and Barbuda"),
        .init(id:"143505",code:"ar",name:"Argentina"),
        .init(id:"143524",code:"am",name:"Armenia"),
        .init(id:"143460",code:"au",name:"Australia"),
        .init(id:"143445",code:"at",name:"Austria"),
        .init(id:"143568",code:"az",name:"Azerbaijan"),
        .init(id:"143539",code:"bs",name:"Bahamas"),
        .init(id:"143559",code:"bh",name:"Bahrain"),
        .init(id:"143541",code:"bb",name:"Barbados"),
        .init(id:"143565",code:"by",name:"Belarus"),
        .init(id:"143446",code:"be",name:"Belgium"),
        .init(id:"143555",code:"bz",name:"Belize"),
        .init(id:"143576",code:"bj",name:"Benin"),
        .init(id:"143542",code:"bm",name:"Bermuda"),
        .init(id:"143577",code:"bt",name:"Bhutan"),
        .init(id:"143556",code:"bo",name:"Bolivia"),
        .init(id:"143612",code:"ba",name:"Bosnia and Herzegovina"),
        .init(id:"143525",code:"bw",name:"Botswana"),
        .init(id:"143503",code:"br",name:"Brazil"),
        .init(id:"143543",code:"vg",name:"British Virgin Islands"),
        .init(id:"143560",code:"bn",name:"Brunei"),
        .init(id:"143526",code:"bg",name:"Bulgaria"),
        .init(id:"143578",code:"bf",name:"Burkina Faso"),
        .init(id:"143579",code:"kh",name:"Cambodia"),
        .init(id:"143574",code:"cm",name:"Cameroon"),
        .init(id:"143455",code:"ca",name:"Canada"),
        .init(id:"143580",code:"cv",name:"Cape Verde"),
        .init(id:"143544",code:"ky",name:"Cayman Islands"),
        .init(id:"143581",code:"td",name:"Chad"),
        .init(id:"143483",code:"cl",name:"Chile"),
        .init(id:"143465",code:"cn",name:"China"),
        .init(id:"143501",code:"co",name:"Colombia"),
        .init(id:"143495",code:"cr",name:"Costa Rica"),
        .init(id:"143494",code:"hr",name:"Croatia"),
        .init(id:"143557",code:"cy",name:"Cyprus"),
        .init(id:"143489",code:"cz",name:"Czechia"),
        .init(id:"143527",code:"ci",name:"Côte d'Ivoire"),
        .init(id:"143613",code:"cd",name:"DR Congo"),
        .init(id:"143458",code:"dk",name:"Denmark"),
        .init(id:"143545",code:"dm",name:"Dominica"),
        .init(id:"143508",code:"do",name:"Dominican Republic"),
        .init(id:"143509",code:"ec",name:"Ecuador"),
        .init(id:"143516",code:"eg",name:"Egypt"),
        .init(id:"143506",code:"sv",name:"El Salvador"),
        .init(id:"143518",code:"ee",name:"Estonia"),
        .init(id:"143602",code:"sz",name:"Eswatini"),
        .init(id:"143583",code:"fj",name:"Fiji"),
        .init(id:"143447",code:"fi",name:"Finland"),
        .init(id:"143442",code:"fr",name:"France"),
        .init(id:"143614",code:"ga",name:"Gabon"),
        .init(id:"143584",code:"gm",name:"Gambia"),
        .init(id:"143615",code:"ge",name:"Georgia"),
        .init(id:"143443",code:"de",name:"Germany"),
        .init(id:"143573",code:"gh",name:"Ghana"),
        .init(id:"143448",code:"gr",name:"Greece"),
        .init(id:"143546",code:"gd",name:"Grenada"),
        .init(id:"143504",code:"gt",name:"Guatemala"),
        .init(id:"143585",code:"gw",name:"Guinea-Bissau"),
        .init(id:"143553",code:"gy",name:"Guyana"),
        .init(id:"143510",code:"hn",name:"Honduras"),
        .init(id:"143463",code:"hk",name:"Hong Kong"),
        .init(id:"143482",code:"hu",name:"Hungary"),
        .init(id:"143558",code:"is",name:"Iceland"),
        .init(id:"143467",code:"in",name:"India"),
        .init(id:"143476",code:"id",name:"Indonesia"),
        .init(id:"143617",code:"iq",name:"Iraq"),
        .init(id:"143449",code:"ie",name:"Ireland"),
        .init(id:"143491",code:"il",name:"Israel"),
        .init(id:"143450",code:"it",name:"Italy"),
        .init(id:"143511",code:"jm",name:"Jamaica"),
        .init(id:"143462",code:"jp",name:"Japan"),
        .init(id:"143528",code:"jo",name:"Jordan"),
        .init(id:"143517",code:"kz",name:"Kazakhstan"),
        .init(id:"143529",code:"ke",name:"Kenya"),
        .init(id:"143624",code:"xk",name:"Kosovo"),
        .init(id:"143493",code:"kw",name:"Kuwait"),
        .init(id:"143586",code:"kg",name:"Kyrgyzstan"),
        .init(id:"143587",code:"la",name:"Laos"),
        .init(id:"143519",code:"lv",name:"Latvia"),
        .init(id:"143497",code:"lb",name:"Lebanon"),
        .init(id:"143588",code:"lr",name:"Liberia"),
        .init(id:"143567",code:"ly",name:"Libya"),
        .init(id:"143520",code:"lt",name:"Lithuania"),
        .init(id:"143451",code:"lu",name:"Luxembourg"),
        .init(id:"143515",code:"mo",name:"Macao"),
        .init(id:"143531",code:"mg",name:"Madagascar"),
        .init(id:"143589",code:"mw",name:"Malawi"),
        .init(id:"143473",code:"my",name:"Malaysia"),
        .init(id:"143488",code:"mv",name:"Maldives"),
        .init(id:"143532",code:"ml",name:"Mali"),
        .init(id:"143521",code:"mt",name:"Malta"),
        .init(id:"143590",code:"mr",name:"Mauritania"),
        .init(id:"143533",code:"mu",name:"Mauritius"),
        .init(id:"143468",code:"mx",name:"Mexico"),
        .init(id:"143591",code:"fm",name:"Micronesia"),
        .init(id:"143523",code:"md",name:"Moldova"),
        .init(id:"143592",code:"mn",name:"Mongolia"),
        .init(id:"143619",code:"me",name:"Montenegro"),
        .init(id:"143547",code:"ms",name:"Montserrat"),
        .init(id:"143620",code:"ma",name:"Morocco"),
        .init(id:"143593",code:"mz",name:"Mozambique"),
        .init(id:"143570",code:"mm",name:"Myanmar"),
        .init(id:"143594",code:"na",name:"Namibia"),
        .init(id:"143606",code:"nr",name:"Nauru"),
        .init(id:"143484",code:"np",name:"Nepal"),
        .init(id:"143452",code:"nl",name:"Netherlands"),
        .init(id:"143461",code:"nz",name:"New Zealand"),
        .init(id:"143512",code:"ni",name:"Nicaragua"),
        .init(id:"143534",code:"ne",name:"Niger"),
        .init(id:"143561",code:"ng",name:"Nigeria"),
        .init(id:"143530",code:"mk",name:"North Macedonia"),
        .init(id:"143457",code:"no",name:"Norway"),
        .init(id:"143562",code:"om",name:"Oman"),
        .init(id:"143477",code:"pk",name:"Pakistan"),
        .init(id:"143595",code:"pw",name:"Palau"),
        .init(id:"143485",code:"pa",name:"Panama"),
        .init(id:"143597",code:"pg",name:"Papua New Guinea"),
        .init(id:"143513",code:"py",name:"Paraguay"),
        .init(id:"143507",code:"pe",name:"Peru"),
        .init(id:"143474",code:"ph",name:"Philippines"),
        .init(id:"143478",code:"pl",name:"Poland"),
        .init(id:"143453",code:"pt",name:"Portugal"),
        .init(id:"143498",code:"qa",name:"Qatar"),
        .init(id:"143582",code:"cg",name:"Republic of the Congo"),
        .init(id:"143487",code:"ro",name:"Romania"),
        .init(id:"143469",code:"ru",name:"Russia"),
        .init(id:"143621",code:"rw",name:"Rwanda"),
        .init(id:"143479",code:"sa",name:"Saudi Arabia"),
        .init(id:"143535",code:"sn",name:"Senegal"),
        .init(id:"143500",code:"rs",name:"Serbia"),
        .init(id:"143599",code:"sc",name:"Seychelles"),
        .init(id:"143600",code:"sl",name:"Sierra Leone"),
        .init(id:"143464",code:"sg",name:"Singapore"),
        .init(id:"143496",code:"sk",name:"Slovakia"),
        .init(id:"143499",code:"si",name:"Slovenia"),
        .init(id:"143601",code:"sb",name:"Solomon Islands"),
        .init(id:"143472",code:"za",name:"South Africa"),
        .init(id:"143466",code:"kr",name:"South Korea"),
        .init(id:"143454",code:"es",name:"Spain"),
        .init(id:"143486",code:"lk",name:"Sri Lanka"),
        .init(id:"143548",code:"kn",name:"St. Kitts and Nevis"),
        .init(id:"143549",code:"lc",name:"St. Lucia"),
        .init(id:"143550",code:"vc",name:"St. Vincent and the Grenadines"),
        .init(id:"143554",code:"sr",name:"Suriname"),
        .init(id:"143456",code:"se",name:"Sweden"),
        .init(id:"143459",code:"ch",name:"Switzerland"),
        .init(id:"143598",code:"st",name:"São Tomé and Príncipe"),
        .init(id:"143470",code:"tw",name:"Taiwan"),
        .init(id:"143603",code:"tj",name:"Tajikistan"),
        .init(id:"143572",code:"tz",name:"Tanzania"),
        .init(id:"143475",code:"th",name:"Thailand"),
        .init(id:"143608",code:"to",name:"Tonga"),
        .init(id:"143551",code:"tt",name:"Trinidad and Tobago"),
        .init(id:"143536",code:"tn",name:"Tunisia"),
        .init(id:"143604",code:"tm",name:"Turkmenistan"),
        .init(id:"143552",code:"tc",name:"Turks and Caicos"),
        .init(id:"143480",code:"tr",name:"Türkiye"),
        .init(id:"143481",code:"ae",name:"UAE"),
        .init(id:"143537",code:"ug",name:"Uganda"),
        .init(id:"143492",code:"ua",name:"Ukraine"),
        .init(id:"143444",code:"gb",name:"United Kingdom"),
        .init(id:"143441",code:"us",name:"United States"),
        .init(id:"143514",code:"uy",name:"Uruguay"),
        .init(id:"143566",code:"uz",name:"Uzbekistan"),
        .init(id:"143609",code:"vu",name:"Vanuatu"),
        .init(id:"143502",code:"ve",name:"Venezuela"),
        .init(id:"143471",code:"vn",name:"Vietnam"),
        .init(id:"143571",code:"ye",name:"Yemen"),
        .init(id:"143622",code:"zm",name:"Zambia"),
        .init(id:"143605",code:"zw",name:"Zimbabwe")
    ]
}

@MainActor
final class StorefrontViewModel: ObservableObject {
    @Published var selected = Storefront.all.first(where: {$0.code == "us"})!
    @Published var isRunning = false
    @Published var output = "Ready. Select a country and tap Change Storefront."
    @Published var resultIsError = false

    func changeStorefront() {
        guard !isRunning else { return }
        isRunning = true
        output = "Running: appstorectl storefront \(selected.id)"
        resultIsError = false
        let id = selected.id
        DispatchQueue.global(qos: .userInitiated).async {
            let result = Self.runCommand(countryID: id)
            DispatchQueue.main.async {
                self.output = result.text
                self.resultIsError = !result.success
                self.isRunning = false
            }
        }
    }

    nonisolated private static func runCommand(countryID: String) -> (text: String, success: Bool) {
        let path = ProcessInfo.processInfo.environment["PATH"] ?? ""
        var dirs = path.split(separator: ":").map(String.init)
        dirs += ["/var/jb/usr/bin", "/usr/local/bin", "/usr/bin", "/bin"]
        var seen = Set<String>()
        guard let executable = dirs.filter({seen.insert($0).inserted})
            .map({URL(fileURLWithPath:$0).appendingPathComponent("appstorectl").path})
            .first(where:{access($0,X_OK)==0}) else {
            return ("Cannot find appstorectl. Install it and make sure it is in PATH or /var/jb/usr/bin.", false)
        }

        var pipeFD: [Int32] = [0,0]
        guard pipe(&pipeFD) == 0 else {
            return ("pipe() failed: \(String(cString:strerror(errno)))", false)
        }

        // Darwin imports this as an optional opaque pointer.
        var actions: posix_spawn_file_actions_t? = nil
        let initStatus = posix_spawn_file_actions_init(&actions)
        guard initStatus == 0 else {
            close(pipeFD[0]); close(pipeFD[1])
            return ("posix_spawn_file_actions_init failed: \(String(cString:strerror(initStatus)))", false)
        }
        posix_spawn_file_actions_adddup2(&actions,pipeFD[1],STDOUT_FILENO)
        posix_spawn_file_actions_adddup2(&actions,pipeFD[1],STDERR_FILENO)
        posix_spawn_file_actions_addclose(&actions,pipeFD[0])
        posix_spawn_file_actions_addclose(&actions,pipeFD[1])

        var pid = pid_t()
        let args: [UnsafeMutablePointer<CChar>?] = [
            strdup("appstorectl"),strdup("storefront"),strdup(countryID),nil
        ]
        defer {
            for item in args where item != nil { free(item) }
            posix_spawn_file_actions_destroy(&actions)
        }
        let status: Int32 = args.withUnsafeBufferPointer { buffer in
            executable.withCString { p in
                posix_spawn(&pid,p,&actions,nil,buffer.baseAddress,environ)
            }
        }
        close(pipeFD[1])
        guard status == 0 else {
            close(pipeFD[0])
            return ("Could not start appstorectl: \(String(cString:strerror(status)))",false)
        }

        let handle = FileHandle(fileDescriptor:pipeFD[0],closeOnDealloc:true)
        let data = handle.readDataToEndOfFile()
        handle.closeFile()
        var waitStatus: Int32 = 0
        waitpid(pid,&waitStatus,0)
        let raw = String(data:data,encoding:.utf8)?.trimmingCharacters(in:.whitespacesAndNewlines)
        let result = (raw?.isEmpty == false) ? raw! : "Command finished without terminal output."

        // WIFEXITED and WEXITSTATUS are C macros unavailable in Swift.
        if (waitStatus & 0x7f) == 0 {
            let code = (waitStatus >> 8) & 0xff
            return ("\(result)\n\nExit code: \(code)",code == 0)
        }
        return ("\(result)\n\nProcess did not exit normally.",false)
    }
}

struct ContentView: View {
    @StateObject private var model = StorefrontViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing:20) {
                VStack(alignment:.leading,spacing:8) {
                    Text("APP STORE REGION").font(.caption.weight(.semibold)).foregroundColor(.secondary)
                    Picker("Country",selection:$model.selected) {
                        ForEach(Storefront.all) { country in Text(country.displayName).tag(country) }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth:.infinity,alignment:.leading)
                    .padding().background(Color(.secondarySystemBackground)).cornerRadius(14)
                    Text("\(Storefront.all.count) storefronts available").font(.caption2).foregroundColor(.secondary)
                }
                VStack(alignment:.leading,spacing:8) {
                    HStack {
                        Text("COMMAND").font(.caption.weight(.semibold)).foregroundColor(.secondary)
                        Spacer()
                        Text(model.isRunning ? "RUNNING":"READY").font(.caption2.weight(.bold))
                            .foregroundColor(model.isRunning ? .orange:.green)
                    }
                    Text("appstorectl storefront \(model.selected.id)")
                        .font(.system(.footnote,design:.monospaced)).textSelection(.enabled)
                        .frame(maxWidth:.infinity,alignment:.leading).padding()
                        .background(Color(.secondarySystemBackground)).cornerRadius(12)
                }
                Button(action:model.changeStorefront) {
                    HStack {
                        if model.isRunning { ProgressView().tint(.white) }
                        else { Image(systemName:"arrow.triangle.2.circlepath") }
                        Text(model.isRunning ? "Executing…":"Change Storefront").fontWeight(.semibold)
                    }
                    .frame(maxWidth:.infinity).padding(.vertical,15)
                    .foregroundColor(.white).background(model.isRunning ? Color.gray:Color.blue)
                    .cornerRadius(14)
                }.disabled(model.isRunning)
                VStack(alignment:.leading,spacing:8) {
                    Text("TERMINAL OUTPUT").font(.caption.weight(.semibold)).foregroundColor(.secondary)
                    ScrollView {
                        Text(model.output).font(.system(.footnote,design:.monospaced))
                            .foregroundColor(model.resultIsError ? .red:.primary)
                            .frame(maxWidth:.infinity,alignment:.leading).textSelection(.enabled)
                    }
                    .frame(minHeight:100,maxHeight:190).padding()
                    .background(Color(.secondarySystemBackground)).cornerRadius(12)
                }
                Spacer(minLength:0)
                Text("Requires a jailbroken device with appstorectl installed and executable.")
                    .font(.caption2).foregroundColor(.secondary).multilineTextAlignment(.center)
            }
            .padding().navigationTitle("Storefront Switcher").navigationBarTitleDisplayMode(.inline)
        }
    }
}

@main
struct StorefrontSwitcherApp: App {
    var body: some Scene { WindowGroup { ContentView() } }
}
