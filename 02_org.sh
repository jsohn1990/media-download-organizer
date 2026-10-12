#!/bin/bash
# Description: Interactive CLI menu for sorting, linking, and managing files directly in the Samba share.

base_dir="${HOME}/smb/${USER}"
log="${base_dir}/log_yt/log.txt"

i=0
while [ $i -eq 0 ]
do

  echo -e "\nSelect file(s) to link by entering the number(s) to the left of the files listed below. If more than one file should be linked, enter each number while separating by space. To cancel operation of this script, enter 'c'. Press 'Enter' when finished.\n"
  find_cmd_files=$(find "${base_dir}" -maxdepth 1 -type f -print | sed -n '/\.sh$/!p'| sed "s#${base_dir}#...#g"| nl)
  echo -e "${find_cmd_files}\n"
  
  read -p "Enter here:" -a file_reply
  
  case "$file_reply" in
    c | C) echo "Exiting script" ; exit ;;
  esac
  
  for selected_file_num in "${file_reply[@]}"
  do
    find_cmd_files_pipe=$(find "${base_dir}" -maxdepth 1 -type f -print | sed -n '/\.sh$/!p'| nl | sed "s#${HOME}#|${HOME}#")
    selected_file=$(echo "$find_cmd_files_pipe" | sed -n "${selected_file_num}p" | gawk -F'|' '{print $2}')
	selected_file_basename=$(echo "$selected_file" | gawk -F/ '{print $NF}')
	max_value_file=$(echo "$find_cmd_files_pipe" | wc -l)
	
	if [ $selected_file_num -le $max_value_file ]; then
	  i=0
      while [ $i -eq 0 ]
	  do
	    echo -e "Select to where \"$selected_file_basename\" should be linked by entering the number(s) to the left of the sub-directories listed below of ${base_dir}. If to more than one sub-directory, enter each number and separate by space. Press 'Enter' when finished.\n"
	
	    find_cmd_dirs=$(find "${base_dir}" -type d -print | sed -n '\|^'${base_dir}'/shortcut_files|!p' | sort | sed -n '1!p'| nl | sed "s#${HOME}#|${HOME}#")
		max_value_dirs=$(echo "$find_cmd_dirs" | wc -l)
	    echo -e "${find_cmd_dirs}\n" | sed "s#|${base_dir}##"
	
	    read -p "Enter here:" -a dir_reply
	    
		for selected_dir_num in "${dir_reply[@]}"
	    do
		  if [ $selected_dir_num -le $max_value_dirs ]; then
	        selected_dir=$(echo "$find_cmd_dirs" | sed -n "${selected_dir_num}p" | gawk -F'|' '{print $2}')
		    ln "$selected_file" "$selected_dir"
	        if ln "$selected_file" "$selected_dir"; then
              echo -e "\n${selected_file_basename} linked to $selected_dir on $(date)" | tee -a "$log"
            fi
		  else
			echo -e "\n\"${selected_dir_num}\" is not a valid entry. This script proceeds to link selected file to any other directories that were selected.\n"
		  fi
	    done
	    	  
	    echo -e "\nHas \"$selected_file_basename\" been linked to all appropriate directories? Type 'y' if yes or 'n' if no, and then press 'Enter'.\n"
	    read -p "Enter here:"
		  case $REPLY in
		    y | Y) i=1 ;;
		    n | N) i=0 ;;
		    *) i=1
		       echo -e "\nInvalid response, \"$selected_file_basename\" will not be linked to any other directory now.\n" ;;
		  esac
      done
	else
	  echo -e "\n\"${selected_file_num}\" is not a valid entry.\n"
	fi

  echo -e "\nShould \"$selected_file_basename\" be removed from the shared directory now? Type 'y' if yes or 'n' if no, and then press 'Enter'.\n"
  read -p "Enter here:"
    case $REPLY in
	  y | Y) rm "$selected_file" && echo -e "\"$selected_file_basename\" removed from shared directory.\n" | tee -a "$log" ;;
	  n | N) echo -e "\"$selected_file_basename\" will not be removed now.\n" ;;
	  *) echo -e "\nInvalid response, \"$selected_file_basename\" will not be removed now.\n" ;;
	esac

  done

echo -e "Are you finished linking files? Type 'y' if yes or 'n' if no (or if you're not sure). Press 'Enter' when finished.\n"
read -p "Enter here:"
case $REPLY in
  y | Y) i=1 ;;
  n | N) i=0 ;;
  *) i=1
     echo -e "\nInvalid response, re-run this script if necessary, and see \"$log\" for actions previously run using this script\n" ;;
esac

done

echo -e "\nThis script exits. See \"$log\" for actions run using this script."
exit