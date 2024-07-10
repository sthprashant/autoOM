## TO Dos for the app:

### Overview

| Task                                                            | Status |
| --------------------------------------------------------------- | ------ |
| Get version and platform from the user                          | ⌛     |
| scrape the download URL based on the version and platform       | ✅     |
| use the scraped download link to download the installation file | ✅     |
| Install mongodb enterprise                                      | ⌛     |
| Configure and run mongodb enterprise                            |        |
| Configure Ops Manager                                           |        |
| Install Ops Manager                                             |        |
| Start Ops Manager                                               |        |
|                                                                 |        |

### Backlog

- Verify host resource (memory, disk, cpu etc)
- automatically detect platform
- Offline installation, where users can manually provide the download link or path for the installation file on the host
- upgrade ops manager
- make downloads asynchronous, potentially using `&`
- Cache downloaded/scraped data
- dockerize it
