#!/bin/bash
# Description: Wrapper for yt-dlp to download media directly to the Samba share and trigger interactive organization.

base_dir="${HOME}/smb/${USER}"

if ! "${base_dir}/yt-dlp" -P "${base_dir}" "$@"; then
    echo "The yt-dlp command failed."
    exit 1
fi

echo -e "The following have been downloaded to ${base_dir}:\n\n\"$@\".\n\nDo you wish to organize these downloads now? Enter 'y' for yes or any other key for no."

read

case $REPLY in
y | Y) . "${base_dir}/scripts/02_org.sh" ;;
*) exit ;;
esac

exit