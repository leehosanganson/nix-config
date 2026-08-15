{ ... }:
{
  # Provide persistent fcitx5 "Enumerate" (cycle input method) hotkeys.
  #
  # Why manage the user-level ~/.config/fcitx5/config via home-manager instead of
  # i18n.inputMethod.fcitx5.settings.globalOptions?
  #   - settings.globalOptions writes to the SYSTEM config /etc/xdg/fcitx5/config.
  #   - fcitx5 loads its runtime config from ~/.config/fcitx5/config; when that
  #     user file exists it fully shadows (replaces) the system-level file.
  #   - This user already has a populated ~/.config/fcitx5/config, so the
  #     system-level option would be ignored. Managing the user file guarantees
  #     the enumerate/cycle hotkeys actually take effect and survive rebuilds.
  #
  # Trade-off: fcitx5 GUI writes to ~/.config/fcitx5/config no longer persist
  # across rebuilds (home-manager restores this managed file on each rebuild).
  # The separate ~/.config/fcitx5/profile (the input method list) remains
  # user/fcitx-managed and is NOT touched here.
  home-manager.users.ansonlee.xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    # Enumerate when holding modifier of Toggle key
    EnumerateWithTriggerKeys=True
    # Enumerate Input Method Forward
    EnumerateForwardKeys=Control+Shift
    # Enumerate Input Method Backward
    EnumerateBackwardKeys=Control+Shift_L
    # Skip first input method while enumerating
    EnumerateSkipFirst=False
    # Time limit in milliseconds for triggering modifier key shortcuts
    ModifierOnlyKeyTimeout=250

    [Hotkey/TriggerKeys]
    0=Control+space
    1=Zenkaku_Hankaku
    2=Hangul

    [Hotkey/ActivateKeys]
    0=Hangul_Hanja

    [Hotkey/DeactivateKeys]
    0=Hangul_Romaja

    [Hotkey/AltTriggerKeys]
    0=Shift_L

    [Hotkey/EnumerateGroupForwardKeys]
    0=Super+space

    [Hotkey/EnumerateGroupBackwardKeys]
    0=Shift+Super+space

    [Hotkey/PrevPage]
    0=Up

    [Hotkey/NextPage]
    0=Down

    [Hotkey/PrevCandidate]
    0=Shift+Tab

    [Hotkey/NextCandidate]
    0=Tab

    [Hotkey/TogglePreedit]
    0=Control+Alt+P

    [Behavior]
    # Active By Default
    ActiveByDefault=False
    # Reset state on Focus In
    resetStateWhenFocusIn=No
    # Share Input State
    ShareInputState=No
    # Show preedit in application
    PreeditEnabledByDefault=True
    # Show Input Method Information when switch input method
    ShowInputMethodInformation=True
    # Show Input Method Information when changing focus
    showInputMethodInformationWhenFocusIn=False
    # Show compact input method information
    CompactInputMethodInformation=True
    # Show first input method information
    ShowFirstInputMethodInformation=True
    # Default page size
    DefaultPageSize=5
    # Override XKB Option
    OverrideXkbOption=False
    # Custom XKB Option
    CustomXkbOption=
    # Force Enabled Addons
    EnabledAddons=
    # Force Disabled Addons
    DisabledAddons=
    # Preload input method to be used by default
    PreloadInputMethod=True
    # Allow input method in the password field
    AllowInputMethodForPassword=False
    # Show preedit text when typing password
    ShowPreeditForPassword=False
    # Interval of saving user data in minutes
    AutoSavePeriod=30
  '';
}
