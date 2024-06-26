{
  pkgs,
  lib,
  username,
  overlays,
  inputs,
  ...
}: {
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = {
      inherit overlays inputs username;
    };
    users.${username} = {...}: {
      imports = [
        ./home.nix
      ];
    };
  };

  fonts.fonts = [
    pkgs.pragmataPro
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix = {
    # enable flakes per default
    package = pkgs.nixUnstable;
    settings = {
      allowed-users = [username];
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" username];
    };
  };
  homebrew = {
    onActivation = {
      /*
      cleanup = "zap";
      */
    };
    enable = true;

    brews = [
      "gnu-sed"
      /*
      "yabai"
      */
    ];
    casks = [
      "hammerspoon"
      "alacritty"
      "spotify"
      "iterm2"
      "calibre"
      "slack"
      "discord"
      "kitty"
      "firefox"
      "sonic-pi"
      "brave-browser"
      "font-fira-code-nerd-font"
    ];

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/services"

      "koekeishiya/formulae" # yabai
    ];
  };

  /*
  services.yabai.enable = true;
  */
  /*
  services.yabai.package = pkgs.yabai;
  */
  /*
  services.skhd.enable = true;
  */

  system = {
    activationScripts.postUserActivation.text = ''
      # Install homebrew if it isn't there
      if [[ ! -f "/usr/local/bin/brew" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      /*
      NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
      */
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        AppleShowAllFiles = true;
        NSAutomaticQuoteSubstitutionEnabled = false;
        _HIHideMenuBar = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      dock = {
        autohide = true;
        show-recents = true;
        tilesize = 45;
      };
    };
  };
}
/*
aom                     fd                      jemalloc                libx11                  numpy                   screenresolution
*/
/*
archey                  fontconfig              jpeg                    libxau                  oniguruma               sd
*/
/*
assimp                  freetype                jpeg-xl                 libxcb                  openblas                sfcgal
*/
/*
autoconf                freexl                  jrnl                    libxdmcp                openexr                 shared-mime-info
*/
/*
bdw-gc                  fswatch                 json-c                  libxext                 openjpeg                six
*/
/*
berkeley-db             gcc                     kakoune                 libxml2                 openssl@1.1             sk
*/
/*
boost                   gdal                    krb5                    libxrender              openssl@3               sqlite
*/
/*
brew-graph              gdbm                    lf                      libyaml                 p11-kit                 swi-prolog
*/
/*
brotli                  geos                    libarchive              little-cms2             pcre                    szip
*/
/*
c-ares                  gettext                 libb2                   lua                     pcre2                   tcl-tk
*/
/*
ca-certificates         ghostscript             libdap                  luajit                  pixman                  the_silver_searcher
*/
/*
cairo                   giflib                  libde265                luajit-openresty        pkg-config              tokei
*/
/*
calc                    git                     libevent                luarocks                poppler                 trash-cli
*/
/*
cask                    glib                    libffi                  luv                     poppler-qt5             tree-sitter
*/
/*
cf-cli                  gmp                     libgeotiff              lynx                    popt                    ultralist
*/
/*
cfitsio                 gnu-getopt              libheif                 lz4                     postgresql              unbound
*/
/*
cgal                    gnu-sed                 libidn                  lzo                     postgresql@10           unibilium
*/
/*
cmake                   gnu-tar                 libidn2                 m4                      postgresql@14           unixodbc
*/
/*
coreutils               gnutls                  liblqr                  md4c                    prettier                utf8proc
*/
/*
cowsay                  guile                   libmng                  minizip                 procs                   webp
*/
/*
dark-mode               hdf5                    libmpc                  mongodb                 proj                    wget
*/
/*
dbus                    heroku                  libnghttp2              mpdecimal               proj@7                  wxmac
*/
/*
direnv                  heroku-node             libomp                  mpfr                    protobuf                wxwidgets
*/
/*
docbook                 htop                    libpng                  msgpack                 protobuf-c              x265
*/
/*
docbook-xsl             httpie                  libpq                   ncurses                 pyenv                   xerces-c
*/
/*
double-conversion       hub                     libpthread-stubs        neofetch                python@2                xmlto
*/
/*
eigen                   hunspell                librttopo               netcdf                  python@3.10             xorgproto
*/
/*
elixir                  icu4c                   libspatialite           nettle                  python@3.8              xz
*/
/*
elm                     ilmbase                 libtasn1                nmap                    python@3.9              yetris
*/
/*
elm-format              imagemagick             libtermkey              nnn                     qt                      zstd
*/
/*
epsilon                 imath                   libtiff                 node                    qt@5
*/
/*
erlang                  isl                     libtool                 node-build              rbenv
*/
/*
exa                     jansson                 libunistring            nodenv                  readline
*/
/*
exercism                jasper                  libuv                   nspr                    redis
*/
/*
expat                   jbig2dec                libvmaf                 nss                     ruby-build
*/

