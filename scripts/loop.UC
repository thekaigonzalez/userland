printf("Version: %s\n", __version);
Print("welcome to userland");

char* n = Malloc(11);

n[0] = 'h';
n[1] = 'e';
n[2] = 'l';
n[3] = 'l';
n[4] = 'o';
n[5] = ' ';
n[6] = 'w';
n[7] = 'o';
n[8] = 'r';
n[9] = 'l';
n[10] = 'd';
n[11] = '\0';

Print(n);

Free(n);
