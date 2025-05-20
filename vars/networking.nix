{lib}: rec {
  mainGateway = "192.168.1.1"; # main router
  # use suzi as the default gateway
  # it's a subrouter with a transparent proxy
  defaultGateway = "192.168.1.1";
  nameservers = [
    "119.29.29.29" # DNSPod
    "223.5.5.5" # AliDNS
  ];
  prefixLength = 64;

  hostsAddr = {
    # ============================================
    # Physical Machines
    # ============================================
    physical-mac = {
      # Desktop PC
      iface = "enp4s0";
      ipv4 = "192.168.1.100";
    };

    wifi-mac = {
      iface = "wlo1";
      ipv4 = "192.168.1.16";
    };
  };

  hostsInterface =
    lib.attrsets.mapAttrs
    (
      key: val: {
        interfaces."${val.iface}" = {
          useDHCP = true;
          # ipv4.addresses = [
          #   {
          #     inherit prefixLength;
          #     address = val.ipv4;
          #   }
          # ];
        };
      }
    )
    hostsAddr;

  ssh = {
    # define the host alias for remote builders
    # this config will be written to /etc/ssh/ssh_config
    # ''
    #   Host ruby
    #     HostName 192.168.5.102
    #     Port 22
    #
    #   Host kana
    #     HostName 192.168.5.103
    #     Port 22
    #   ...
    # '';
    extraConfig =
      lib.attrsets.foldlAttrs
      (acc: host: val:
        acc
        + ''
          Host ${host}
            HostName ${val.ipv4}
            Port 22
        '')
      ""
      hostsAddr;

    # define the host key for remote builders so that nix can verify all the remote builders
    # this config will be written to /etc/ssh/ssh_known_hosts
    knownHosts =
      # Update only the values of the given attribute set.
      #
      #   mapAttrs
      #   (name: value: ("bar-" + value))
      #   { x = "a"; y = "b"; }
      #     => { x = "bar-a"; y = "bar-b"; }
      lib.attrsets.mapAttrs
      (host: value: {
        hostNames = [host hostsAddr.${host}.ipv4];
        publicKey = value.publicKey;
      })
      {
        physical-mac.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC5kIr55306tvZKjeMW0CqunMZqhKX1bgw8rHRqaAt0 sany@sany-nixos";
        wifi-mac.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC5kIr55306tvZKjeMW0CqunMZqhKX1bgw8rHRqaAt0 sany@sany-nixos";
      };
  };
}
