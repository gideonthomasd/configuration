# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  
  boot.loader.systemd-boot.enable = true; # (for UEFI systems only)
  
  ##boot.loader.grub.enable = true;
  ##boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  ##boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  
  ######WINDOWS###################################################
  #boot.loader.grub.useOSProber = true; # windows system

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via networkmanager.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "uk";
   };

  

  # Configure keymap in X11
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  
  services.avahi.publish.userServices = true;
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
  ######NETWORK##########
  ##Do $ lpinfo --include-schemes dnssd -v   # Get and copy Brother%20MFC.....
  ## Put into ipp instead of Networking.  ipp://Brother%20MFC.......
  ## From lpinfo choose it without 'printer' in file.  SHARE and FROM INTERNET as options.
  ## Put in ip-everywhere in options for driver

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.noDesktop = true;
  services.xserver.desktopManager.xfce.enableXfwm = false;

nixpkgs.overlays = [
(self: super: {
dwm = super.dwm.overrideAttrs (_: {
src = builtins.fetchGit https://github.com/gideonthomasd/mydwm.git;
});
})

(self: super: {
			qtile = super.qtile.overrideAttrs(oldAttrs: {
				pythonPath = oldAttrs.pythonPath ++ (with self.python37Packages;[
				keyring
				xcffib
				setuptools
				setuptools_scm
				dateutil
				dbus-python
				mpd2
				psutil
				pyxdg
				pygobject3
				]);
			});
		})

];

services.xserver.displayManager.defaultSession = "none+bspwm";
services.xserver.windowManager.dwm.enable = true;

#######i3##################

boot.supportedFilesystems = [ "ntfs" ];

environment.pathsToLink = [ "/libexec" ];
services.xserver.windowManager.i3 = {
enable = true;
extraPackages = with pkgs; [
i3status
i3blocks
];
};
services.xserver.windowManager.i3.package = pkgs.i3-gaps;

###########Fonts###################
fonts.fonts = with pkgs; [
iosevka
noto-fonts
font-awesome-ttf
cantarell-fonts
noto-fonts-emoji
google-fonts
(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

];
##########bspwm#############
services.xserver.windowManager.bspwm = {
enable = true;

};
#######openbox##########
services.xserver.windowManager.openbox.enable = true;

#######fluxbox#########
services.xserver.windowManager.fluxbox.enable = true;

#######pekwm#########
services.xserver.windowManager.pekwm.enable = true;

#######Awesome#########
services.xserver.windowManager.awesome = {
  enable = true;
  luaModules = [
    pkgs.luaPackages.vicious
    ];
 };
 
 #######Spectrwm#########
services.xserver.windowManager.spectrwm.enable = true;

 #######Xmonad#########
services.xserver.windowManager.xmonad.enable = true;
services.xserver.windowManager.xmonad.enableContribAndExtras = true;

#######leftwm#########
services.xserver.windowManager.leftwm.enable = true; 

#######Qtile#########
services.xserver.windowManager.qtile.enable = true; 

 

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
  ################## BLUETOOTH ########################
  ##hardware.bluetooth.enable = true;
  ##services.blueman.enable = true;
  
  ################## NVIDIA ###########################
  ##services.xserver.videoDrivers = [ "nvidia" ];
  ##hardware.opengl.enable = true;
  ##hardware.opengl.driSupport32Bit = true;
  ##hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  ##hardware.pulseaudio.support32Bit = true;

  ##services.flatpak.enable = true;
  ##xdg.portal.enable = true;
  ######In Terminal do $ flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  ###### and install Steam flatpak
  

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.phil = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "phil" ]; # Enable ‘sudo’ for the user.
   };

nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     wget vim
     firefox
git
geany
termite
pcmanfm
xfce.thunar
xfce.thunar-volman
gvfs
jgmenu
xcompmgr
sxhkd
clipit
feh
lxappearance
dmenu
lxtask
rofi
lemonbar-xft
gcc
gmrun
mfcj6510dwlpr
bspwm
openbox
tint2
xarchiver
openbox-menu
lxmenu-data
menumaker
xterm
plank
obconf
unzip
#zoom-us
etcher
luna-icons
pciutils
evince
vlc
mpv-unwrapped
fluxbox
fbpanel
fbmenugen
brave
bibata-cursors
stalonetray
kitty
gsimplecal
sakura
polybar
binutils
xmobar
xournalpp
i3lock
i3lock-fancy
youtube-dl
gparted
libreoffice
lxterminal
vim
];


  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

