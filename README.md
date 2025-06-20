            Tholos embeds executable modules in iterative languages, creating portable Go modules and compiled binaries

    Usage:      $ cat Bonjour.py 
                #!/usr/bin/env python
                print("Coucou")
                    $ thol Bonjour.py --quiet
                $ ./Bonjour.py.bin  <<<    The active version of python is included in the binary. This can be moved anywhere, but if the python uses imports the new system will need to have those imports as well
                Coucou

                $ ./port thol --link
                $ thol wunder --quiet; ls . | grep wunder
                wunder              <<<    Keep if you're importing the .go module
                wunder.go           <<<    Keep if you're importing into a larger go binary
                wunder.bin          <<<    Keep if you want the script as a standalone binary
                                           This has advantages for security and portability, and the bin
                                           resists mutation. For standalones the executable can be large
                                           unless the embedded libraries are removed

                                           TODO: --thin flag to avoid embedding redundant libraries




    Notes:

    Once generated the binary is fully standalone, whereas the .go can be integrated into larger binaries
        The .go file depends on the /.lib folder that gets created, but the compiler embeds it in the bin
        This utility is language agnostic, automatically embedding the interpreter stated in the schebang
        or indicated by a recognized file extension. The interpreters are automatically hard coded with a
        set of command and environment arguments required by Tholos to execute them reliably


    There are two outputs: the compiled .bin executable which is compiled as a fully embedded binary, and
        the editable .go which the .bin is compiled from. All of the embedded files the go uses is in the
        .lib folder which is shared for all compiled go outputs in the same directory. So if they are all
        in the same folder and then included in the same golang compile, the embed would only include one
        version of the interpreter for all of them. The resulting large binary may then be able to access
        the embedded files and their interpreters


    Tholos can now be used for build files, embedding make ninja and meson. It uses the schebang like for
        everything else, so as long as it starts with "#!/usr/bin/env make|ninja|meson", it can be turned
        into a thol module and executed like any other file. Note ninja and meson support zero copy embed
        but make requires the tmpfs file to be written. This shouldn't affect anything but ninja+meson is
        still a natural fit
            These build methods would allow for dynamic executable builds, simplifying deployment, making
            metaprogramming versatile and accessible invocable where shell and scripting is not available

            Tholos is inherently immutable once compiled so the build instruct is also difficult to alter
            without changing the binary itself. If imported into a larger project binary, the application
            would then have a tamper resistant means of distributed self installation

            This also puts all in place for standardized extraction methods for git, since you could just
            type "git clone my/project; ~/project/install.bin" instead of figuring out which build method
            was used for the project and hoping that it works


    Tholos can be used with ansible and terraform to create scripts in an executable format if they start
        with the valid schebang. Further usage is straightforward, and identical to terraform and ansible
        run normally using the cli commands. You can adjust run flags altering the .go file, but it needs
        to execute on its own without user interactions. The -auto-approve flag in terraform is therefore
        non optional but everything else is adjustable with the parts = append(parts, "<arg>") line
            The resulting terraform binaries are confirmed to function even on systems where terraform is
            not installed, that much is completely portable and should work on any system where

            Refer to the included script examples for minimal forms of each. Be aware that the embed size
            of these are larger than other interpreters. It is still viable for in house distribution but
            transferring them over nat may run into limits


    Now also able to create lualatex embeds. Name the file .tex, or include #!/usr/bin/env lualatex, then
        valid lua to create automated latex generation. If incorporated into scientific applications this
        could create a powerful way to generate latex documentation. If placed imported by a go layer, it
        would be able to document all the data passing through it into latex. 
            Notably, the luatex binary module is 8MB, compared to hundreds of MB for other latex installs
            and I measured it at ~19MS compared to 100-200MS for other latex solutions, and Tholos shares
            interpreters if multiples are imported in the same go binary. This makes Tholatex potentially
            viable for integrating across an architecture to generate standardized human readable reports
            and logging, particularly in self auditing systems 


    Tholos is now able to process jupyter notebooks. This is of course unable to facilitate live edits as
        the binary is immutable, rather the thol jupyter notebook is able to concretize and execute logic
        placed into the notebook in the precise state that the original author created it. The recipients
        do not require any particular jupyter version, or to have jupyter at all, to execute the embedded
        jupyter binary so any notebooks embedded this way should be reproducible on any machine. The thol
        jupyter runs entirely from stdin without touching memory. This is particularly valuable for julia
        workflows, where JIT can be fully leveraged 


    Only the interpreter is saved to the memory filesystem, the embedded file itself is then loaded into
        the interpreter directly. For most languages, thol follows a zero copy pattern where the scripts
        are passed into the buffer, but for certain languages (rust) this does not appear to be feasible
        so they use a written copy of the code instead which is discarded after execution by default
            When a file is written, it uses the same logic as the interpreter files, avoiding collisions
            by occupying a namespace derived from the current environment and namespace. Thus, two users
            or containers both using the same thol on the same machine have their own copies of any file
            created by the module. If you find folders with very long random names full of libraries and
            a bash executable, this is why


    For developers, there are some functions sealMake() and sealBreak() which creates a scoped nonce and
        destroys the it afterwards. The key is hard coded into the binary and is generated at build time
        (but not compile time unless you regenerate the module). The nonce is created when the module is
        invoked and then is discarded when used. This can be used to encrypt and decrypt files the embed
        creates. If you really need to decrypt multiple files, you'll need to shadow the nonce before it
        is discarded following sealBreak()
            By default the encryption is only for obfuscation, if you want proper security you can add a
            tpm using the commented out sealKey function. Otherwise the key cannot be securely stored in
            a module. Set the hexKey variable to an external key to secure the system


    Note that the binaries are typically fully portable and can run on systems where no interpreters are
        available or installed. The exception is if the binaries references external libraries, in which
        case it uses the system libraries when compiled as well. For such files the recommended approach
        is to use miniforge and mamba to provide the binaries, and then reference the environment in the
        application. This way the plugins can receive updates without recompiling the binaries, which is
        preferable for any high stakes system. Python and rust are both chronic offenders but these work
        well with anaconda. Full containerization is also possible but renders Tholos partially obsolete
            This is so that the plugins can still receive regular security updates. If a built thol file
            is created which depends on external libraries those other libraries should be considered as
            dependencies of the go project the Tholos module is used in. This may not be fully reflected
            in dependency managers so specific care must be taken in complex setups i.e. using miniforge


    Supported languages
        bash
        python
        rust      (via rust-script)
        perl
        R
        javascript
        ruby
        php
        lua
        luatex
        scala
        deno
        matlab    (via octave)
        wolfram
        tcl
        rexx
        scheme    (via racket)
        haskell   (via runghc) 


    Note that in the .engines folder there is an included port utility which creates fully isolated conda
    environments in that folder. This could be used to create a static copy of any package in conda-forge
    and it will create a usable set of libraries completely independent of the system environment. It can
    also be used to select the correct interpreter among the built environments, useful for automation


Developed using the following:
    go version go1.23.9 linux/amd64
    6.14.6-200.fc41.x86_64
        fedora 41, current release


If this code is used in a publication or in a system which is used in a publication, please cite the following:
    **Buerer, Daniel** (2025). *Tholos* (Version 2.1.1) [Computer software].
    https://doi.org/10.5281/zenodo.15350673
or reference the citation.cff for standard format information
