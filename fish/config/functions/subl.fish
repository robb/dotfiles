function subl -d "Open Sublime Text, preferring project/workspace files in a folder"
  set -l files
  set -l opts
  set -l projects

  for file in $argv
    switch $file
      case '-*'
        set opts $opts $file

      case '.*' '*'
        set files $files $file
    end
  end

  if [ (count $files) -eq 1 ]; and test -d $files[1]
    set projects (find $files[1] -maxdepth 1 -name "*.sublime-project" 2> /dev/null)

    if [ (count $projects) -eq 0 ]
      set projects (find $files[1] -maxdepth 1 -name "*.sublime-workspace" 2> /dev/null)
    end
  end

  if [ (count $projects) -eq 1 ]
    set argv $opts $projects[1]
  end

  if set -q SUBL_PATH
    eval $SUBL_PATH $argv
  else if command -q subl
    command subl $argv
  else if test -d "/Applications/Sublime Text.app"
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $argv
  else
    echo 'No Sublime Text installation found' >&2
    echo 'Add `subl` to your $PATH or set $SUBL_PATH' >&2
    return 1
  end
end
