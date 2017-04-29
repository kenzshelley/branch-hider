

CAT IS POOP HEAD

show_branches_minus_hidden() {
  sqlite3 branches < create_table.sql;


  get_branch_list;
  echo $branches;

}

get_hidden_branch_list() {
  
}

get_branch_list() {
  branches=$(git for-each-ref --shell --format='%(refname:short)' refs/heads/)
}
