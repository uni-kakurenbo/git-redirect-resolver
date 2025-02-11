#!/bin/bash
set -eu

ARGUMENTS=("$0")
SUBMODULE=0
SUBMODULE_FLAGS=""

while (($# > 0)); do
    case "$1" in
    --submodule)
        SUBMODULE=1
        ;;
    --recursive)
        SUBMODULE_FLAGS+="--recursive"
        ;;
    \? | --help)
        echo "--submodule"
        echo "--recursive"
        exit 0
        ;;
    -*)
        echo "$(tput setaf 1)ERROR: $(tput sgr0)Unexpected option: $(tput setaf 5)$1"
        exit 1
        ;;
    *)
        ARGUMENTS=("${ARGUMENTS[@]}" "$1")
        ;;
    esac

    shift
done

function resolve-url() {
    local redirect="$1"

    while :; do
        _redirect="$(curl -w "%{redirect_url}" -s -o /dev/null "${redirect}" 2>/dev/null)"

        if [[ "${_redirect}" == "" ]]; then
            break
        fi
        redirect="${_redirect}"
    done

    if [[ ! "${redirect}" =~ \.git$ ]]; then
        redirect="${redirect}.git"
    fi

    echo "${redirect}"
}

export -f resolve-url

function update-impl() {
    echo "  $2"

    local previous_url
    local redirect_url

    previous_url="$(git remote get-url "$2")"
    redirect_url="$(resolve-url "${previous_url}")"

    if [[ "${previous_url}" == "${redirect_url}" ]]; then
        echo "    ${previous_url}"
        echo "      up-to-date"
    else
        echo "    ${previous_url}"
        echo "     -> ${redirect_url}"

        git remote set-url "$2" "${redirect_url}"
    fi

    echo
}
export -f update-impl

function update-url() {
    echo "$1"
    cd "$1"

    git remote | xargs -I {} bash -c "update-impl $1 {}"
}

export -f update-url

update-url ./

if [[ ${SUBMODULE} -eq 1 || ${SUBMODULE_FLAGS} != "" ]]; then
    git submodule status ${SUBMODULE_FLAGS} | awk '{ print $2 }' | xargs -I {} bash -c 'update-url {}'
fi
