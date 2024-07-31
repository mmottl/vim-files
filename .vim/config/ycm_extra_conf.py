import os
import ycm_core

def GetIncludePathsFromEnvironment():
    paths = os.environ.get('C_INCLUDE_PATH', '')
    return paths.split(':') if paths else []

def Settings(**kwargs):
    include_paths = GetIncludePathsFromEnvironment()

    # Default flags
    flags = []

    # Determine the language and adjust the flags accordingly
    if kwargs.get('language') == 'cfamily':
        flags += ['-Wall', '-Wextra', '-pedantic', '-Wno-keyword-macro']
        filename = kwargs.get('filename', '')
        if (filename.endswith('.cpp') or filename.endswith('.cxx')
            or filename.endswith('.cc')):
            # C++ specific flags
            flags.extend(['-x', 'c++', '-std=c++20'])  # Adjust C++ standard as needed
        else:
            # C specific flags
            flags.extend(['-x', 'c', '-std=c17'])  # Adjust C standard as needed

        # Add the include paths for both C and C++
        for path in include_paths:
            flags.extend(['-I', path])

    return {
        'flags': flags
    }
