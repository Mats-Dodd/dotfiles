# Vigil

Vigil is a watchful, Vesper-descended dark theme for VS Code and Zed. It uses
a near-black neutral foundation, warm orange navigation, mint strings, pink
control flow, and red diagnostics without turning ordinary code into confetti.

```text
background  #161616    foreground  #D6D6D0
surface     #1C1C1C    bright      #E3E3DD
border      #282828    muted       #A0A0A0
selection   #383838    comment     #595959
orange      #FFC799    mint        #99FFE4
pink        #FBADFF    red         #FF8080
```

Vigil is dark-only. Pure white is deliberately absent.

## Install

### VS Code

Build a VSIX and install it with any VS Code-compatible editor:

```sh
npm test
npm run package:vscode
code --install-extension vigil-theme-0.1.1.vsix
```

For extension development, open this repository in VS Code and press `F5`.
Choose **Vigil** from `Preferences: Color Theme` in the Extension Development
Host.

### Zed

Open `zed: extensions`, choose **Install Dev Extension**, and select this
repository. Then select **Vigil** with `theme selector: toggle`.

For a file-only local install, copy `themes/vigil.json` to
`~/.config/zed/themes/vigil.json` and restart Zed.

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

- `vscode/vigil-color-theme.json`
- `themes/vigil.json`

`scripts/check.mjs` enforces the palette, editor parity, manifest versions,
coverage floors, attribution, fixtures, and the no-pure-white rule.

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

Fonts are editor settings rather than theme properties. Vigil pairs with
Berkeley Mono, but does not require or distribute it.

## Lineage

Vigil began as a personal adaptation of Vesper++ Lighter and Vesper. See
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for attribution.

## License

MIT © 2026 Matthew Dodd
