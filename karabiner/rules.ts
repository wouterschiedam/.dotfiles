import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle } from "./utils";

const rules: KarabinerRules[] = [
    // Define the Hyper key itself
    {
        description: "Caps Lock -> Escape when tapped, Control when held",
        manipulators: [
            {
                description: "Caps Lock -> Escape when tapped, Control when held",
                from: {
                    key_code: "caps_lock",
                    modifiers: {
                        optional: ["any"],
                    },
                },
                to: [
                    {
                        key_code: "left_control",
                    },
                ],
                to_if_alone: [
                    {
                        key_code: "escape",
                    },
                ],
                type: "basic",
            },
        ],
    },
    ...createHyperSubLayers({
        // o = "Open" applications
        o: {
            s: app("Safari"),
            t: app("Alacritty"),
            d: app("Tableplus"),
            m: app("Spotify"),
            v: app("Slack"),
            n: app("Youtube Music"),
            i: app("Notion")
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
                        parameters: {
                            basic: {
                                to_if_alone_timeout_milliseconds: 100
                            },
                        }
                    },
                },
            ],
        },
        null,
        2
    )
);
