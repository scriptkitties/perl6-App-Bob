#! /usr/bin/env perl6

use v6.c;

use Test;
use JSON::Fast;

my %provides = from-json(slurp "META6.json")<provides>;

for %provides.keys -> $module {
	use-ok $module;
}

# vim: ft=perl6 noet
