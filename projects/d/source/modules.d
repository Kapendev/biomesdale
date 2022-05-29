public import std.stdio : writeln;
public import std.net.curl : get, AutoProtocol, CurlException;
public import std.regex : regex, matchFirst;
public import std.file : write, dirEntries, remove, exists, SpanMode;
public import std.path : expandTilde;
public import std.process : environment;
public import std.zip;
