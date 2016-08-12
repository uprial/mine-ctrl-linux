#! /usr/bin/env python
# vim: ts=4 sts=4 sw=4 et: syntax=python

import os
import sys
import re

class File(object):
    @classmethod
    def read_lines(cls, filename):
        return cls._read(filename).split("\n")

    @classmethod
    def write_lines(cls, filename, lines):
        return cls._write(filename, "\n".join(lines))

    @staticmethod
    def _read(filename):
        with open(filename, "r") as filehandle:
            return filehandle.read()

    @staticmethod
    def _write(filename, content):
        with open(filename, "w") as filehandle:
            return filehandle.write(content)

class Path(object):

    @staticmethod
    def get_ctrl_dir():
        return os.path.dirname(os.path.realpath(__file__))

    @classmethod
    def get_root_dir(cls):
        return os.path.dirname(cls.get_ctrl_dir())

class Diff(object):
    def __init__(self, dirname, filename, separator):
        self.dirname = dirname
        self.filename = filename
        self.separator = separator

    def apply(self):
        if os.path.isfile(self._get_diff_filename()):
            self._replace(self._get_to_replace())

    def _replace(self, to_replace):
        full_filename = os.path.join(Path.get_root_dir(), self.filename)
        lines = File.read_lines(full_filename)

        keys = {}
        for line in lines:
            match = re.match(self._get_line_pattern(), line)
            if match:
                group = match.groups(0)
                key = group[0]

                if key not in keys:
                    keys[key] = 1
                else:
                    keys[key] += 1

        fixid = 1
        for i in xrange(len(lines)):
            if lines[i] in to_replace:
                key = to_replace[lines[i]]["key"]
                if keys[key] != 1:
                    if keys[key] != -1:
                        print ("ERROR: can't fix value of '%s' because"
                               " it is duplicated in file %s") % (key, full_filename)
                        keys[key] = -1

                    continue

                new_statement = to_replace[lines[i]]["statement"]

                print "==== %s, fix #%d ====" % (full_filename, fixid)
                print "< %s" % lines[i]
                print "> %s" % new_statement

                lines[i] = new_statement
                fixid += 1

        for key, item in to_replace.iteritems():
            if key not in key:
                print "ERROR: can't find key '%s' in file %s" % (key, full_filename)

        if fixid > 1:
            File.write_lines(full_filename, lines)

    def _get_to_replace(self):
        lines = File.read_lines(self._get_diff_filename())

        old = {}
        new = {}
        for line in lines:
            match = re.match("^(<|>)\\s" + self._get_line_pattern(), line)
            if match:
                group = match.groups(0)
                operator = group[0]
                key = group[1]
                value = group[3]
                statement = "%s%s%s%s" % (key, self.separator, group[2], value)

                item = {"statement": statement, "value": value}
                if operator == ">":
                    new[key] = item
                else:
                    old[key] = item

        to_replace = {}
        for k, v in new.iteritems():
            if k in old:
                if old[k]["value"] != v["value"]:
                    to_replace[old[k]["statement"]] = {"key": k, "statement": v["statement"]}

        return to_replace

    def _get_line_pattern(self):
        return "(\\s*[\\w\\-]+)" + re.escape(self.separator) + "(\\s*)(.*)$"

    def _get_diff_filename(self):
        return os.path.join(self.dirname, self.filename.replace(os.sep, "-")) + ".diff"

class Diffs(object):
    def __init__(self, dirname):
        self.dirname = dirname

    def apply(self):
        for filename in self._get_list():
            if len(filename) > 0:
                self._apply_file(filename)

    def _apply_file(self, filename):
        if filename.endswith(".yml") or filename.endswith(".txt") or filename.endswith(".ini"):
            Diff(self.dirname, filename, ":").apply()
        else:
            print "ERROR: can't process file %s" % filename

    @staticmethod
    def _get_list():
        return File.read_lines(os.path.join(Path.get_ctrl_dir(), "diff-list.txt"))

def usage():
    print "Usage:"
    print "   %s\tDIFFS_DIR" % sys.argv[0]
    exit(2)

def main():
    if len(sys.argv) < 2:
        usage()

    dirname = sys.argv[1]
    if not os.path.isdir(dirname):
        usage()

    Diffs(dirname).apply()

if __name__ == "__main__":
    main()
