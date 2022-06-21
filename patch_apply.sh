#!/bin/bash

PROJ_NAME=${1:-ME-XU5-2EG-1I-D11E_PE1_SD}
#set -x #echo on
cd /$HOME/project/$PROJ_NAME/components/yocto/layers/core/scripts/lib/wic
if [ ! -f filemap.py.orig ]
then
	cp filemap.py filemap.py.orig
    patch -s filemap.py < $HOME/patches/filemap.py.patch
	echo "INFO: Patched /$HOME/project/$PROJ_NAME/components/yocto/layers/core/scripts/lib/wic/filemap.py"	
else
    echo "WARNING: Already patched /$HOME/project/$PROJ_NAME/components/yocto/layers/core/scripts/lib/wic/filemap.py!"
fi
