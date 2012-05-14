#! /bin/bash

# Set some default variables
WORKINGDIR=$(pwd)
RELEASEDIR=$WORKINGDIR/directorylister-releases
SOURCEDIR=/tmp/directorylister-source
GITDIR=$SOURCEDIR/.git

# Get updated source from Github
if [ -d $GITDIR ]; then
    cd  $SOURCEDIR
    git pull -q origin master
    cd  $WORKINGDIR
else
    if [ -d $SOURCEDIR ]; then
        rm $SOURCEDIR
    fi
    git clone --recursive -q git://github.com/DirectoryLister/DirectoryLister.git $SOURCEDIR
fi

# Set version info variables
VERSION=$(cat $SOURCEDIR/resources/DirectoryLister.php | grep "const VERSION" | awk -F \' '{print $(NF-1)}')
RELEASENAME=DirectoryLister-v$VERSION
FINALDIR=/tmp/$RELEASENAME

# Remove all git files
find $SOURCEDIR -type d -name .git -exec rm -rf {} \;
find $SOURCEDIR -type f -name .gitignore -delete

# Rename source directory to release directory
if [ -d $FINALDIR ]; then
    rm -rf $FINALDIR
fi

mv $SOURCEDIR $FINALDIR

# Create directorylister-release folder if not present
if [ ! -d $RELEASEDIR ]; then
    mkdir $RELEASEDIR
fi

# Change directories
cd /tmp

# Make the .tar.gz release file
tar -czf $RELEASEDIR/$RELEASENAME.tar.gz $RELEASENAME --overwrite

# Make the .zip release file
zip -qr $RELEASEDIR/$RELEASENAME.zip $RELEASENAME
