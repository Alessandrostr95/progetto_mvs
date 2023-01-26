#!/bin/bash

MU=./cmurphi5.5.0/src/mu
BUILD_DIR=build
SRC_DIR=src

RED="\033[0;31m"
PURPLE="\033[0;35m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
END="\033[0m"

_ERROR ()
{
  printf "${RED}[ERROR]${END} $1\n"
  exit 0 
}

_DONE () {
  printf "${GREEN}[DONE]${END}\n"
}

_WARNING () {
  printf "${PURPLE}[WARNING]${END} $1\n"
}

_INFO () {
  printf "${CYAN}[INFO]${END} $1\n"
}

sanitize_input() {
  echo $1 | awk '{split($0,a,"."); print a[1]}'
}

if test $# -eq 0; then 
  _ERROR "NO INPUT FILE!" 
fi

if test $# -eq 1; then
  in_name=$(sanitize_input $1)
  out_name="$in_name"
fi

if [[ $# -ge 2 ]]; then
  in_name=$(sanitize_input $1)
  out_name=$2
fi

if $MU -b -c ./$SRC_DIR/$in_name.m > /dev/null;
then
  _INFO "Code generated in file ./$SRC_DIR/$in_name.cpp"
else
  _ERROR "EXIT PROCESS"
fi


if [ ! -d "./$BUILD_DIR" ];
then
  _WARNING "Missing build directory"
  mkdir $BUILD_DIR && _INFO "Directory generated at $PWD/$BUILD_DIR"
fi 

_INFO "Compiling file ./$SRC_DIR/$in_name.cpp"

if g++ -I ./cmurphi5.5.0/include/ ./$SRC_DIR/$in_name.cpp -o ./$BUILD_DIR/$out_name 2> /dev/null;
then
  _INFO "Executable compiled at ./$BUILD_DIR/$out_name"
else
  _ERROR "C++ compiling error"
fi

_INFO "Removing temporary file at ./$SRC_DIR/$in_name.cpp"
rm ./$SRC_DIR/$in_name.cpp

_DONE

echo "Do you want to execute $out_name program?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) ./$BUILD_DIR/$out_name; exit 1;;
    No ) exit 1;
  esac
done
