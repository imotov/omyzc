OS=$(uname)

if [[ $OS == "Darwin" ]]; then
    PATH=$PATH:$HOME/.local/bin
        
    # Load SSH keys from macOS keychain
    ssh-add --apple-load-keychain -q

    # Setup homebrew
    if [ -s "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export HOMEBREW_NO_ENV_HINTS=true
    fi

    # Setup node.js virtual environment manager
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    fi

    # Setup pyenv
    if [ -d "$HOME/.pyenv" ]; then
        PYENV_ROOT="$HOME/.pyenv"
        PATH="$PYENV_ROOT/bin:$PATH"
        if command -v pyenv 1>/dev/null 2>&1; then
            eval "$(pyenv init -)"
            eval "$(pyenv virtualenv-init -)"
            # Ensure that pip can only install to virtualenv's make gpip a workaround
            export PYENV_VIRTUALENV_DISABLE_PROMPT=1
            export PIP_REQUIRE_VIRTUALENV=true
            gpip() {
                PIP_REQUIRE_VIRTUALENV="" pip "$@"
            }
            export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
        fi
    fi

    # Setup command line utilities for VS Code
    if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
        export PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fi

    if [ -s "/opt/homebrew/opt/chruby/share/chruby/chruby.sh" ]; then
        source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
        source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    fi

    if /usr/libexec/java_home 1>/dev/null 2>&1; then
        export JAVA_HOME=`/usr/libexec/java_home -v21`
        export ES_JAVA_HOME="$JAVA_HOME"
    fi

    if [ -d "/Applications/IntelliJ IDEA CE.app/Contents/MacOS" ]; then
        export PATH=$PATH:"/Applications/IntelliJ IDEA CE.app/Contents/MacOS"
    fi

    # Setup rustup
    if [ -s "$HOME/.cargo/bin" ]; then
        export PATH="$PATH:$HOME/.cargo/bin"
    fi

fi
