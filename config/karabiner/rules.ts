import fs from "fs";
import { KarabinerRules } from "./types";
import { app, createHyperSubLayers, open } from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: { key_code: "caps_lock" },
        to: [{
          key_code: "left_shift",
          modifiers: ["left_command", "left_control", "left_option"],
        }],
        to_if_alone: [{ key_code: "escape" }],
        type: "basic",
      },
    ],
  },
  ...createHyperSubLayers({
    c: app("Cursor"),
    v: app("Visual Studio Code"),
    f: app("Arc"),
    a: app("Arc"),
    t: app("Ghostty"),
    n: app("Notion"),
    spacebar: { to: [{ key_code: "spacebar", modifiers: ["right_command"] }]}, // Alfred shortcut
    m: { to: [{ key_code: "h", modifiers: ["right_control"] }]}, // Homerow search
    j: { to: [{ key_code: "s", modifiers: ["right_control"] }]}, // Homerow scrollf
    // t: { to: [{ key_code: "t", modifiers: ["right_command"] }]},
    open_bracket: { to: [{ key_code: "open_bracket", modifiers: ["right_shift", "right_command"] }]},
    close_bracket: { to: [{ key_code: "close_bracket", modifiers: ["right_shift", "right_command"] }]},
    1: { to: [{ key_code: "1", modifiers: ["right_command"] }]},
    2: { to: [{ key_code: "2", modifiers: ["right_command"] }]},
    3: { to: [{ key_code: "3", modifiers: ["right_command"] }]},
    4: { to: [{ key_code: "4", modifiers: ["right_command"] }]},
    5: { to: [{ key_code: "5", modifiers: ["right_command"] }]},
    6: { to: [{ key_code: "6", modifiers: ["right_command"] }]},
    7: { to: [{ key_code: "7", modifiers: ["right_command"] }]},
    8: { to: [{ key_code: "8", modifiers: ["right_command"] }]},
    // o = "Open" applications
    o: {
      a: app("Anki"),
      f: app("Finder"),
      v: app("Cursor"),
      n: app("Notion"),
      k: app("Slack"),
      t: app("Ghostty"),
      c: app("Google Chrome"),
      i: app("IINA"),
      s: app("Spotify"),
      p: app("System Preferences"),
      m: app("Messages"),
      1: app("1Password"),
      j: open("https://beta.jot.app"),
      z: app("zoom.us"),
    },

    // s = "System"
    s: {
      u: { to: [{ key_code: "volume_increment" }]},
      j: { to: [{ key_code: "volume_decrement" }]},
      i: { to: [{ key_code: "display_brightness_increment" }]},
      k: { to: [{ key_code: "display_brightness_decrement" }]},
      p: { to: [{ key_code: "play_or_pause" }]}, // play / pause
      l: { to: [{ key_code: "rewind" }]}, // previous track
      semicolon: { to: [{ key_code: "fastforward" }]}, // next track
      v: { to: [{ key_code: "mission_control" }]}, // open mission control (view)
      m: { to: [{ key_code: "mute" }]}, // mute volume
      d: { to: [{ key_code: "launchpad" }]}, // open drawer / launchpad
      y: { to: [{
            key_code: "q",
            modifiers: ["right_control", "right_command"],
      }]}, // lock mac
      e: { to: [{
            key_code: "spacebar",
            modifiers: ["right_control", "right_command"],
      }]}, // open emoji / unicode picker
    },

    // w = "Window" via rectangle.app
    w: {
      h: {
        description: "Window: Hide",
        to: [{
          key_code: "h",
          modifiers: ["right_command"],
        }],
      },
      j: {
        description: "Window: Move left in thirds",
        to: [{
          key_code: "g",
          modifiers: ["left_control", "left_option"],
        }],
      },
      k: {
        description: "Window: Move right in thirds",
        to: [{
          key_code: "d",
          modifiers: ["right_option", "right_control"],
        }],
      },
      l: {
        description: "Window: Left Half",
        to: [{
          key_code: "left_arrow",
          modifiers: ["right_option", "right_control"],
        }],
      },
      semicolon: {
        description: "Window: Right Half",
        to: [{
          key_code: "right_arrow",
          modifiers: ["right_option", "right_control"],
        }],
      },
      g: {
        description: "Window: Left 2/3rds",
        to: [{
          key_code: "t",
          modifiers: ["right_option", "right_control"],
        }],
      },
      // h: {
      //   description: "Window: Right 2/3rds",
      //   to: [{
      //     key_code: "e",
      //     modifiers: ["right_option", "right_control"],
      //   }],
      // },
      f: {
        description: "Window: Full Screen",
        to: [{
          key_code: "f",
          modifiers: ["right_option", "right_control"],
        }],
      },
      u: {
        description: "Window: Previous Tab",
        to: [{
          key_code: "tab",
          modifiers: ["right_control", "right_shift"],
        }],
      },
      i: {
        description: "Window: Next Tab",
        to: [{
          key_code: "tab",
          modifiers: ["right_control"],
        }],
      },
      n: {
        description: "Window: Next Window",
        to: [{
          key_code: "grave_accent_and_tilde",
          modifiers: ["right_command"],
        }],
      },
      b: {
        description: "Window: Back",
        to: [{
          key_code: "open_bracket",
          modifiers: ["right_command"],
        }],
      },
      m: {
        description: "Window: Forward",
        to: [{
          key_code: "close_bracket",
          modifiers: ["right_command"],
        }],
      },
    },
  }),
];

const output =  {
  global: { show_in_menu_bar: false },
  profiles: [{
    name: "Default",
    complex_modifications: {
      rules,
    },
  }],
}

console.log(JSON.stringify(output, null, 2))
fs.writeFileSync(new URL("./karabiner.json", import.meta.url), JSON.stringify(output, null, 2))