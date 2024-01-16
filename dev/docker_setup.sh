#!/bin/bash
# Ensure that you have installed docker(API >= 1.40) and the nvidia graphics driver on host!
# Copyright 2018-2024, Kolin Guo, All rights reserved.
VERSION="v0.3.2"  # version of this setup script

# Move to the repo folder, so later commands can use relative paths
SCRIPT_PATH=$(readlink -f "$0")
REPO_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
cd "$REPO_DIR"
REPO_NAME=$(basename "$REPO_DIR")  # default WORKDIR inside container

############################################################
# Section 0: Project-Specific Settings                     #
############################################################
IMGNAME="kolinguo/mplib-build:IMG_TAG"
CONTNAME="mplib"
DOCKERFILEPATH="docker/Dockerfile"

############################################################
# argbash configuration section                            #
############################################################
# Created by argbash-init v2.10.0
# Rearrange the order of options below according to what you would like to see in the help message.
# ARG_OPTIONAL_SINGLE([tag],[t],[image tag to use],[latest])
# ARG_OPTIONAL_SINGLE([work-dir],[w],[working directory inside container\nmounts from '${REPO_DIR}'],[/${REPO_NAME}])
# ARG_OPTIONAL_BOOLEAN([build-local],[l],[build docker image locally or pull from remote registry],[off])
# ARG_OPTIONAL_BOOLEAN([push],[p],[upload image to remote registry after building],[off])
# ARG_OPTIONAL_BOOLEAN([build-only],[o],[build image/container only and do not start the container],[off])
# ARG_OPTIONAL_BOOLEAN([rm],[],[remove previously built docker image],[off])
# ARG_OPTIONAL_BOOLEAN([bashrc-only],[],[generate only the custom bashrc],[off])
# ARGBASH_SET_INDENT([  ])
# ARGBASH_SET_DELIM([ =])
# ARG_OPTION_STACKING([getopt])
# ARG_RESTRICT_VALUES([no-local-options])
# ARG_HELP([Generic docker image/container setup script, adapted for ${REPO_NAME}],[Copyright 2018-2024, Kolin Guo, All rights reserved.\n])
# ARG_VERSION([echo -e "$(basename ${0}) ${VERSION}\n\nGeneric docker image/container setup script, adapted for ${REPO_NAME}\nCopyright 2018-2024, Kolin Guo, All rights reserved."],[V])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
  local _ret="${2:-1}"
  test "${_PRINT_HELP:-no}" = yes && print_help >&2
  echo "$1" >&2
  exit "${_ret}"
}


evaluate_strictness()
{
  [[ "$2" =~ ^-(-(tag|work-dir|build-local|push|build-only|rm|bashrc-only|help|version)$|[twlpohV]) ]] && die "You have passed '$2' as a value of argument '$1', which makes it look like that you have omitted the actual value, since '$2' is an option accepted by this script. This is considered a fatal error."
}


begins_with_short_option()
{
  local first_option all_short_options='twlpohV'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_tag="latest"
_arg_work_dir="/${REPO_NAME}"
_arg_build_local="off"
_arg_push="off"
_arg_build_only="off"
_arg_rm="off"
_arg_bashrc_only="off"


print_help()
{
  local usage="Usage: $(basename ${0}) [-t <tag>] [-w <work-dir>] [OPTION]...\n"
  usage+="Generic docker image/container setup script, adapted for ${REPO_NAME}\n\n"
  usage+="  -t, --tag               image tag to use (default: '\e[1;32mlatest\e[0m')\n"  # ]]
  usage+="  -w, --work-dir          working directory inside container (default: '\e[1;35m/${REPO_NAME}\e[0m')\n"  # ]]
  usage+="                          mounts from '\e[1;32m${REPO_DIR}\e[0m'\n"  # ]]
  usage+="  -l, --build-local       build docker image locally with Dockerfile\n"
  usage+="      --no-build-local    pull image from remote registry (default)\n"
  usage+="  -p, --push              upload image to remote registry after building\n"
  usage+="      --no-push           (default)\n"
  usage+="  -o, --build-only        build image and container only\n"
  usage+="      --no-build-only     start and attach the container (default)\n"
  usage+="  --rm                    remove previously built docker image\n"
  usage+="      --no-rm             (default)\n"
  usage+="  --bashrc-only           generate only the custom bashrc\n"
  usage+="      --no-bashrc-only    (default)\n"
  usage+="      -h, --help     display this help and exit\n"
  usage+="      -V, --version  output version information and exit\n"
  usage+="\nCopyright 2018-2024, Kolin Guo, All rights reserved.\n"

  echo -e "$usage"
}


parse_commandline()
{
  while test $# -gt 0
  do
    _key="$1"
    case "$_key" in
      -t|--tag)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_tag="$2"
        shift
        evaluate_strictness "$_key" "$_arg_tag"
        ;;
      --tag=*)
        _arg_tag="${_key##--tag=}"
        evaluate_strictness "$_key" "$_arg_tag"
        ;;
      -t*)
        _arg_tag="${_key##-t}"
        evaluate_strictness "$_key" "$_arg_tag"
        ;;
      -w|--work-dir)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_work_dir="$2"
        shift
        evaluate_strictness "$_key" "$_arg_work_dir"
        ;;
      --work-dir=*)
        _arg_work_dir="${_key##--work-dir=}"
        evaluate_strictness "$_key" "$_arg_work_dir"
        ;;
      -w*)
        _arg_work_dir="${_key##-w}"
        evaluate_strictness "$_key" "$_arg_work_dir"
        ;;
      -l|--no-build-local|--build-local)
        _arg_build_local="on"
        test "${1:0:5}" = "--no-" && _arg_build_local="off"
        ;;
      -l*)
        _arg_build_local="on"
        _next="${_key##-l}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-l" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -p|--no-push|--push)
        _arg_push="on"
        test "${1:0:5}" = "--no-" && _arg_push="off"
        ;;
      -p*)
        _arg_push="on"
        _next="${_key##-p}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-p" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -o|--no-build-only|--build-only)
        _arg_build_only="on"
        test "${1:0:5}" = "--no-" && _arg_build_only="off"
        ;;
      -o*)
        _arg_build_only="on"
        _next="${_key##-o}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          { begins_with_short_option "$_next" && shift && set -- "-o" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      --no-rm|--rm)
        _arg_rm="on"
        test "${1:0:5}" = "--no-" && _arg_rm="off"
        ;;
      --no-bashrc-only|--bashrc-only)
        _arg_bashrc_only="on"
        test "${1:0:5}" = "--no-" && _arg_bashrc_only="off"
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      -h*)
        print_help
        exit 0
        ;;
      -V|--version)
        echo -e "$(basename ${0}) ${VERSION}\n\nGeneric docker image/container setup script, adapted for ${REPO_NAME}\nCopyright 2018-2024, Kolin Guo, All rights reserved."
        exit 0
        ;;
      -V*)
        echo -e "$(basename ${0}) ${VERSION}\n\nGeneric docker image/container setup script, adapted for ${REPO_NAME}\nCopyright 2018-2024, Kolin Guo, All rights reserved."
        exit 0
        ;;
      *)
        _PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
        ;;
    esac
    shift
  done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

### Save the nice-looking usage ###
#print_help()
#{
#  local usage="Usage: $(basename ${0}) [-t <tag>] [-w <work-dir>] [OPTION]...\n"
#  usage+="Generic docker image/container setup script, adapted for ${REPO_NAME}\n\n"
#  usage+="  -t, --tag               image tag to use (default: '\e[1;32mlatest\e[0m')\n"  # ]]
#  usage+="  -w, --work-dir          working directory inside container (default: '\e[1;35m/${REPO_NAME}\e[0m')\n"  # ]]
#  usage+="                          mounts from '\e[1;32m${REPO_DIR}\e[0m'\n"  # ]]
#  usage+="  -l, --build-local       build docker image locally with Dockerfile\n"
#  usage+="      --no-build-local    pull image from remote registry (default)\n"
#  usage+="  -p, --push              upload image to remote registry after building\n"
#  usage+="      --no-push           (default)\n"
#  usage+="  -o, --build-only        build image and container only\n"
#  usage+="      --no-build-only     start and attach the container (default)\n"
#  usage+="  --rm                    remove previously built docker image\n"
#  usage+="      --no-rm             (default)\n"
#  usage+="  --bashrc-only           generate only the custom bashrc\n"
#  usage+="      --no-bashrc-only    (default)\n"
#  usage+="      -h, --help     display this help and exit\n"
#  usage+="      -V, --version  output version information and exit\n"
#  usage+="\nCopyright 2018-2024, Kolin Guo, All rights reserved.\n"
#
#  echo -e "$usage"
#}

# vvv  PLACE YOUR CODE HERE  vvv
############################################################
# Section 0.5: Bash Error Handling                         #
############################################################
# -e: exit immediately on non-zero status
# -E: trap on ERR is inherited by functions, command substitutions, and subshell envs
# -u: errors out when using an already unset variable ("unbound variable")
# -o pipefail: uses the status of last command with non-zero status as pipeline's status
set -eEu -o pipefail
trap 'catch' ERR  # Trap all errors (status != 0) and call catch()
catch() {
  local err="$?"
  local err_command="$BASH_COMMAND"
  set +xv  # disable trace printing

  echo -e "\nCaught error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]} ('${err_command}' exited with status ${err})" >&2
  echo "Traceback (most recent call last, command might not be complete):" >&2
  for ((i = 0; i < ${#FUNCNAME[@]} - 1; i++)); do
    local funcname="${FUNCNAME[$i]}"
    [ "$i" -eq "0" ] && funcname=$err_command
    echo -e "  ($i) ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]}\t'${funcname}'" >&2
  done
  exit "$err"
}

############################################################
# Section 1: Helper Function Definition                    #
############################################################
check_arg_compatibility() {
  if [ "$_arg_push" = "on" ] && [ "$_arg_build_local" = "off" ] ; then
    _PRINT_HELP=yes die "ERROR: cannot pull from remote and then push again" 3
  fi
}

print_setup_info() {
  local banner_len=80
  local ts="    "  # Tab spaces
  # Echo the set up information
  echo -e "\n\e[36m" && printf "%0.s#" $(seq 1 $banner_len) && echo -e "\n"  # ]
  echo -e "${ts}Docker Set Up Information\e[1m\n"  # ]

  echo -e "${ts}${ts}container: \e[35m${CONTNAME}\e[36m"  # ]]
  if [ "$_arg_build_local" = "on" ] ; then
    if [ "$_arg_push" = "on" ] ; then
      echo -ne "${ts}${ts}image \e[32m(push after built)\e[36m: "  # ]]
    else
      echo -ne "${ts}${ts}image: "
    fi
    echo -e "\e[35m${IMGNAME}\e[36m"  # ]]

    echo -e "${ts}${ts}Dockerfile: \e[35m${DOCKERFILEPATH}\e[36m"  # ]]
  else
    echo -e "${ts}${ts}Pull remote image: \e[35m${IMGNAME}\e[36m"  # ]]
  fi

  echo -e "${ts}${ts}Mounts '\e[32m${REPO_DIR}\e[36m' -> '\e[35m${_arg_work_dir}\e[36m'"  # ]]]]

  echo -e "\e[22;39m"  # ]
  if [ "$_arg_bashrc_only" = "on" ] ; then
    echo -e "${ts}${ts}* \e[33mOnly generate the custom bashrc\e[39m"  # ]]
  fi
  if [ "$_arg_build_only" = "on" ] ; then
    echo -e "${ts}${ts}* \e[33mDo not start and attach the docker container\e[39m"  # ]]
  fi
  if [ "$_arg_rm" = "on" ] ; then
    echo -e "${ts}${ts}* \e[1;31mCautious!! Remove previously built Docker image\e[22;39m"  # ]]
  else
    echo -e "${ts}${ts}* Keep previously built Docker image"
  fi
  echo -e "\e[36m" && printf "%0.s#" $(seq 1 $banner_len) && echo -e "\n\e[0m"  # ]]
}

remove_prev_docker_image() {
  # Remove previously built Docker image
  echo -e "\nRemoving previously built image..."
  docker rmi -f "$IMGNAME"
}

create_custom_bashrc() {
  cat > custom.bashrc <<- "EOF"

# Custom bashrc, modified from /etc/bash.bashrc on Ubuntu, appended to /root/.bashrc
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Change PS1 and terminal color
export PS1="\[\e[31m\]\u@${CONTNAME}-docker\[\e[0m\] \[\e[33m\]\w\[\e[0m\] > "  # match square bracket for argbash: ]]]]
export TERM=xterm-256color
alias grep="grep --color=auto"
alias ls="ls --color=auto"

# some more ls aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# >>> conda initialize >>>
export CONDA_AUTO_ACTIVATE_BASE=false
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
        . "/opt/conda/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/opt/conda/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Cyan color
echo -en "\e[1;36m"  # match square bracket for argbash: ]

# Printing useful commands for this container
print_useful_cmds() {
  local ts="    "  # Tab spaces
  # If any environment variable that starts with _CMD_
  if printenv | egrep -q "^_CMD_.+="; then
    echo -e ""
    echo -e "################################################################################\n"
    if [ ! -z "$_CMD_COMPILE" ] ; then
      echo -e "${ts}Command to compile:\n${ts}${ts}${_CMD_COMPILE}\n"
    fi
    if [ ! -z "$_CMD_RUN_JUPYTER" ] ; then
      echo -e "${ts}Command to run jupyter notebook:\n${ts}${ts}${_CMD_RUN_JUPYTER}\n"
    fi
    if [ ! -z "$_CMD_RUN_TENSORBOARD" ] ; then
      echo -e "${ts}Command to run TensorBoard:\n${ts}${ts}${_CMD_RUN_TENSORBOARD}\n"
    fi
    echo -e "################################################################################\n"
  fi
}
print_useful_cmds

# Turn off colors
echo -en "\e[0m"  # match square bracket for argbash: ]

EOF

  # Overwrite CONTNAME
  sed -i "s/\${CONTNAME}/${CONTNAME}/" custom.bashrc
}

update_port_forward() {
  # Temporarily turns off error handling in case there is no XXPORT variables
  set +e
  trap - ERR

  PORT_FORWARD_DOCKER_CMD=""

  # Iterate over all local variables with names ending in PORT
  while IFS= read -r line; do
    port_name="${line%=*}"
    port_num="${line#*=}"
    #echo "Line: ${port_name} ${port_num}"
    PORT_FORWARD_DOCKER_CMD+=" -p ${port_num}:${port_num} "

    # Update Dockerfile build-time variables
    DOCKER_BUILD_ARGS+=" --build-arg ${port_name}=\"${port_num}\" "
  done < <(set -o posix ; set | egrep -o "^.+PORT=.+$")

  trap 'catch' ERR  # Trap all errors (status != 0) and call catch()
  set -e
}

build_docker_image() {
  # Update WORKDIR
  DOCKER_BUILD_ARGS+=" --build-arg WORKDIR=${_arg_work_dir} "

  # Build and run the image
  echo -e "\nBuilding image '${IMGNAME}'..."
  docker build -f "$DOCKERFILEPATH" -t "$IMGNAME" $DOCKER_BUILD_ARGS --network=host .

  # Fetch /root/.bashrc from image, append custom.bashrc, and copy back into the image
  echo -e "\nAppend custom.bashrc to image '${IMGNAME}'..."
  local temp_cont_name="temp_${CONTNAME}"
  if [ 1 -eq $(docker container ls -a | grep -w "${temp_cont_name}$" | wc -l) ] ; then
    echo -e "\e[31mError: existing container '${temp_cont_name}' found, please remove it\e[0m" >&2  # ]]
    exit 1
  fi
  docker create --rm --name="$temp_cont_name" "$IMGNAME" /bin/bash
  docker cp "${temp_cont_name}:/root/.bashrc" root.bashrc
  cat custom.bashrc >> root.bashrc
  docker cp root.bashrc "${temp_cont_name}:/root/.bashrc"
  docker commit -m "Append custom.bashrc" "$temp_cont_name" "$IMGNAME"
  docker rm -f "$temp_cont_name"
  rm -rfv custom.bashrc root.bashrc
}

build_docker_container() {
  # Build a container from the image
  echo -e "\nRemoving older container ${CONTNAME}..."
  if [ 1 -eq $(docker container ls -a | grep -w "${CONTNAME}$" | wc -l) ] ; then
    docker rm -f "$CONTNAME"
  fi

  # References:
  #   https://docs.docker.com/engine/reference/commandline/create/
  #   https://docs.docker.com/engine/reference/run/
  # Create the container with following configs:
  #   Mount repo path
  #   Update timezone as host
  #   Run GUI applications within container
  #     GUI display size
  #       -e DISPLAY_WIDTH=3840 -e DISPLAY_HEIGHT=2160
  #   Disable MIT-SHM X11 extension for Qt applications
  #   GPU related
  #   Use host network and IPC namespace (shared memory segments)
  #   Port forwarding (only to prevent port clashing)
  #   give extended privileges to the container, potentially dangerous
  #   Add capability to perform a range of system administration operations
  echo -e "\nBuilding a container ${CONTNAME} from the image ${IMGNAME}..."
  docker create -it --name="$CONTNAME" \
    -v "$REPO_DIR":"$_arg_work_dir" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY="$DISPLAY" -e XAUTHORITY \
    -e QT_X11_NO_MITSHM=1 \
    --gpus all -e NVIDIA_DRIVER_CAPABILITIES=all \
    --net=host --ipc=host \
    $PORT_FORWARD_DOCKER_CMD \
    --privileged=true \
    --cap-add=CAP_SYS_ADMIN \
    "$IMGNAME" /bin/bash
}

start_docker_container() {
  docker start -ai "$CONTNAME"

  if [ 0 -eq $(docker container ls -a | grep -w "${CONTNAME}$" | wc -l) ] ; then
    >&2 echo -e "\nFailed to start/attach Docker container... Exiting...\n"
    exit 1
  fi
}

print_exit_command() {
  local banner_len=45
  local ts="    "  # Tab spaces
  # Echo command to start container
  echo -e "\n\e[36m" && printf "%0.s#" $(seq 1 $banner_len) && echo -e "\n"  # ]
  echo -e "${ts}Command to start Docker container:"
  echo -e "${ts}${ts}\e[1;32mdocker start -ai \e[35m${CONTNAME}\e[22;36m"  # ]]]
  echo -e "\e[36m" && printf "%0.s#" $(seq 1 $banner_len) && echo -e "\n\e[0m"  # ]]
}


############################################################
# Section 2: Call Helper Functions                         #
############################################################
# Checks on arguments
check_arg_compatibility  # check if arguments are compatible
IMGNAME="${IMGNAME/%IMG_TAG/$_arg_tag}"  # replace IMG_TAG

print_setup_info  # print the setup info
print_help  # print usage of the script

echo -e ".......... Set up will start in 5 seconds .........."
sleep 5

if [ "$_arg_bashrc_only" = "on" ] ; then
  create_custom_bashrc
  exit 0
fi

if [ "$_arg_rm" = "on" ] ; then
  remove_prev_docker_image
fi

### Build/Pull docker image ###
DOCKER_BUILD_ARGS=""
update_port_forward

if [ "$_arg_build_local" = "on" ] ; then
  create_custom_bashrc
  build_docker_image
else
  docker pull "$IMGNAME"
fi

if [ "$_arg_push" = "on" ] ; then
  docker push "$IMGNAME"
fi

build_docker_container
if [ "$_arg_build_only" = "off" ] ; then
  start_docker_container
fi

print_exit_command  # after exit from docker container

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
