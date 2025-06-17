# MongoDB Ops Manager Auto-Installer

A simple shell script to automatically install MongoDB Ops Manager and AppDB as standalones on a Linux machine.

---

## Overview

This tool simplifies the installation of MongoDB Ops Manager and AppDB to help you quickly set up a development environment. Specify your desired Ops Manager version in the `init.sh` file, and the script will handle the download, setup, and installation steps for you.

**⚠️ This script is intended for DEV environments only and comes with no guarantees. Use at your own risk. The script has only been tested on RHEL 9. Please ensure you abide by MongoDB licensing.**

---

## Features

- Automated download and installation of both Ops Manager and AppDB
- Simple configuration—just select your version and run!
- Logging of installation steps (`.main.log`)
- Designed for development/testing purposes

---

## Getting Started

### Prerequisites

- Linux machine (Tested on **RHEL 9**)
- Bash shell
- Internet connection

### Installation & Usage

1. **Clone this repository** (if you haven’t already):
    ```bash
    git clone <repo-url>
    cd <repo-dir>
    ```

2. **Set the Ops Manager version**  
   Edit the `init.sh` file and set your desired version:
    ```sh
    # Inside init.sh
     om_version="7.0.9"  # <-- set your version here
    ```

3. **Run the installer:**
    ```bash
    ./main.sh
    ```

4. **Logs:**  
   Find installation logs in `./.main.log`.

---

## Notes & Warnings

- **Only use in dev environments.**  
  This script is not recommended for production use.
- **Supported only on RHEL 9** (other distributions may not work)
- **License:**  
  Make sure you comply with [MongoDB’s licensing](https://www.mongodb.com/licensing).
- **AppDB and Ops Manager run as standalone instances.**

---

## License

This project is provided “AS-IS” for development purposes only.  
See [MongoDB’s Software EULA](https://www.mongodb.com/legal/software-eula).

---

## Support & Contact

If you have questions or suggestions, please open an issue in the repository.