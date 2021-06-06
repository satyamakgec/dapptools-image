FROM ubuntu:bionic

LABEL maintainer="Satyam Agrawal <satyam0499@gmail.com>"
LABEL image="dapp-hub-image"
LABEL version=0.46.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install git sudo wget curl gnupg software-properties-common apt-utils -y
RUN apt install build-essential -y
RUN useradd admin && echo "admin:admin" | chpasswd && adduser admin sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER admin
WORKDIR /home/admin

RUN sudo chown -R admin:admin /home/admin

RUN curl -L https://nixos.org/nix/install | sh
RUN . /home/admin/.nix-profile/etc/profile.d/nix.sh >> .profile

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/store/rn9899jk59ckr4fkvxiax8abmb53kf53-nix-2.3.12/bin:/nix/store/hrpvwkjz04s9i4nmli843hyw9z4pwhww-bash-4.4-p23/

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs && nix-channel --update && nix-env -iA nixpkgs.gnugrep nixpkgs.findutils
ENV NIX_PATH=nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/21.05.tar.gz
ENV USER=admin
RUN curl https://dapp.tools/install | sh
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/store/rn9899jk59ckr4fkvxiax8abmb53kf53-nix-2.3.12/bin:/nix/store/hrpvwkjz04s9i4nmli843hyw9z4pwhww-bash-4.4-p23/bin:/nix/store/i1zpawiplg4mkpzw73sqy7bqx13r6x5m-dapp-0.32.2/bin:/nix/store/gwgglkm2fhyq55bil7fibfj270rfdmhk-seth-0.10.1/bin:/nix/store/5pkbm23iwg9lf4kwq39x63n2ymlhw3f6-hevm-0.46.0/bin

RUN curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh | sudo bash
RUN nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_6_11
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/store/rn9899jk59ckr4fkvxiax8abmb53kf53-nix-2.3.12/bin:/nix/store/hrpvwkjz04s9i4nmli843hyw9z4pwhww-bash-4.4-p23/bin:/nix/store/i1zpawiplg4mkpzw73sqy7bqx13r6x5m-dapp-0.32.2/bin:/nix/store/gwgglkm2fhyq55bil7fibfj270rfdmhk-seth-0.10.1/bin:/nix/store/5pkbm23iwg9lf4kwq39x63n2ymlhw3f6-hevm-0.46.0/bin:/nix/store/9r8xx2bsmg3p5yhrk9badb6q54fy4z5m-solc-static-0.6.11/bin