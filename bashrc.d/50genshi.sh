alias genshi-last-log="ls -t ~/.config/Gentuity/GenshiUI/Logs/log_*.txt | head -n 1"
alias genshi-tail-log='tail -f $(genshi-last-log)'
alias genshi-less-log='less -R $(genshi-last-log)'
alias genshi-clean-log='sed -i -E "/ Async msg |  Async Message | :  Message: | :  RCVD | :  SEND |Stepper Message: |Feeding [0-9]\+ watchdogs| ThorlabsLaserSource::read|ThorlabsLaserSource::checkStatus|QQmlExpression: Expression .* depends on non-NOTIFYable properties| warning \|     .+::.+/d"'

# From: https://unix.stackexchange.com/a/111936/24196
alias stripcolors='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'

genshi-env() {
    export PATH=/opt/ninja-1.9.0:/opt/cmake-3.17.1-Linux-x86_64/bin:/usr/local/cuda-10.0/bin:/opt/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04/bin:${PATH}
}

