from pathlib import Path

swift = Path("StorefrontSwitcher/ContentView.swift")
plist = Path("StorefrontSwitcher/Info.plist")
s = swift.read_text(encoding="utf-8")

old_footer = '''                Text("Requires a jailbroken device with appstorectl installed and executable.")
                    .font(.caption2).foregroundColor(.secondary).multilineTextAlignment(.center)'''
new_footer = '''                Text("Build 2 • TrollStore entitlement test")
                    .font(.caption2).foregroundColor(.secondary)
                Text("Requires a jailbroken device with appstorectl installed and executable.")
                    .font(.caption2).foregroundColor(.secondary).multilineTextAlignment(.center)'''
if old_footer not in s:
    raise SystemExit("Footer block not found; no changes applied.")
s = s.replace(old_footer, new_footer, 1)

old_lookup = '''            return ("Cannot find appstorectl. Install it and make sure it is in PATH or /var/jb/usr/bin.", false)'''
new_lookup = '''            let candidate = "/var/jb/usr/bin/appstorectl"
            let fileExists = access(candidate, F_OK) == 0
            let executable = access(candidate, X_OK) == 0
            return ("Build 2 diagnostic\\\\nPath: \\\\(candidate)\\\\nExists: \\\\(fileExists)\\\\nExecutable: \\\\(executable)\\\\nPATH: \\\\(path)", false)'''
if old_lookup not in s:
    raise SystemExit("appstorectl lookup block not found; no changes applied.")
s = s.replace(old_lookup, new_lookup, 1)

old_spawn = '''            return ("Could not start appstorectl: \\\\(String(cString:strerror(status)))",false)'''
new_spawn = '''            return ("Build 2\\\\nExecutable: \\\\(executable)\\\\nCould not start appstorectl: \\\\(String(cString:strerror(status))) (errno \\\\(status))",false)'''
if old_spawn not in s:
    raise SystemExit("posix_spawn error block not found; no changes applied.")
s = s.replace(old_spawn, new_spawn, 1)

swift.write_text(s, encoding="utf-8")
p = plist.read_text(encoding="utf-8")
p = p.replace("<string>1.0</string>", "<string>1.1</string>", 1)
p = p.replace("<key>CFBundleVersion</key>\n    <string>1</string>",
              "<key>CFBundleVersion</key>\n    <string>2</string>", 1)
plist.write_text(p, encoding="utf-8")
print("Updated ContentView.swift and Info.plist")
