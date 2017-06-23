alias hb='hide_branch'
alias sb='show_branch'
alias gb='show_branches_minus_hidden'
alias gba='git branch'

show_branches_minus_hidden() {
  get_hidden_branch_list;
  get_branch_list;
  get_current_branch;

  for branch in $branches; do
    if [[ ${hidden_branches[(r)$branch]} == $branch ]] ;
    then ;
    else ;
      if [[ $branch == $cur_branch ]] ;
      then ;
        echo "* "$branch
      else ;
        echo "  "$branch
      fi
    fi
  done 
}

get_hidden_branch_list() {
  IFS="\n"
  hidden_branches=$(sqlite3 branches < get_hidden_branches.sql)
  eval "hidden_branches=($hidden_branches)"
  IFS=""
}

get_branch_list() {
  IFS="\n"
  branches=$(git for-each-ref --shell --format='%(refname:short)' refs/heads/)
  eval "branches=($branches)"
  IFS=""
}

hide_branch() {
  sqlite3 branches < create_table.sql;
  sqlite3 branches "insert into hidden_branches values('$1')"
}

show_branch() {
  sqlite3 branches "delete from hidden_branches where branch_name='$1'"
}

get_current_branch() { 
  cur_branch=$(git symbolic-ref -q HEAD --short)
}
