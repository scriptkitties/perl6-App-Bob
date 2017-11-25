#! /usr/bin/env perl6

use v6.c;

use App::Cpan6::Commands::New;
use App::Cpan6::Commands::Dist;
use File::Temp;
use File::Which;
use Test;

plan 4;

skip-rest "'tar' is not available" unless which("tar");

multi sub MAIN { 0 }

my $root = tempdir;

# Set custom config
%*ENV<CPAN6_CPAN6_DISTDIR> = $root;
%*ENV<CPAN6_EXTERNAL_GIT> = False;

chdir $root;

ok MAIN(
	"new",
	name => "Local::Test::Dist",
	author => "Patrick Spek",
	email => "p.spek@tyil.work",
	perl => "c",
	description => "Nondescript",
	license => "GPL-3.0",
	no-user-config => True,
), "cpan6 new Local::Test::Dist";

subtest "Create dist with normal config", {
	plan 2;

	ok MAIN(
		"dist"
	), "cpan6 dist";

	ok "$root/Local-Test-Dist-0.0.0.tar.gz".IO.e, "Tarball exists";
};

subtest ":output-dir overrides config-set output-dir", {
	plan 2;

	my Str $output-dir = "$root/output-1";

	ok MAIN(
		"dist",
		:$output-dir,
	), "cpan6 dist";

	ok "$output-dir/Local-Test-Dist-0.0.0.tar.gz".IO.e, "Tarball exists";
};

subtest "Dist in other path can be created", {
	plan 2;

	my Str $output-dir = "$root/output-2";

	chdir $root;

	ok MAIN(
		"dist",
		"perl6-Local-Test-Dist",
		:$output-dir,
	), "cpan dist Local-Test-Dir";

	ok "$output-dir/Local-Test-Dist-0.0.0.tar.gz".IO.e, "Tarball exists";
};

# vim: ft=perl6 noet
