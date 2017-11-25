#! /usr/bin/env false

use v6.c;

unit module App::Cpan6::Commands::Help;

sub USAGE is export
{
	say "cpan6 - A tool to assist in creating and sharing CPAN modules\n";

	my Bool $in-commands = False;

	for %?RESOURCES<man/cpan6.1.adoc>.lines -> $line {
		if ($line eq "== COMMANDS") {
			$in-commands = True;

			next;
		}

		next unless $in-commands;

		if ($line.starts-with("=== ")) {
			say "cpan6 {$line.substr(4)}".indent(3);
		}

		last if $line.starts-with("== ");
	}

	True;
}

multi sub MAIN("help") is export
{
	USAGE
}
