#! /usr/bin/env perl6

use v6.c;

use App::Cpan6::Commands::New;
use App::Cpan6::Commands::Touch::Resource;
use App::Cpan6::Meta;
use File::Temp;
use Test;

multi sub MAIN { 0 }

# Disable git
%*ENV<CPAN6_EXTERNAL_GIT> = False;

my $root = tempdir;

chdir $root;

plan 2;

ok MAIN(
	"new",
	name => "Local::Test::Touch::Resource",
	author => "Patrick Spek",
	email => "p.spek@tyil.work",
	perl => "c",
	description => "Nondescript",
	license => "GPL-3.0",
	no-user-config => True,
), "cpan6 new Local::Test::Touch::Resource";

subtest "Touch unit files", {
	my @tests = <
		first
		second/level
		third/level/test
	>;

	my $module-dir = "$root/perl6-Local-Test-Touch-Resource";

	plan 4 × @tests.elems;

	for @tests -> $test {
		chdir $module-dir;

		ok get-meta()<resources> ∌ $test, "META6.json does not contain $test yet";
		ok MAIN("touch", "resource", $test), "cpan6 touch resource $test";

		chdir $module-dir;

		my %new-meta = get-meta;

		ok %new-meta<resources> ∋ $test, "$test exists in META6.json<provides>";
		ok "resources/$test", "Resource $test exists";
	}
}

# vim: ft=perl6 noet
