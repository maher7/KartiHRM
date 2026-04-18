# Karti HRM — Signing & Store Recovery Info

> **Purpose:** single source of truth for everything needed to rebuild and re-publish the
> Karti HRM mobile app to Google Play and the Apple App Store. **Losing this info means
> losing the ability to push updates** — Play Store rejects APKs/AABs signed with a
> different keystore, and App Store Connect requires the original team/bundle ID.

---

## 1. App identity

| Item            | Value                                |
|-----------------|--------------------------------------|
| Flutter project | `HRM-app-Maher-saas-hrm-main/`       |
| Flutter name    | `onesthrm`                           |
| Current version | `1.3.0+8` (see `pubspec.yaml`)       |
| Android pkg     | `online.karti.hrm`                   |
| iOS bundle ID   | `online.karti.hrm`                   |
| iOS test bundle | `com.hour.onestHrm.RunnerTests`      |
| iOS dev team    | `6N22C6SRVK`                         |

---

## 2. Android signing — Google Play

### Keystore file
- **Path in repo:** `HRM-app-Maher-saas-hrm-main/android/app/KartiHRM.jks`
- **Type:** JKS
- **Tracked in git:** yes (committed binary)
- **Wired into build via:** `android/key.properties` (also tracked in git)

### Credentials (`android/key.properties`)
```properties
storePassword=KartiHRM
keyPassword=KartiHRM
keyAlias=KartiHRM
storeFile=KartiHRM.jks
```

### How signing works
`android/app/build.gradle` reads `../key.properties` and applies the values to the
`release` signing config. As long as both `KartiHRM.jks` and `key.properties` exist at
build time, `flutter build appbundle --release` produces an AAB that Play Store accepts
as an update to the existing listing.

### Verifying the keystore (recovery sanity check)
From `HRM-app-Maher-saas-hrm-main/android/app/`:
```bash
keytool -list -v -keystore KartiHRM.jks -storepass KartiHRM -alias KartiHRM
```
The SHA-1 / SHA-256 fingerprints printed must match the ones registered in
**Play Console → Setup → App integrity → App signing key certificate**. If they don't
match, this is the wrong keystore — DO NOT upload, you will be locked out.

### Building a signed release
```bash
cd HRM-app-Maher-saas-hrm-main
flutter clean
flutter pub get
flutter build appbundle --release
# output: build/app/outputs/bundle/release/app-release.aab
```

---

## 3. Shorebird OTA updates

- **Config:** `HRM-app-Maher-saas-hrm-main/shorebird.yaml`
- **App ID:** `6cf6f0b8-e3fd-42b5-b325-a591ba70119c` (public, safe to commit)
- **Auth:** Shorebird CLI uses your personal Shorebird account credentials, NOT stored
  in the repo. Run `shorebird login` on a fresh machine.

### Patch vs. full release rule of thumb
- **Dart-only changes** (UI, business logic, strings) → `shorebird patch android`
  (OTA, no store review)
- **Native changes** (Android manifest, iOS plist, dependencies, plugin updates,
  Flutter SDK upgrade) → full store release required (`flutter build appbundle`,
  upload to Play Console)

If unsure, ask Claude — there is a memory rule to flag whether a change needs a store
release vs. a Shorebird patch.

---

## 4. iOS — App Store Connect

| Item              | Value                       |
|-------------------|-----------------------------|
| Bundle ID         | `online.karti.hrm`          |
| Apple team ID     | `6N22C6SRVK`                |
| Code sign style   | Automatic (Xcode-managed)   |
| Code sign identity| `iPhone Developer`          |

### What's NOT in this repo (and where to find it)
iOS signing certificates and provisioning profiles live in:
- The Apple Developer account that owns team `6N22C6SRVK`
- The Mac keychain on the build machine (after `xcodebuild` or Xcode pulls them
  via Automatic Signing)
- Optionally: an `ExportOptions.plist` on the build machine

**To recover iOS publishing rights you need:**
1. Login to the Apple Developer account that owns team `6N22C6SRVK`
2. App Store Connect access for the `online.karti.hrm` listing
3. A Mac with Xcode signed in to that Apple ID

There is no "keystore equivalent" file to back up — Apple manages this server-side.
Do NOT lose the Apple ID credentials and 2FA device.

### Building an iOS release
```bash
cd HRM-app-Maher-saas-hrm-main
flutter build ipa --release
# then open Xcode → Window → Organizer → Distribute App
```

---

## 5. Disaster recovery checklist

If you are reading this on a fresh machine after losing everything:

1. **Clone the repo.** Both `KartiHRM.jks` and `key.properties` come down with it.
2. **Verify the keystore fingerprint** matches Play Console (see §2).
3. **Install Flutter** matching the version pinned in `pubspec.yaml` and tooling
   referenced in `android/app/build.gradle`.
4. **Run `flutter pub get`** in `HRM-app-Maher-saas-hrm-main/`.
5. **Build & upload AAB** for Android (§2).
6. For iOS: log into the Apple Developer account, install Xcode, build IPA.
7. For OTA-only Dart fixes: `shorebird login` then `shorebird patch android`.

---

## 6. Security warning — read this

Both `KartiHRM.jks` and `key.properties` are committed to this repository. Anyone with
read access to the repo can sign apps as `online.karti.hrm` and impersonate you on
Play Store. This is convenient for solo development but **dangerous for shared repos**.

### If you ever need to harden this:
1. Generate a NEW upload keystore (`keytool -genkeypair ...`).
2. In Play Console → Setup → App integrity, register the new key as a new
   **upload key** (Google Play App Signing keeps managing the actual app signing key,
   so users still get seamless updates).
3. Move the new keystore + passwords OUT of git into a secrets manager (1Password,
   Bitwarden, GitHub Actions secrets, etc.).
4. Add `key.properties` and `*.jks` to `.gitignore`.
5. Rotate the old keystore's secrets out of git history with
   `git filter-repo` if the repo is public.

For now, this file is just a recovery cheat-sheet — the secrets it references are
already in the repo, so committing this doc adds documentation, not new exposure.
