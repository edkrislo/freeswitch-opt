#!/bin/sh

# install.sh: install Cepstral Voice + Engine on Unix systems
# Copyright (c) 2000-2011 Cepstral, LLC.  All rights reserved.

set -e

SRCDIR=`pwd`

AgreeEULA="$1"
InstallDir="$2"

if [ ! -f "$SRCDIR/eula.txt" ]; then
    1>&2 cat <<EOF

Could not find the End-User License Agreement.  You must read the license
before installing this software product.

EOF
    exit 1
fi

if [ "$AgreeEULA" != "agree" ]; then

    echo ""
    echo "Please read and agree to the License Agreement before installing this software."
    more "$SRCDIR/eula.txt"

    echo ""
    printf "Do you agree to these terms?  Enter -yes- to continue: "
    read answer
    echo ""
    if [ "x$answer" != "xyes" ]; then
        echo "Cancelling installation at your request."
        exit 0
    fi

fi

# Get the installation directory
while :; do
    if [ ! "$InstallDir" ]; then
        printf "Install into what directory? [/opt/swift] "
        read prefix
    else
        prefix=$InstallDir
    fi
    if [ `uname -s` = "Linux" ]; then
        prefix="`echo $prefix | awk -v h=$HOME '{gsub(/~/,h); print}'`"
    fi
    prefix=${prefix:-/opt/swift} # set default if none given
    if [ ! "$InstallDir" ]; then
        if [ ! \( -d "$prefix" -o -h "$prefix" \) ]; then
            answer=
            while [ "x$answer" != "xy" -a "x$answer" != "xn" ]; do
                printf "$prefix does not exist.  Create it? ([n]/y) "
                read answer
            done
            if [ "x$answer" = "xy" ]; then
                mkdir -p "$prefix"
            fi
        elif [ ! -d "$prefix" ]; then
            echo "$prefix is not a directory!"
        fi
        if [ -d "$prefix" ]; then
            break
        fi
    else
        if [ ! \( -d "$prefix" -o -h "$prefix" \) ]; then
            mkdir -p "$prefix"
        elif [ ! -d "$prefix" ]; then
            echo "$prefix is not a directory!"
            exit 0
        fi
        if [ -d "$prefix" ]; then
            break
        fi
    fi
done

# Build installation directories
SWIFT_VOXPATH="$prefix/voices"
SWIFT_LIB="$prefix/lib"
SWIFT_BIN="$prefix/bin"
SWIFT_ETC="$prefix/etc"
SWIFT_INCLUDE="$prefix/include"
SWIFT_SFX="$prefix/sfx"
SWIFT_DOC="$prefix/doc"

if [ ! "$InstallDir" ]; then
   
    cat <<EOF

Swift will be installed in the following directories:

  Voices in $SWIFT_VOXPATH
  Shared libraries in $SWIFT_LIB
  Binaries in $SWIFT_BIN
  Configuration file in $SWIFT_ETC
  Header files in $SWIFT_INCLUDE
  Sound effects filters in $SWIFT_SFX
  Documentation in $SWIFT_DOC

EOF

    printf "Is this acceptable?  Enter 'yes' to continue: "
    read answer
    if [ "x$answer" != "xyes" ]; then
        echo "Cancelling installation at your request."
        exit 0
    fi

fi

# Make directories
mkdir -p "$SWIFT_VOXPATH" "$SWIFT_LIB" "$SWIFT_BIN" "$SWIFT_ETC" \
         "$SWIFT_INCLUDE" "$SWIFT_SFX" "$SWIFT_DOC"
chmod a+rx "$SWIFT_VOXPATH" "$SWIFT_LIB" "$SWIFT_BIN" "$SWIFT_ETC" \
           "$SWIFT_INCLUDE" "$SWIFT_SFX" "$SWIFT_DOC" 

# Copy libraries
echo
echo
echo Installing libraries...
# Make sure that symlinks DON'T get dereferenced!
(cd "$SRCDIR/lib" && tar cf - *) | (cd "$SWIFT_LIB" && tar xf -)
cat <<EOF

***************************************************************************
If you are installing Swift system-wide, you may need to add the following
line to /etc/ld.so.conf and run ldconfig as root:

    $SWIFT_LIB

(Otherwise, you will need to add it to the LD_LIBRARY_PATH environment
variable in order to run programs linked against the Swift libraries.)
***************************************************************************

EOF

# Copy voices
for voice in "$SRCDIR/voices"/*; do
    vname="`basename \"$voice\"`"
    #`
    echo Installing voice $vname...
    mkdir -p "$SWIFT_VOXPATH/$vname"
    cp -f "$voice"/* "$SWIFT_VOXPATH/$vname" 2>/dev/null || true

   # last voice installed will be default
   SWIFT_DEFAULT_VOICE=$vname
done

# Create configuration
echo
echo Creating configuration...

if [ -f "$SWIFT_ETC/swift.xml" ]; then
    mv -f "$SWIFT_ETC/swift.xml" "$SWIFT_ETC/swift.xml.old"
fi
cat <<EOF > "$SWIFT_ETC/swift.xml"
<?xml version="1.0"?>

<!-- Generated by install.sh on `date +"%F at %k:%M:%S"` -->

<cepstral_swift version="6.0.1">

    <voice_path>
         $SWIFT_VOXPATH <!-- List of voice directories.  They can be
                             seperated by newlines or colons. -->
    </voice_path>
    
    <library_path>
        $SWIFT_LIB      <!-- Path to the swift TTS libraries. -->
    </library_path>
    
    <binary_path>
        $SWIFT_BIN      <!-- Path to the 'swift' and
                             'cepstral-licsrv' binaries. -->
    </binary_path>
    
    <etc_path>
        $SWIFT_ETC      <!-- Path to swift TTS etc files. -->
    </etc_path>        
    
</cepstral_swift>
EOF

# Copy binaries
echo
echo Installing binaries...
cp -f "$SRCDIR/bin/swift" "$SWIFT_BIN/."
cp -f "$SRCDIR/bin/swift.bin" "$SWIFT_BIN/."
cp -f "$SRCDIR/bin/cepstral-licsrv" "$SWIFT_BIN/."
cp -f "$SRCDIR/bin/cepstral-licsrv.bin" "$SWIFT_BIN/."
chmod 755 "$SWIFT_BIN"/*

sed -e "s#@INSTALLED_AT@#$prefix#" <"$SRCDIR/bin/swift" >"$SWIFT_BIN/swift"
sed -e "s#@INSTALLED_AT@#$prefix#" <"$SRCDIR/bin/cepstral-licsrv" >"$SWIFT_BIN/cepstral-licsrv"
chmod +x "$SWIFT_BIN/swift"
chmod +x "$SWIFT_BIN/cepstral-licsrv"

# Install symlink
if [ -w /usr/local/bin ]; then
    echo Installing symbolic link to swift...
    rm -f /usr/local/bin/swift
    ln -s "$SWIFT_BIN/swift" /usr/local/bin/swift
else
    echo No permissions to add symbolic links to /usr/local/bin. Skipping...
fi

# Copy includes
cp -f "$SRCDIR/include"/* "$SWIFT_INCLUDE"
chmod 644 "$SWIFT_INCLUDE"/*


# Copy example SFX files
cp -f "$SRCDIR/sfx"/* "$SWIFT_SFX"
chmod 644 "$SWIFT_SFX"/*
    
# Copy docs (excluding manpage)
for docfile in "$SRCDIR/doc"/*; do
    if [ `basename "$docfile"` != swift.1 ]; then
        cp -f "$docfile" "$SWIFT_DOC"
    fi
done
cp -f "$SRCDIR/eula.txt" "$SWIFT_DOC"/"eula.txt"

# Install man page
if [ -w /usr/share/man ]
then
    echo Installing man page...
    cp -f "$SRCDIR/doc/swift.1" "/usr/share/man/man1"
    chmod 644 "/usr/share/man/man1/swift.1"
else
    echo No permissions to install man page in /usr/share/man/man1. Skipping...
fi

# Fix permissions to allow non-root users access
echo
echo Setting permissions...
chmod -R a+r $prefix

echo
echo Kill License Server
outps=`ps -elf | grep cepstral-licsrv | grep -v grep | awk '{print $2}'`
if [ "$outps" = "S" ] || [ "$outps" = "T" ] || [ "$outps" = "R" ]; then
outps=`ps -elf | grep cepstral-licsrv | grep -v grep | awk '{print $4}'`
fi

if [ "$outps" != "" ]; then
echo "   Killing PID $outps."
kill -9 $outps
fi

echo
echo Testing the installed swift binary...
unset SWIFT_HOME LD_LIBRARY_PATH || true
echo "$SWIFT_BIN/swift -o /dev/null 'hello world'"
if "$SWIFT_BIN/swift" -o /dev/null 'hello world'; then
cat <<EOF

***************************************************************************
****************** Installation Completed Successfully! *******************
***************************************************************************

EOF
    if [ "x$prefix" != "x/opt/swift" ]; then
    cat <<EOF
Since you have installed Swift to a directory other than the default of
/opt/swift, you may need to set the SWIFT_HOME environment variable to the
following value when running your own programs linked against it:

    $prefix

Also, you are free to modify the wrapper script installed in the following
directory for use with your own programs:

    $SWIFT_BIN/swift

EOF
    fi
else
    cat <<EOF

Installation failed.  Please contact Cepstral LLC by e-mail for further
support, including a transcript of the installation script's output, if
possible.

EOF
fi
