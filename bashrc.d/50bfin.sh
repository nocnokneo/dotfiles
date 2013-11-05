# Disable the GDB startup banner for all gdb toolchain versions
for target in elf uclinux linux-uclibc; do
    if type bfin-${target}-gdb &>/dev/null; then
        alias bfin-${target}-gdb="bfin-${target}-gdb -quiet"
    fi
done
unset target
