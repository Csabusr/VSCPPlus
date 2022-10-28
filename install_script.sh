#!/bin/bash
echo "ONLY TESTED ON INTEL BASED MACBOOK."
VERSION="1.0.0"

PRINTHELP(){
echo "This script is install and configure a Visual Studio Code application and all of necessary component
for c++ development. (MACBOOK)
	Usage: ./install_script.sh -options

	Command:
		-h: Shows this message.
		-v: Shows the script version.
		-i: Install everything you need.
"
}

if [ $# == 0 ] ; then
    PRINTHELP
    exit 1;
fi

while getopts ":ivh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "i")
	echo -e "Please enter your sudo password for full automatization: "
	read -s PASSWORD
	echo "Checking installed aplications." 
	
	BREWC=$(brew -v | grep -o -m 1 "Homebrew")
        if [ $BREWC = "Homebrew" ] ; then
                echo "Homebrew already installed."
        else
                echo "Homebrew not installed."
                echo "Installing..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

	VSCC=$(find /Applications -name 'Visual Studio Code.app' -print -quit | grep -o Code)
	if [ $VSCC = "Code" ] ; then
		echo "VSCode already installed."
	else
		echo "VSCode not installed."
		echo "Installing..."
		brew install --cask visual-studio-code
	fi

	CLANGC=$(clang --version | grep -o -m 1 'clang' | tr -d '\n')
        if [ $CLANGC = "clangclang" ] ; then
                echo "Clang already installed."
        else
                echo "Clang not installed."
                echo "Installing..."
		echo "$PASSWORD" | sudo -S xcode-select --install
        fi

	echo "VSCode c++ extension install"
	code --install-extension "ms-vscode.cpptools"
	echo "VSCode c++ extension pack install"
	code --install-extension "ms-vscode.cpptools-extension-pack"
	echo "All installation is executed."
	echo "Creating Hello World app"
	cd ~
	mkdir dev
	cd dev
	mkdir VSCode_Projects
	cd VSCode_Projects
	mkdir helloworld
	cd helloworld
	touch helloworld.cpp
	echo "#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main()
{
    cout << \"Hello C++ World from VS Code and the C++ extension!\" << endl;
    return 0;
}" >> helloworld.cpp
	echo "Finished."
	echo "Adding code . to default path."
	export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
	code .
        ;;
      "h")
	PRINTHELP
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
	PRINTHELP
        exit 0;
        ;;
    esac
  done
