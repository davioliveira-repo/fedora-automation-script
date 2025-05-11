#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root (sudo ./script.sh)"
  exit 1
fi

echo "Adicionando repositórios RPM Fusion (free e non-free)..."
dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Instalando repositórios e pacote do Visual Studio Code..."
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
dnf install -y code

echo "Instalando Btop, Git e Fastfetch..."
dnf install -y btop git fastfetch

echo "Instalando fontes da Microsoft..."
dnf install -y curl cabextract xorg-x11-font-utils fontconfig
rpm -i https://downloads.sourceforge.net/project/corefonts/the%20fonts/final/msttcorefonts-2.5-1.noarch.rpm

echo "Instalando Google Chrome (Stable)..."
dnf config-manager --add-repo=https://dl.google.com/linux/chrome/rpm/stable/x86_64
dnf install -y google-chrome-stable

echo "Instalando Flatpak (caso não esteja instalado)..."
dnf install -y flatpak

echo "Adicionando repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Instalando apps via Flatpak..."
flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub org.pgadmin.pgadmin4
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub net.pcsx2.PCSX2
flatpak install -y flathub io.github.shiftey.Desktop
flatpak install -y flathub org.gnome.Boxes
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub org.shotcut.Shotcut
flatpak install -y flathub com.obsproject.Studio

# Comentário sobre a Steam
echo -e "\n# ATENÇÃO:"
echo "# Para instalar a Steam com melhor compatibilidade, recomenda-se instalar manualmente via RPM Fusion:"
echo "# dnf install steam"

echo -e "\nScript concluído com sucesso!"
