# cmocka_mocks

Library to mock common C functions, including libc and jsonc,
for testing purposes.

## Building

cmocka_mocks uses CMake for building:

```bash
cmake -B ./build ./cmocka_mocks
make -C ./build all
make -C ./build install
```

or use the CI hooks

```bash
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
