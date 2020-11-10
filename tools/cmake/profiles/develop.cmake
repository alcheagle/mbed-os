# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

# Sets profile options
function(mbed_set_profile_options target mbed_toolchain)
    list(APPEND link_options)

    if(${mbed_toolchain} STREQUAL "GCC_ARM")
        list(APPEND c_compile_options
            "-c"
            "-Os"
        )
        target_compile_options(${target}
            INTERFACE
                $<$<COMPILE_LANGUAGE:C>:${c_compile_options}>
        )

        list(APPEND cxx_compile_options
            "-fno-rtti"
            "-Wvla"
            "-Os"
        )
        target_compile_options(${target}
            INTERFACE
                $<$<COMPILE_LANGUAGE:CXX>:${cxx_compile_options}>
        )

        list(APPEND asm_compile_options
            "-x" "assembler-with-cpp"
        )
        target_compile_options(${target}
            INTERFACE
                $<$<COMPILE_LANGUAGE:ASM>:${asm_compile_options}>
        )

        list(APPEND link_options
            "-Wl,--gc-sections"
            "-Wl,--wrap,main"
            "-Wl,--wrap,_malloc_r"
            "-Wl,--wrap,_free_r"
            "-Wl,--wrap,_realloc_r"
            "-Wl,--wrap,_memalign_r"
            "-Wl,--wrap,_calloc_r"
            "-Wl,--wrap,exit"
            "-Wl,--wrap,atexit"
            "-Wl,-n"
        )
    elseif(${mbed_toolchain} STREQUAL "ARM")
        list(APPEND c_compile_options
            "-Os"
        )
        target_compile_options(${target}
            INTERFACE
                $<$<COMPILE_LANGUAGE:C>:${c_compile_options}>
        )

        list(APPEND cxx_compile_options
            "-fno-rtti"
            "-fno-c++-static-destructors"
            "-Os"
        )
        target_compile_options(${target}
            INTERFACE
                $<$<COMPILE_LANGUAGE:CXX>:${cxx_compile_options}>
        )

        list(APPEND link_options
            "--show_full_path"
            "--legacyalign"
            "--inline"
            "--any_contingency"
            "--keep=os_cb_sections"
        )

        target_compile_definitions(${target}
            INTERFACE
                __ASSERT_MSG
        )
    endif()

    target_compile_definitions(${target}
        INTERFACE
            MBED_TRAP_ERRORS_ENABLED=1
    )

    target_link_options(${target}
        INTERFACE
            ${link_options}
    )
endfunction()
