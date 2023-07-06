#!/bin/bash
set -e -u

CMD_PATH=$(realpath $(dirname $0))
BASE_DIR=${CMD_PATH%/*}
CMAKE_PARAM=${CMAKE_PARAM:-""}
NINJA_PARAM=${NINJA_PARAM:-"-j$(nproc)"}
DEPENDENCY_DIR="$BASE_DIR/build/dependency"

PARAM=""
OPTION_CI=0
OPTION_CLEAN=0
OPTION_VERBOSE=0
OPTION_PACKAGE=0
for element in $@; do
    case $element in
        --ci)          OPTION_CI=1 ;;
        --clean|-c)    OPTION_CLEAN=1 ;;
        --verbose|-v)  OPTION_VERBOSE=1 ;;
	--package)     OPTION_PACKAGE=1 ;;
        -*)          echo "error: unknown option: $1"; exit 1 ;;
        *)           PARAM="$PARAM $element" ;;
    esac
done

set -- $PARAM
if [ $# -gt 1 ]; then
    echo "error: only one build-type allowed"
    exit 1
elif [ $OPTION_CI -eq 1 ]; then
    if [ $# -eq 0 ]; then
        echo "error: build-type must be explicitely set in CI mode"
        exit 1
    fi
    CMAKE_PARAM="-DENABLE_CI=1"
    OPTION_CLEAN=1
    OPTION_VERBOSE=1
fi

BUILD_TYPE="${1:-Debug}"

if [ $OPTION_PACKAGE -eq 1 ]; then
    CMAKE_PARAM="${CMAKE_PARAM} -D PACKAGING=true"
    BUILD_TYPE=Release
    OPTION_CLEAN=1
fi

BUILD_DIR="$BASE_DIR/build/$BUILD_TYPE"
RESULT_DIR="$BUILD_DIR/result"
DIST_DIR="$BUILD_DIR/dist"
CMAKE_BUILD_DIR="$BUILD_DIR/cmake"
export LOCAL_INSTALL_DIR=${LOCAL_INSTALL_DIR:-"$DIST_DIR"}

DEP_BUILD_PARAM=""
if [ $OPTION_CLEAN -eq 1 ]; then
    DEP_BUILD_PARAM="$DEP_BUILD_PARAM -c"
    if [ -e $BUILD_DIR ]; then
        echo "Removing $BUILD_DIR ..."
        rm -rf $BUILD_DIR
    fi
fi
if [ $OPTION_VERBOSE -eq 1 ]; then
    DEP_BUILD_PARAM="$DEP_BUILD_PARAM -v"
    NINJA_PARAM="$NINJA_PARAM -v"
fi

if [ ! -z ${CI+x} ]; then
    echo "Gitlab User: ${GITLAB_USER}"
    DEPENDENCIES="cmocka_extensions;https://$GITLAB_USER@gitlabintern.emlix.com/elektrobit/base-os/cmocka-extensions.git"
else
    DEPENDENCIES="cmocka_extensions;git@gitlabintern.emlix.com:elektrobit/base-os/cmocka-extensions.git"
fi
if [ ! -z $DEPENDENCIES ] && [ ! -d $DEPENDENCY_DIR ]; then
    mkdir -p $DEPENDENCY_DIR
fi
if [ ! -z $DEPENDENCIES ]; then
    echo "getting dependencies..."
fi
for dep in $DEPENDENCIES; do
    echo "-> ${dep}"
    repo=${dep#*;}
    repo_dir=$(basename ${repo%.git})
    dependency=$(basename ${dep%;*})
    if [ ! -d "$DEPENDENCY_DIR/${repo_dir}" ]; then
        rm -rf "$DEPENDENCY_DIR/${repo_dir}"
    fi
    git -C $DEPENDENCY_DIR clone ${repo}
    #if [ -d "$DEPENDENCY_DIR/${repo_dir}" ]; then
    #    echo "already cheacked out!"
    #    git -C "$DEPENDENCY_DIR/${repo_dir}" pull
    #else
    #    git -C $DEPENDENCY_DIR clone ${repo}
    #fi
    declare -x ${dependency}_DIR="$LOCAL_INSTALL_DIR/usr/local/lib/cmake/${dependency}"
    $DEPENDENCY_DIR/${repo_dir}/ci/build.sh $BUILD_TYPE $DEP_BUILD_PARAM
done

echo -e "\n#### Building $(basename $BASE_DIR) ($BUILD_TYPE) ####"
mkdir -p $RESULT_DIR $DIST_DIR
if [ ! -e $CMAKE_BUILD_DIR/build.ninja ]; then
    cmake -B $CMAKE_BUILD_DIR $BASE_DIR -DCMAKE_BUILD_TYPE=$BUILD_TYPE -G Ninja $CMAKE_PARAM
fi

DESTDIR="$LOCAL_INSTALL_DIR" \
ninja -C $CMAKE_BUILD_DIR $NINJA_PARAM all install 2>&1 | tee $RESULT_DIR/build_log.txt

re=${PIPESTATUS[0]}

$BASE_DIR/ci/check_build_log.py $RESULT_DIR/build_log.txt

exit $re
