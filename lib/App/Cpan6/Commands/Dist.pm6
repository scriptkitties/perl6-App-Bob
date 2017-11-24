#! /usr/bin/env false

use v6;

use App::Cpan6;
use App::Cpan6::Config;
use App::Cpan6::Meta;
use File::Which;

unit module App::Cpan6::Commands::Dist;

multi sub MAIN(
	"dist",
	Str:D $path,
	Str :$output-dir,
	Bool:D :$force = False,
	Bool:D :$verbose = True,
) is export {
	chdir $path;

	if (!"./META6.json".IO.e) {
		note "No META6.json in {$path}";
		return;
	}

	die "'tar' is not available on this system" unless which("tar");

	my %meta = get-meta;

	my Str $fqdn = get-dist-fqdn(%meta);
	my Str $basename = $*CWD.IO.basename;
	my Str $transform = "s/^\./{$fqdn}/";
	my Str $output = "{$output-dir // get-config()<cpan6><distdir>}/$fqdn.tar.gz";

	# Ensure output directory exists
	mkdir $output.IO.parent;

	if ($output.IO.e && !$force) {
		note "Archive already exists: {$output}";
		return;
	}

	run «
		tar czf $output
		--transform $transform
		--exclude-vcs
		--exclude-vcs-ignores
		--exclude=.[^/]*
		.
	», :err;

	say "Created {$output}";

	if ($verbose) {
		my $list = run « tar --list -f $output », :out;

		for $list.out.lines -> $line {
			say "  {$line}";
		}
	}

	True;
}

multi sub MAIN(
	"dist",
	Str :$output-dir,
	Bool:D :$force = False,
	Bool:D :$verbose = True
) is export {
	MAIN("dist", ".", :$output-dir, :$force, :$verbose);
}

multi sub MAIN(
	"dist",
	@paths,
	Str :$output-dir,
	Bool:D :$force = False,
	Bool:D :$verbose = True,
) is export {
	for @paths -> $path {
		MAIN("dist", $path, :$output-dir, :$force, :$verbose);
	}
}
