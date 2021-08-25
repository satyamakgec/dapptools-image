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

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/store/jhbxh1jwjc3hjhzs9y2hifdn0rmnfwaj-nix-2.3.15/bin:/nix/store/xvvgw9sb8wk6d2c0j3ybn7sll67s3s4z-bash-4.4-p23/

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs && nix-channel --update && nix-env -iA nixpkgs.gnugrep nixpkgs.findutils
ENV NIX_PATH=nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/21.05.tar.gz
ENV USER=admin
RUN curl https://dapp.tools/install | sh
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/store/jhbxh1jwjc3hjhzs9y2hifdn0rmnfwaj-nix-2.3.15/bin:/nix/store/xvvgw9sb8wk6d2c0j3ybn7sll67s3s4z-bash-4.4-p23/bin:/nix/store/0g5glbq80jlqivddgv6hjqxyky93l6q7-dapp-0.34.0/bin:/nix/store/c02vzqpc85nkwj0iwirgyvr0ls3g5jl3-seth-0.10.1/bin:/nix/store/xqb54p9vskabw9fl336gp4byair7vw57-hevm-0.48.0/bin

RUN curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh | sudo bash
RUN nix-env -f https://github.com/dapphub/dapptools/archive/master.tar.gz -iA solc-static-versions.solc_0_8_6
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/nix/store/jhbxh1jwjc3hjhzs9y2hifdn0rmnfwaj-nix-2.3.15/bin:/nix/store/xvvgw9sb8wk6d2c0j3ybn7sll67s3s4z-bash-4.4-p23/bin:/nix/store/0g5glbq80jlqivddgv6hjqxyky93l6q7-dapp-0.34.0/bin:/nix/store/c02vzqpc85nkwj0iwirgyvr0ls3g5jl3-seth-0.10.1/bin:/nix/store/xqb54p9vskabw9fl336gp4byair7vw57-hevm-0.48.0/bin:/nix/store/4ps62x4vg3pnnvfq0pb3rm8v0jy80bw6-solc-static-0.8.6/bin
RUN touch .bashrc
RUN echo 'alias solc=solc-0.8.6' >> .bashrc