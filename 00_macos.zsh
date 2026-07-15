OS=$(uname)

if [[ $OS == "Darwin" ]]; then
    PATH=$PATH:$HOME/.local/bin

    # Setup command line utilities for VS Code
    if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
        export PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fi

    if /usr/libexec/java_home 1>/dev/null 2>&1; then
        export JAVA_HOME=`/usr/libexec/java_home -v21`
        export ES_JAVA_HOME="$JAVA_HOME"
    fi

    if [ -d "/Applications/IntelliJ IDEA CE.app/Contents/MacOS" ]; then
        export PATH=$PATH:"/Applications/IntelliJ IDEA CE.app/Contents/MacOS"
    fi

fi
