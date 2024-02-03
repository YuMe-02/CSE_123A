FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ENV LANG C.UTF-8
ARG INSTALL_ZSH="true"

RUN apt-get update

# Install Verilator 5+ (4 is not sufficient)
RUN apt-get -y install git help2man perl python3 make autoconf g++ flex bison ccache esp-idf cmake
