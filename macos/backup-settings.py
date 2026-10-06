#!/usr/bin/env python3
"""Capture portable settings for the apps listed in macos/Brewfile."""

import json
import plistlib
from pathlib import Path


HOME = Path.home()
DEST = Path(__file__).resolve().parent / "settings"
PREFS = HOME / "Library" / "Preferences"


def read_plist(name: str) -> dict:
    path = PREFS / name
    with path.open("rb") as source:
        return plistlib.load(source)


def write_plist(name: str, values: dict) -> None:
    path = DEST / name
    with path.open("wb") as target:
        plistlib.dump(values, target, fmt=plistlib.FMT_XML, sort_keys=True)


def main() -> None:
    DEST.mkdir(parents=True, exist_ok=True)

    # Stats' remote_id is machine-specific. Keep only visible app preferences.
    stats_keys = {
        "CPU_state", "CPU_updateInterval", "CPU_updateTopInterval", "CPU_mini_label",
        "GPU_state", "RAM_state", "RAM_updateInterval", "RAM_updateTopInterval",
        "RAM_mini_label", "Disk_state", "Network_state", "Battery_state",
        "Bluetooth_state", "Sensors_state", "Clock_state", "CPU_widget", "RAM_widget",
        "LaunchAtLoginNext",
    }
    write_plist("stats.plist", {k: v for k, v in read_plist("eu.exelban.Stats.plist").items() if k in stats_keys})

    # macOS privacy grants and update history are specific to this installation.
    scroll_keys = {
        "InvertScrollingOn", "ReverseX", "ReverseY", "ReverseTrackpad", "ReverseMouse",
        "HideIcon", "StartAtLogin",
    }
    write_plist(
        "scroll-reverser.plist",
        {k: v for k, v in read_plist("com.pilotmoon.scroll-reverser.plist").items() if k in scroll_keys},
    )

    # Rectangle's preference domain contains user shortcuts and window behavior;
    # strip only install/update and first-run bookkeeping.
    rectangle = read_plist("com.knollsoft.Rectangle.plist")
    excluded_rectangle_keys = {
        "lastVersion", "installVersion", "SUHasLaunchedBefore", "wasWelcomeDisplayed",
        "internalTilingNotified",
    }
    write_plist("rectangle.plist", {k: v for k, v in rectangle.items() if k not in excluded_rectangle_keys})

    # Stretchly's JSON holds its preferences. Drop this Mac's coordinates, display
    # identifiers, app exclusion list, freeform message, and migration bookkeeping.
    stretchly_path = HOME / "Library" / "Application Support" / "Stretchly" / "config.json"
    with stretchly_path.open(encoding="utf-8") as source:
        stretchly = json.load(source)
    excluded_stretchly_keys = {
        "posLatitude", "posLongitude", "screen", "breakContentScreen", "appExclusions",
        "customPreferencesMessage", "isFirstRun", "_migratedOpenAtLogin", "__internal__",
    }
    portable_stretchly = {k: v for k, v in stretchly.items() if k not in excluded_stretchly_keys}
    (DEST / "stretchly.json").write_text(json.dumps(portable_stretchly, indent=2) + "\n", encoding="utf-8")

    print(f"Saved portable app settings to {DEST}")


if __name__ == "__main__":
    main()
