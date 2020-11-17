#Installation location
# export TP_TOP=$(pwd)
export TP_TOP="/media/user/TPSoC_Resources/TPSoC_3A_New"
export RISCV="$TP_TOP/riscv"
# echo "Initiated RISCV variable"
# echo $RISCV

#Top level rocket-chip repository
#export TOP="path/to/rocket-chip"

#So we can use the toolchain easily
export PATH=$PATH:$RISCV/bin
# echo "Added RISC-V toolchain to PATH."

export MAKEFLAGS="$MAKEFLAGS -j4"
export PATH=$PATH:$RISCV/bin
alias goto_tp="cd $TP_TOP && source sourceme"