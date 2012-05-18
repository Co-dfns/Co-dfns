BEGIN { SMAKE = "make" } {
  if ($1 !~ /^#/ &&  NF > 2) {
    printf "cd `echo %s|tr '[a-z]' '[A-Z]'`; %s clean;", $1, SMAKE;
    printf "%s CLASS=%s NPROCS=%s", SMAKE, $2, $3;
    if ( NF > 3 ) {
      if ( $4 ~ /^vec/ ||  $4 ~ /^VEC/ ) {
        printf " VERSION=%s", $4;
        if ( NF > 4 ) {
          printf " SUBTYPE=%s", $5;
        }
      } else {
        printf " SUBTYPE=%s", $4;
        if ( NF > 4 ) {
          printf " VERSION=%s", $5;
        }
      }
    }
    printf "; cd ..\n";
  }
}
