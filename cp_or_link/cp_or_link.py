#!/usr/bin/env python

def copy_or_link(source,target):
    '''
    Function that attempts to hard link a file (source) to a new location (target).
    Failing this, the function performs a copy operation instead.

    Parameters
    ----------
    source : string
        The file to be linked/copied.
    target : string
        The destination path that the file should be linked/copied to.
    Returns:
    ----------
    none
    '''
    import shutil
    import os

    if not os.path.exists(os.path.dirname(target)):
        os.makedirs(os.path.dirname(target))
    if os.path.isfile(target):
        raise IOError('%s already exists.' % target)
    try:
        os.link(source,target)
    except OSError as e:
        # Cross-device hardlink error
        if 'Errno 18' in str(e):
            shutil.copy(source,target)
        else:
            raise

if __name__ == '__main__':
    import sys
    source = sys.argv[1]
    target = sys.argv[2]
    copy_or_link(source,target)

