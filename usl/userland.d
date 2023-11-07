/*Copyright 2019-2023 Kai D. Gonzalez*/

// handle .UD, .UDX, .UC, and .UL

import std.stdio : writefln, writeln, File, stdout, stdin;
import std.file : dirEntries, DirEntry, SpanMode;
import std.path :  baseName, extension;
import std.process;
import usl.usl_def;

struct Root
{
private:
  string global_code; // .UDX - Userland Definitions XTended, defines functions outside all functions
  string definitions_code; // .UD - Userland Definitions, defines functions
  string loop_code; // .UC - Userland C, implements functions
  string outline_code; // .UL - Userland Line - outline functions

public:
  /** .UD - Userland Definitions */
  void set_definitions_code(string code) {
    definitions_code ~= code;
  }

  /** .UDX - Userland Definitions XTended */
  void set_global_code(string code)
  {
    global_code ~= code;
  }

  /** .UC - Userland C */
  void set_loop_code(string code)
  {
    loop_code ~= code;
  }

  /** .UL - Userland outLine */
  void set_outline_code(string code)
  {
    outline_code ~= code;
  }

  void write() {
    File f = File("out/userland.c", "w");

    f.writeln(USL_TOP_LINE); // top line (basic definitions)
    f.writefln("%s\ni32 main() {\n%s\n%s\n}\n", global_code, definitions_code, loop_code);

    f.close();
  }

  void compile() {
    write();

    // compile
  auto pid = spawnProcess(["gdc", "out/userland.c", "usl/uruntime.d", "-o", "out/ukux"],
                        stdin,
                        stdout);
  if (wait(pid) != 0)
    writefln("(wait-failed) compiling userland failed.");

  }
}

int main() {
  import std.file : readText;

  Root r;

  foreach (DirEntry f ; dirEntries("scripts/", SpanMode.shallow)) {
    writeln("Compiling ", f.name());
    if (extension(f.name()) == ".UD") {
      r.set_definitions_code(readText(f.name()));
    } else if (extension(f.name()) == ".UDX") {
      r.set_global_code(readText(f.name()));
    } else if (extension(f.name()) == ".UC") {
      r.set_loop_code(readText(f.name()));
    } else {
      writefln("userland: failed to process file extension '%s'", f.name());
      return -1;
    }
  }

  r.compile();
  return 0;
}
