
# Ubuntu 16.04 Visual Customizations #

---

*   **Unit GTK3 Theme:** [Arc Theme Red Dark](https://github.com/mclmza/arc-theme-Red)

*   **Icon Set:** [numix round free](https://github.com/numixproject/numix-icon-theme)


*   **Terminal Profile Colors** (attempted match to GTK3 theme):

    *   Executables / Binaries: `57CC8C` - Green
    *   Directories: `5798CC` - Blue
    *   User-name & Current Working Directory: `DC322F` - Red
    *   Terminal Prompt / Carat: `C657CC` - Purple


![Colors][ColorPalleteA]

![Colors][ColorPalleteB]

---

*   **~/.bashrc $PS1 Definition:**

`PS1='\[\e[1;38;5;203m\]\u\[\e[0m\]\[\e[0;37m\]@\h\[\e[0m\]\[\e[00;37m\]:\[\e[0;38;5;203m\]\w \[\e[0m\]\[\e[01;37m\]\n$>\[\e[0m\]'`


![Screenshot][Desktop]


---

*   **Other**

    *   **Pretty Gitlog Graph Output (`~/.bash_aliases`)**

        *   `ghist="git log --pretty=format:\\ \"%C(bold red)%h%Creset %C(cyan)|%Creset %ad%Cgreen(%ar)%Creset %C(cyan)|%Creset %s%C(yellow)%d%Creset %Cblue[%an]%Creset\\ \" --graph --date=short"`

    *   **Pretty Gitlog Inline Output(`~/.bash_aliases`)**

        *   `gipl="git log --pretty=format:\"%Cred%h%Creset -%C(yellow)%an%Creset %Cgreen(%ar)%Creset: %s\" "`


---

[Desktop]: ./Images/Customizations.png
[ColorPalleteA]: ./Images/ColorPaletteA.png
[ColorPalleteB]: ./Images/ColorPaletteB.png