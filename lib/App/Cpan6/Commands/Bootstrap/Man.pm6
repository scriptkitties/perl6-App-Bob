#! /usr/bin/env false

use v6.c;

use File::Which;

unit module App::Cpan6::Commands::Bootstrap::Man;

multi sub MAIN("bootstrap", "man") is export
{
	die "a2x is not installed" unless which("a2x");
	die "nroff is not installed" unless which("nroff");

	run « a2x -f manpage readme.adoc »;
}

# vim: ft=perl6 noet
