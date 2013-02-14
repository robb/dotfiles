alias edit='open -e'
alias ll='ls -halF'

function gitrepo {
  echo "Enter GitHub password for jaydee3:"
  read -s pw

  if (( $# == 0 ))
  then
    echo "Enter the new repository name:"
    read repo
  else
    repo=$1
  fi

  echo "Creating Repository '${repo}'"
  echo "https://api.github.com/user/repos -d '{\"name\":\"${repo}\"}'"

  curl -u "jaydee3:${pw}" https://api.github.com/user/repos -d "{\"name\":\"${repo}\"}"

  echo "\n\nRepository '${repo}' created!"

  echo "Init local repository in current directory? (y/n)"
  read localRepo

  if [ "$localRepo" = "y" ] || [ "$localRepo" = "yes" ];
  then
    echo "Initalizing local repository..."
    git init
    git remote add origin git@github.com:jaydee3/${repo}
  fi
}
