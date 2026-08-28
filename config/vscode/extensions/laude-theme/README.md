# Laude

Laude is the paper-and-ink sister to
[Vigil](https://github.com/Mats-Dodd/vigil), built for VS Code and Zed. It
uses a warm engineering-paper foundation, charcoal text, burnt-orange
navigation, teal strings, plum control flow, and brick diagnostics. The scope
map and flat editor shell stay in lockstep with Vigil.

```text
background  #F2F2EC    foreground  #33332F
surface     #EBEBE5    bright      #292925
border      #DCDCD6    muted       #61615B
selection   #D3D3CD    comment     #A8A8A3
orange      #9C5E28    mint        #097D68
pink        #9B53A0    red         #BE454A
```

Laude is light-only. Pure white and pure black are deliberately absent. Dark
Vigil is the terminal; Laude is the printout.

## Install

### VS Code

Build a VSIX and install it with any VS Code-compatible editor:

```sh
npm test
npm run package:vscode
code --install-extension laude-theme-0.1.0.vsix
```

For extension development, open this repository in VS Code and press `F5`.
Choose **Laude** from `Preferences: Color Theme` in the Extension Development
Host.

### Zed

Open `zed: extensions`, choose **Install Dev Extension**, and select this
repository. Then select **Laude** with `theme selector: toggle`.

For a file-only local install, copy `themes/laude.json` to
`~/.config/zed/themes/laude.json` and restart Zed.

## Development

The two editor formats are intentionally authored separately because VS Code
uses TextMate plus semantic tokens while Zed uses native syntax captures. They
share exact colors through symbolic references to `src/palette.json`:

```json
{
  "editor.background": "$background",
  "editor.foreground": "$foreground",
  "editorCursor.foreground": "$orange"
}
```

Build and validate both distributables without installing dependencies:

```sh
npm test
```

`scripts/build.mjs` resolves palette references into:

- `vscode/laude-color-theme.json`
- `themes/laude.json`

`scripts/check.mjs` enforces the palette, editor parity, manifest versions,
coverage floors, attribution, fixtures, and the no-pure-white-or-black rule.

When tuning syntax, inspect the files in `fixtures/`. In VS Code, use
`Developer: Inspect Editor Tokens and Scopes` to distinguish TextMate scopes
from semantic tokens.

## Design contract

- Orange: focus, navigation, functions, types, constants, tags, and warnings.
- Mint: strings, additions, success, and information.
- Pink: keywords, operators, preprocessor forms, and conflicts.
- Red: errors and deletions.
- Foreground: variables, properties, parameters, and ordinary text.
- Muted: punctuation, hints, secondary interface text, and inactive controls.
- Comment: comments, disabled controls, hidden files, and predictive text.

Fonts are editor settings rather than theme properties. Laude pairs with
Berkeley Mono, but does not require or distribute it.

## Lineage

Laude ports Vigil's semantic assignments and editor coverage to the light
palette first prototyped on [chezdodds.dev](https://chezdodds.dev). Vigil
descends from Vesper++ Lighter and Vesper. See
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for attribution.

## License

MIT © 2026 Matthew Dodd
