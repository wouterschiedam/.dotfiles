import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle } from "./utils";

const rules: KarabinerRules[] = [
    // Define the Hyper key itself
    {
        description: "Hyper Key (⌃⌥⇧⌘)",
        manipulators: [
            {
                description: "Caps Lock -> Hyper Key",
                from: {
                    key_code: "caps_lock",
                    modifiers: {
                        optional: ["any"],
                    },
                },
                to: [
                    {
                        set_variable: {
                            name: "hyper",
                            value: 1,
                        },
                    },
                ],
                to_after_key_up: [
                    {
                        set_variable: {
                            name: "hyper",
                            value: 0,
                        },
                    },
                ],
                to_if_alone: [
                    {
                        key_code: "escape",
                    },
                ],
                type: "basic",
            },
            //      {
            //        type: "basic",
            //        description: "Disable CMD + Tab to force Hyper Key usage",
            //        from: {
            //          key_code: "tab",
            //          modifiers: {
            //            mandatory: ["left_command"],
            //          },
            //        },
            //        to: [
            //          {
            //            key_code: "tab",
            //          },
            //        ],
            //      },
        ],
    },
    ...createHyperSubLayers({
        spacebar: open(
            "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
        ),
        // b = "B"rowse
        b: {
            l: open("https://localhost:141"),
            r: open("https://reddit.com"),
            g: open("https://gitlab.com"),
        },
        // o = "Open" applications
        o: {
            s: app("Safari"),
            t: app("Alacritty"),
            d: app("Tableplus"),
            m: app("Spotify"),
            v: app("Slack"),
            l: app("Postman"),
            c: app("ChatGPT"),
            q: app("Obsidian")
        },

        // v = "moVe" which isn't "m" because we want it to be on the left hand
        // so that hjkl work like they do in vim
        v: {
            h: {
                to: [{ key_code: "left_arrow" }],
            },
            j: {
                to: [{ key_code: "down_arrow" }],
            },
            k: {
                to: [{ key_code: "up_arrow" }],
            },
            l: {
                to: [{ key_code: "right_arrow" }],
            },
        },
        f: {
            1: {
                to: [{ key_code: "f1" }],
            },
            2: {
                to: [{ key_code: "f2" }],
            },
            3: {
                to: [{ key_code: "f3" }],
            },
            4: {
                to: [{ key_code: "f4" }],
            },
            5: {
                to: [{ key_code: "f5" }],
            },
            6: {
                to: [{ key_code: "f6" }],
            },
            r: {
                to: [{ key_code: "f6" }],
            },
        },

        // Add numbers
        'left_command': {
            a: {
                to: [{ key_code: "1" }],
            },
            s: {
                to: [{ key_code: "2" }],
            },
            d: {
                to: [{ key_code: "3" }],
            },
            f: {
                to: [{ key_code: "4" }],
            },
            g: {
                to: [{ key_code: "5" }],
            },
            h: {
                to: [{ key_code: "6" }],
            },
            j: {
                to: [{ key_code: "7" }],
            },
            k: {
                to: [{ key_code: "8" }],
            },
            l: {
                to: [{ key_code: "9" }],
            },
            'semicolon': {
                to: [{ key_code: "0" }],
            },
        },
        // Add special characters
        'right_command': {
            a: {
                to: [{ key_code: "1" }],
            },
            s: {
                to: [{ key_code: "2" }],
            },
            d: {
                to: [{ key_code: "3" }],
            },
            f: {
                to: [{ key_code: "4" }],
            },
            g: {
                to: [{ key_code: "5" }],
            },
            h: {
                to: [{ key_code: "6" }],
            },
            j: {
                to: [{ key_code: "7" }],
            },
            k: {
                to: [{ key_code: "8" }],
            },
            l: {
                to: [{ key_code: "9" }],
            },
            'semicolon': {
                to: [{ key_code: "0" }],
            },
        },

    }),
];

fs.writeFileSync(
    "karabiner.json",
    JSON.stringify(
        {
            global: {
                show_in_menu_bar: false,
            },
            profiles: [
                {
                    name: "Default",
                    complex_modifications: {
                        rules,
                    },
                },
            ],
        },
        null,
        2
    )
);
