import SwiftUI
import Darwin
import Foundation

struct Storefront: Identifiable, Hashable {
    let id: String
    let name: String
    let flag: String

    static let all: [Storefront] = [
        .init(id: "143441", name: "United States", flag: "🇺🇸"),
        .init(id: "143444", name: "United Kingdom", flag: "🇬🇧"),
        .init(id: "143462", name: "Japan", flag: "🇯🇵"),
        .init(id: "143469", name: "Russia", flag: "🇷🇺")
    ]

    var displayName: String { "\(flag)  \(name)" }
}

@MainActor
final class StorefrontViewModel: ObservableObject {
    @Published var selected = Storefront.all[0]
    @Published var isRunning = false
    @Published var output = "Ready. Select a country and tap Change Storefront."
    @Published var resultIsError = false

    private let executable = "/var/jb/usr/bin/appstorectl"

    func changeStorefront() {
        guard !isRunning else { return }
        isRunning = true
        output = "Running: appstorectl storefront \(selected.id)"
        resultIsError = false

        let countryID = selected.id
        let executablePath = executable

        DispatchQueue.global(qos: .userInitiated).async {
            let result = Self.runCommand(executable: executablePath, countryID: countryID)
            DispatchQueue.main.async {
                self.output = result.text
                self.resultIsError = !result.success
                self.isRunning = false
            }
        }
    }

    nonisolated private static func runCommand(executable: String, countryID: String) -> (text: String, success: Bool) {
        guard access(executable, X_OK) == 0 else {
            return ("Cannot execute \(executable)\nCheck that appstorectl is installed at this path and is executable.", false)
        }

        var pipeFD: [Int32] = [0, 0]
        guard pipe(&pipeFD) == 0 else {
            return ("pipe() failed: \(String(cString: strerror(errno)))", false)
        }

        // On Apple platforms this opaque POSIX type is represented as an optional.
        var actions: posix_spawn_file_actions_t? = nil
        let initStatus = posix_spawn_file_actions_init(&actions)
        guard initStatus == 0 else {
            close(pipeFD[0])
            close(pipeFD[1])
            return ("Could not initialize process actions: \\(String(cString: strerror(initStatus)))", false)
        }

        posix_spawn_file_actions_adddup2(&actions, pipeFD[1], STDOUT_FILENO)
        posix_spawn_file_actions_adddup2(&actions, pipeFD[1], STDERR_FILENO)
        posix_spawn_file_actions_addclose(&actions, pipeFD[0])
        posix_spawn_file_actions_addclose(&actions, pipeFD[1])

        var pid = pid_t()
        let args: [UnsafeMutablePointer<CChar>?] = [
            strdup(executable),
            strdup("storefront"),
            strdup(countryID),
            nil
        ]
        defer {
            for item in args where item != nil { free(item) }
            posix_spawn_file_actions_destroy(&actions)
        }

        let spawnStatus: Int32 = args.withUnsafeBufferPointer { buffer in
            executable.withCString { path in
                posix_spawn(&pid, path, &actions, nil, buffer.baseAddress, environ)
            }
        }

        close(pipeFD[1])

        if spawnStatus != 0 {
            close(pipeFD[0])
            return ("Could not start appstorectl: \(String(cString: strerror(spawnStatus))) (errno \(spawnStatus))", false)
        }

        let outputHandle = FileHandle(fileDescriptor: pipeFD[0], closeOnDealloc: true)
        let data = outputHandle.readDataToEndOfFile()
        outputHandle.closeFile()

        var waitStatus: Int32 = 0
        waitpid(pid, &waitStatus, 0)

        let text = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let outputText = (text?.isEmpty == false) ? text! : "Command finished without terminal output."

        // POSIX wait status decoding without the C macros unavailable to Swift.
        let exitedNormally = (waitStatus & 0x7f) == 0
        if exitedNormally {
            let code = (waitStatus >> 8) & 0xff
            return ("\(outputText)\n\nExit code: \(code)", code == 0)
        } else {
            return ("\(outputText)\n\nProcess did not exit normally.", false)
        }
    }
}

struct ContentView: View {
    @StateObject private var model = StorefrontViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("APP STORE REGION")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)

                    Picker("Country", selection: $model.selected) {
                        ForEach(Storefront.all) { country in
                            Text(country.displayName).tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("COMMAND")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("READY")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.green)
                    }
                    Text("/var/jb/usr/bin/appstorectl storefront \(model.selected.id)")
                        .font(.system(.footnote, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }

                Button(action: model.changeStorefront) {
                    HStack {
                        if model.isRunning {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        Text(model.isRunning ? "Executing…" : "Change Storefront")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                    .background(model.isRunning ? Color.gray : Color.blue)
                    .cornerRadius(14)
                }
                .disabled(model.isRunning)

                VStack(alignment: .leading, spacing: 8) {
                    Text("TERMINAL OUTPUT")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                    ScrollView {
                        Text(model.output)
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundColor(model.resultIsError ? .red : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                    .frame(minHeight: 100, maxHeight: 190)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }

                Spacer(minLength: 0)
                Text("Requires a jailbroken device with appstorectl installed at the rootless path.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Storefront Switcher")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

@main
struct StorefrontSwitcherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
