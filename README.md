# Media Download and Organization Automation

## Overview

Two Bash scripts developed to download media using `yt-dlp` and organize downloaded files on a Linux-mounted SMB share.

The workflow combines command-line downloading with an interactive file organization interface. Users can select downloaded files, create hard links in multiple directories, and optionally remove the original directory entries.

## Scripts

### 1. `01_yt.sh` — Media Download

- Executes `yt-dlp` with user-provided arguments.
- Saves downloaded files to the configured SMB share directory.
- Prompts the user to organize downloaded files after downloading.
- Launches the second script if the user chooses to proceed.

### 2. `02_org.sh` — Interactive File Organization

- Displays a numbered list of files available for organization.
- Allows users to select one or multiple files.
- Displays available destination directories.
- Creates hard links to selected files in one or multiple directories.
- Prompts users to confirm whether additional links are needed.
- Offers the option to remove the original directory entry.
- Records file organization and removal operations in a log.

## Requirements

- Linux with Bash
- `yt-dlp`
- Standard Linux utilities including `find`, `sed`, `gawk`, `nl`, and `coreutils`
- Access to a mounted SMB share with suitable file permissions
- Filesystem support for hard links

The scripts expect the SMB share to be mounted at:

```bash
${HOME}/smb/${USER}
```

This location can be changed by modifying `base_dir` in both scripts.

The `yt-dlp` executable is expected at `${base_dir}/yt-dlp`, and the second script at `${base_dir}/scripts/02_org.sh`.

## Usage

Run `01_yt.sh` with the desired `yt-dlp` arguments:

```bash
bash 01_yt.sh "MEDIA_URL"
```

After downloading, the script asks whether to organize files.

If the user selects `y`, the interactive organization script launches. Files and destination directories are selected by entering their corresponding numbers.

`02_org.sh` can also be run independently.

## Important Notes

- Hard links generally require the source and destination to be on the same filesystem and must be supported by the underlying filesystem.
- The organization script requires user interaction and confirmation.
- Removing the original directory entry does not delete the file's data if another hard link remains.
- Users should verify that links were successfully created before removing original directory entries.
- The scripts were developed for a specific personal file-management workflow rather than general-purpose deployment.