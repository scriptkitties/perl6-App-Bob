#! /usr/bin/env perl6

use v6.c;

use App::Cpan6::Commands::Bootstrap::Man;
use App::Cpan6::Commands::New;
use App::Cpan6::Config;
use File::Temp;
use File::Which;
use Test;

if (!which("a2x")) {
	say "'a2x' is not available";
	done-testing;
	return;
}

if (!which("gzip")) {
	say "'gzip' is not available";
	done-testing;
	return;
}

multi sub MAIN { 0 }

plan 2;

my $root = tempdir;

chdir $root;

ok MAIN(
	"new",
	name => "Local::Test::Bootstrap::Man",
	author => "Patrick Spek",
	email => "p.spek@tyil.work",
	perl => "c",
	description => "Nondescript",
	license => "GPL-3.0",
	no-user-config => True,
), "cpan6 new Local::Test::Bootstrap::Man";

subtest "Build manpages", {
	plan 2;

	ok MAIN(
		"bootstrap",
		"man",
		:dir("$root"),
	), "cpan6 bootstrap man";

	ok "$root/man1/cpan6.1.gz".IO.e, "cpan6.1.gz built";
};

# vim: ft=perl6 noet
