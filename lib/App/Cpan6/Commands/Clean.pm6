#! /usr/bin/env false

use v6.c;

use App::Cpan6::Clean;

unit module App::Cpan6::Commands::Clean;

multi sub MAIN(
	"clean",
	Str:D $path = ".",
	Bool:D :$no-meta = False,
	Bool:D :$no-files = False,
	Bool:D :$force = False,
	Bool:D :$verbose = False,
) is export {
	# Clean up the META6.json
	clean-meta(:$path, :$force, :$verbose) unless $no-meta;

	# Clean up unreferenced files
	clean-files(:$path, :$force, :$verbose) unless $no-files;

	True;
}

# vim: ft=perl6 noet
