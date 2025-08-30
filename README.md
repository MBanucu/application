# setup
## install nix-shell

Install `nix-shell` on Linux by installing the Nix package manager, as `nix-shell` is a component of Nix. Here’s a concise guide to get you started:

1. **Install Nix Package Manager**:
   - Open a terminal and run the following command to install Nix in single-user mode:
     ```bash
     sh <(curl -L https://nixos.org/nix/install) --no-daemon
     ```
   - For multi-user mode (recommended for shared systems), use:
     ```bash
     sh <(curl -L https://nixos.org/nix/install) --daemon
     ```
   - Follow the on-screen instructions. This installs Nix and its tools, including `nix-shell`.

2. **Verify Installation**:
   - After installation, source the Nix profile to update your environment:
     ```bash
     source ~/.nix-profile/etc/profile.d/nix.sh
     ```
   - Check if `nix-shell` is available:
     ```bash
     nix-shell --version
     ```

3. **Using nix-shell**:
   - You can now use `nix-shell` to create isolated environments. For example, to start a shell with a specific package (e.g., Python):
     ```bash
     nix-shell -p python3
     ```

**Notes**:
- Nix works on most Linux distributions (e.g., Ubuntu, Fedora, Arch).
- You may need `curl` or `wget` installed to download the installer.
- If you encounter issues, ensure your user has appropriate permissions, or check the official Nix documentation for troubleshooting.

For more details, visit the [Nix installation guide](https://nixos.org/download.html). If you have a specific Linux distro or use case, let me know, and I can tailor the instructions!

## run setup script
```bash
git clone https://github.com/MBanucu/application-setup.git
cd application-setup
nix-shell --command "./newApplication.sh"
```
The script automatically clones a new copy of this repository so you should not clone this repository yourself.

# build with VS Code
only works after running setup script

ctrl+shift+B

# location of build result files
[Bewerbung/build/](Bewerbung/build/)