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
        .init(id:"143447",code:"fi",name:"Finland"),
        .init(id:"143441",code:"us",name:"United States"),
        .init(id:"143444",code:"gb",name:"United Kingdom"),
        .init(id:"143443",code:"de",name:"Germany"),
        .init(id:"143442",code:"fr",name:"France"),
        .init(id:"143450",code:"it",name:"Italy"),
        .init(id:"143454",code:"es",name:"Spain"),
        .init(id:"143452",code:"nl",name:"Netherlands"),
        .init(id:"143456",code:"se",name:"Sweden"),
        .init(id:"143457",code:"no",name:"Norway"),
        .init(id:"143458",code:"dk",name:"Denmark"),
        .init(id:"143459",code:"ch",name:"Switzerland"),
        .init(id:"143445",code:"at",name:"Austria"),
        .init(id:"143446",code:"be",name:"Belgium"),
        .init(id:"143453",code:"pt",name:"Portugal"),
        .init(id:"143478",code:"pl",name:"Poland"),
        .init(id:"143487",code:"ro",name:"Romania"),
        .init(id:"143492",code:"ua",name:"Ukraine"),
        .init(id:"143469",code:"ru",name:"Russia"),
        .init(id:"143480",code:"tr",name:"Türkiye"),
        .init(id:"143462",code:"jp",name:"Japan"),
        .init(id:"143465",code:"cn",name:"China"),
        .init(id:"143470",code:"tw",name:"Taiwan"),
        .init(id:"143466",code:"kr",name:"South Korea"),
        .init(id:"143460",code:"au",name:"Australia"),
        .init(id:"143461",code:"nz",name:"New Zealand"),
        .init(id:"143455",code:"ca",name:"Canada"),
        .init(id:"143503",code:"br",name:"Brazil"),
        .init(id:"143468",code:"mx",name:"Mexico"),
        .init(id:"143501",code:"co",name:"Colombia"),
        .init(id:"143467",code:"in",name:"India"),
        .init(id:"143476",code:"id",name:"Indonesia"),
        .init(id:"143473",code:"my",name:"Malaysia"),
        .init(id:"143464",code:"sg",name:"Singapore"),
        .init(id:"143475",code:"th",name:"Thailand"),
        .init(id:"143474",code:"ph",name:"Philippines"),
        .init(id:"143471",code:"vn",name:"Vietnam"),
        .init(id:"143479",code:"sa",name:"Saudi Arabia"),
        .init(id:"143481",code:"ae",name:"UAE"),
        .init(id:"143491",code:"il",name:"Israel"),
        .init(id:"143498",code:"qa",name:"Qatar"),
        .init(id:"143493",code:"kw",name:"Kuwait"),
        .init(id:"143516",code:"eg",name:"Egypt"),
        .init(id:"143472",code:"za",name:"South Africa"),
        .init(id:"143505",code:"ar",name:"Argentina"),
        .init(id:"143483",code:"cl",name:"Chile"),
        .init(id:"143507",code:"pe",name:"Peru"),
        .init(id:"143504",code:"gt",name:"Guatemala"),
        .init(id:"143494",code:"hr",name:"Croatia"),
        .init(id:"143489",code:"cz",name:"Czechia"),
        .init(id:"143482",code:"hu",name:"Hungary"),
        .init(id:"143519",code:"lv",name:"Latvia"),
        .init(id:"143520",code:"lt",name:"Lithuania"),
        .init(id:"143518",code:"ee",name:"Estonia"),
        .init(id:"143500",code:"rs",name:"Serbia"),
        .init(id:"143524",code:"am",name:"Armenia"),
        .init(id:"143517",code:"kz",name:"Kazakhstan"),
        .init(id:"143566",code:"uz",name:"Uzbekistan"),
        .init(id:"143624",code:"xk",name:"Kosovo")
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
