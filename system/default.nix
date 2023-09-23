{ ... }:

{
  # Set your time zone
  time.timeZone = "Europe/Bucharest";

  # Set your locale settings
  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings.LC_MEASUREMENT = "es_ES.utf8";
  };

  # Show asterisks when typing sudo password
  security.sudo.extraConfig = "Defaults pwfeedback";
}
