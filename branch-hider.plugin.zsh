alias hb='hide_branch'
alias sb='show_branch'
alias gb-shown='show_branches_minus_hidden'
alias gb-all='git branch'

CREATE=`cat create_table.sql`
GET_HIDDEN=`cat get_hidden_branches.sql`
TABLE_PATH="/tmp/hidden_branches"

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
  local IFS="\n"
  hidden_branches=$(sqlite3 $TABLE_PATH $GET_HIDDEN)
  eval "hidden_branches=($hidden_branches)"
}

get_branch_list() {
  local IFS="\n"
  branches=$(git for-each-ref --shell --format='%(refname:short)' refs/heads/)
  eval "branches=($branches)"
}

hide_branch() {
  sqlite3 $TABLE_PATH $CREATE;
  sqlite3 $TABLE_PATH "insert into hidden_branches values('$1')"
}

show_branch() {
  sqlite3 $TABLE_PATH "delete from hidden_branches where branch_name='$1'"
}

get_current_branch() { 
  cur_branch=$(git symbolic-ref -q HEAD --short)
}
