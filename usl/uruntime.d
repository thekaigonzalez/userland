module usl.uruntime;

import usl.usl_type;

import core.stdc.stdio : printf;
import core.stdc.string : strcat;

extern (C) I32 Print(UStr STR) {
  printf("%s\n", STR);
  return 0;
}
