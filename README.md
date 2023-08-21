# cmocka_mocks

Library to mock common C functions, including libc and jsonc,
for testing purposes.

## Building

cmocka_mocks uses CMake for building:

```bash
export BUILD_TYPE=<Debug|Release>
cmake -B ./build/${BUILD_TYPE}/cmake \
        -D INSTALL_DIR=build/${BUILD_TYPE}/dist \
        -D CMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-D CMOCKA_EXTENSIONS_URI=https://github.com/emlix/cmocka_extensions.git \
	-D CMOCKA_EXTENSIONS_REF=integration
make -C ./build/${BUILD_TYPE}/cmake all
make -C ./build/${BUILD_TYPE}/cmake install
```

It is also possible to configure cmake without the -D flags, if cmocka_extensions
are already installed on the system.

or use the CI hooks

```bash
source CONFIG.ini
./ci/build.sh [Release]
```

### Workspace setup

1. Please run the following git commands after cloning the repository:

   ```bash
   git config core.hooksPath .githooks
   ```

   to set the commit message template and to setup the project specific git hooks.

2. Usually it is a good idea to create a symlink to the compilation database
   created by cmake in the build directory. Run therefore:

   ```
   ln -s build/compile_commands.json
   ```


### Building with custom cmocka_extensions
If you want to build using a custom location or another remote repository for
cmocka_extensions or build another tag or branch then integration,
then the use of variables is required.

If build using cmake, simply adjust the values of ```CMOCKA_EXTENSIONS_URI```
and ```CMOCKA_EXTENSIONS_REF``` to the wanted values. URI can be a local or
remote path.

If building using the CI Hook, refer to the configuration file CONFIG.ini
```SOURCES_URI``` configures the location of the project directory while
```CMOCKA_EXTENSIONS_REPO_NAME``` configures the directory name that contains
the project directory.

Additionally ```CMOCKA_EXTENSIONS_REPO_PATH``` can be set, invalidating both
previous variables. This corresponds to setting ```CMOCKA_EXTENSIONS_URI``` in
the cmake example. In the same way setting ```CMOCKA_EXTENSIONS_REPO_REF```
does the same as in the cmake variant.

## Folders

### ci

Scripts to be used by CI pipelines to build , run various tests and checks.

### documentation

A more detailed description of the mocked functions can be found in the documentation.

```
./documentation/documentation.md
```

### src

Contains the actual productive sources.

#### src/cmocka_mocks

Contains code.
