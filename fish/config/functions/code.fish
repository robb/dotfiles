function code -d "Open Visual Studio Code"
  set -l files
  set -l opts
  set -l projects

  # We'll just ignore anything that looks like an option string...
  for file in $argv
    switch $file
      case '-*'
        set opts $opts $file

      case '.*' '*'
        set files $files $file
    end
  end

  # If there's one (and only one) *.code-workspace file in the folder listed,
  # open that instead.
  if [ (count $files) -eq 1 ]
    set projects (find $files[1] -name "*.code-workspace" -maxdepth 1 2> /dev/null)
  end

  if [ (count $projects) -eq 1 ]
    set argv $opts $projects[1]
  end

  if set -e CODE_PATH
    eval $CODE_PATH $argv
  else if begin; which code > /dev/null 2>&1; and test -x (which code); end
    command code $argv
  else if test -d "/Applications/Visual Studio Code.app"
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" $argv
  else
    echo 'No Visual Studio Code installation found' >&2
    echo 'Add `code` to your $PATH or set $CODE_PATH' >&2
    return 1
  end
end
