# MacPackMate über Homebrew installieren

*Install MacPackMate with Homebrew – English summary at the end.*

## Für Nutzer

```sh
brew tap flo-murnig/tap
brew install --cask macpackmate
```

Das installiert `MacPackMate.app` nach `/Applications` und verlinkt das Befehlszeilen-Tool `macpackmate` in den PATH.

```sh
brew upgrade --cask macpackmate     # Update (die App aktualisiert sich auch selbst über Sparkle)
brew uninstall --cask macpackmate   # Entfernen
brew uninstall --zap --cask macpackmate   # inkl. Einstellungen und Caches
```

Voraussetzung: macOS 14 Sonoma oder neuer. Die App ist mit Developer ID signiert und von Apple notarisiert. Sie ist 14 Tage voll nutzbar, danach braucht Installieren/Aktualisieren/Entfernen eine Lizenz (siehe [README](../README.md)).

---

## Für den Betreiber: Cask veröffentlichen

MacPackMate ist keine Formula (kein Quellcode-Build), sondern ein **Cask**: Homebrew lädt das signierte DMG von `dynamo.at`.

### Weg A – eigenes Tap (sofort, empfohlen für den Start)

1. Auf GitHub ein Repository **`flo-murnig/homebrew-tap`** anlegen (der Name muss mit `homebrew-` beginnen).
2. Darin die Datei `Casks/macpackmate.rb` ablegen (Vorlage unten).
3. Fertig – Nutzer können sofort `brew tap flo-murnig/tap && brew install --cask macpackmate` ausführen.

### Weg B – offizielles `homebrew/cask` (`brew install --cask macpackmate` ohne Tap)

Voraussetzungen von Homebrew:

- Signiert und notarisiert ✓ (`make dist`).
- Stabile, versionierte Download-URL (kein „latest“-Link).
- **Bekanntheit:** Das GitHub-Repository sollte mindestens 75 Sterne, 30 Forks oder 30 Beobachter haben (Selbstveröffentlichung wird sonst abgelehnt). Das Repo muss dafür öffentlich sein.
- Eine App mit Testzeit/Lizenz ist erlaubt, wenn sie nach dem Download startet.

Ablauf:

```sh
brew tap --force homebrew/cask          # nur nötig, wenn noch nicht vorhanden
brew audit --new --cask macpackmate     # Prüfung gegen die Homebrew-Regeln
brew style --fix macpackmate
brew install --cask ./macpackmate.rb    # lokal testen
brew uninstall --zap --cask macpackmate # zap-Liste testen
```

Dann einen Pull Request gegen [Homebrew/homebrew-cask](https://github.com/Homebrew/homebrew-cask) mit `Casks/m/macpackmate.rb` stellen (Titel: `macpackmate 0.37.0 (new cask)`).

### Vorlage `Casks/macpackmate.rb`

```ruby
cask "macpackmate" do
  version "0.37.0"
  sha256 "HIER_SHA256_DES_DMG"

  url "https://dynamo.at/macpackmate/MacPackMate-#{version}.dmg"
  name "MacPackMate"
  desc "Package manager hub: Homebrew, npm, pip, Cargo, Nix and more in one list"
  homepage "https://dynamo.at/macpackmate/"

  livecheck do
    url "https://dynamo.at/macpackmate/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "MacPackMate.app"
  binary "#{appdir}/MacPackMate.app/Contents/Helpers/macpackmate"

  zap trash: [
    "~/Library/Application Support/MacPackMate",
    "~/Library/Caches/at.dynamo.MacPackMate",
    "~/Library/Preferences/at.dynamo.MacPackMate.plist",
    "~/Library/Saved Application State/at.dynamo.MacPackMate.savedState",
  ]
end
```

Die `zap`-Pfade vor dem Veröffentlichen mit `ls ~/Library/*/ | grep -i macpackmate` gegenprüfen.

### SHA-256 ermitteln

```sh
shasum -a 256 ~/Library/Caches/MacPackMate/release/updates/MacPackMate-0.37.0.dmg
```

### Bei jeder neuen Version

1. `make dist` und die Dateien aus `updates/` auf `dynamo.at/macpackmate/` hochladen (DMG + `appcast.xml`).
2. Im Cask `version` und `sha256` ändern.
3. Tap: committen und pushen. Offizielles Cask: macht der Bot (`BrewTestBot`) automatisch über `livecheck`, sobald der Appcast die neue Version zeigt.

---

## English summary

```sh
brew tap flo-murnig/tap
brew install --cask macpackmate
```

Installs the notarized app plus the `macpackmate` command-line tool. Maintainers: publish the cask in your own tap (`flo-murnig/homebrew-tap`, immediately available) or submit it to `Homebrew/homebrew-cask` once the repository meets Homebrew's notability threshold (75 stars / 30 forks / 30 watchers). Template and update steps are above.