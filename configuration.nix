# computer
{ config, pkgs, ... }:

{
imports =
[ # Include the results of the hardware scan.
	./hardware-configuration.nix
	 <home-manager/nixos>
];

# Use the systemd-boot EFI boot loader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.supportedFilesystems = [ "ntfs" ];
networking.networkmanager.enable = true;
networking.hostName = "BATS-01";


# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

services.xserver.enable = true;
services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;
# services.xserver.desktopManager.plasma5.enable = true;

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound with pipewire.
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
};

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
#   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
# };

# List packages installed in system profile. To search, run:
# $ nix search wget
environment.systemPackages = with pkgs; [
wget 
vim
zoom-us
vlc
 # etcher
gparted
steam
git
libreoffice
vscodium-fhs
torrential
google-chrome
python3
nodejs
];

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.admin = {
  isNormalUser = true;
  description = "admin";
  extraGroups = [ "networkmanager" "wheel" ];
  packages = with pkgs; [
    firefox
    gnomeExtensions.fuzzy-clock-2
    gnomeExtensions.vitals
    gnomeExtensions.dock-from-dash
  ];
};

# Home Manager stuff
home-manager.users.admin = {
  home.stateVersion = "24.05";
  # Programs
  programs.git = {
  enable = true;
  userName = "Phil";
  userEmail = "EMAIL@gmail.com";
  };
  programs.firefox = {
  enable = true;
  # userName  = "my_git_username";
  # userEmail = "my_git_username@gmail.com";
  };
  # Desktop stuff	
  gtk = {
    enable = true;
    iconTheme = {
      name = "BeautyLine";
      package = pkgs.beauty-line-icon-theme;
    };
    # cursorTheme = {
    # name = "Nordzy-Cursor";
    #  package = pkgs.nordzy-cursor-theme;
    # };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };	
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
     	disable-user-extensions = false;
      	# `gnome-extensions list` for a list
      	enabled-extensions = [
        	"Vitals@CoreCoding.com"
        	"fuzzy-clock@keepawayfromfire.co.uk"
        	"dock-from-dash@fthx"
      ];
    };
	"org/gnome/settings-daemon/plugins/media-keys" = {
		custom-kebindings = [
			"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
];
};

	"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
		name = "console";
		command = "gnome-console";
		binding = "<Super>t";
};

  };
};


programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};



# Automatic Garbage Collection
nix.gc = {
automatic = true;
dates = "weekly";
options = "--delete-older-than 7d";
};

# Auto system update
system.autoUpgrade = {
enable = true;
};

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
programs.mtr.enable = true;
programs.gnupg.agent = {
enable = true;
enableSSHSupport = true;
};

nixpkgs.config.permittedInsecurePackages = [
"electron-19.1.9"
];

# List services that you want to enable
services.printing.enable = true;
hardware.facetimehd.enable = true;
nixpkgs.config.allowUnfree = true;
boot.kernelModules = [ "w1" ];
boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];


services.avahi = {
  enable = true;
  nssmdns = true;
  openFirewall = true;
};

# Enable the OpenSSH daemon.
services.openssh.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "unstable"; # Did you read the comment?

}