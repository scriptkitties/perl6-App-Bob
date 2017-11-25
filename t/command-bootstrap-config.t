#! /usr/bin/env perl6

use v6.c;

use File::Temp;
use App::Cpan6::Commands::Bootstrap::Config;
use App::Cpan6::Commands::New;
use App::Cpan6::Config;
use Test;

plan 2;

multi sub MAIN { 0 }

my $root = tempdir;

chdir $root;

ok MAIN(
	"new",
	name => "Local::Test::Bootstrap::Config",
	author => "Patrick Spek",
	email => "p.spek@tyil.work",
	perl => "c",
	description => "Nondescript",
	license => "GPL-3.0",
	no-user-config => True,
), "cpan6 new Local::Test::Bootstrap Config";

subtest "Set configuration option", {
	plan 3;

	ok MAIN(
		"bootstrap",
		"config",
		"cpan6.distdir",
		"/tmp",
		config-file => "$root/cpan6.toml",
		force => True,
	), "cpan6 bootstrap config cpan6.distdir /tmp";

	my $config = get-config(
		config-file => "$root/cpan6.toml",
	);

	ok $config, "Written config loads correctly";
	is $config<cpan6><distdir>, "/tmp", "Updated config option saved correctly";
};

# vim: ft=perl6 noet
