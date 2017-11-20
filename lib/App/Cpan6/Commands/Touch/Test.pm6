#! /usr/bin/env false

use v6;

use App::Cpan6::Meta;
use App::Cpan6::Template;

unit module App::Cpan6::Commands::Touch::Test;

multi sub MAIN("touch", "test", Str $test) is export
{
	my %meta = get-meta;
	my $path = "./t".IO;

	$path = $path.add($test);
	$path = $path.extension("t", parts => 0);

	if ($path.e) {
		die "File already exists at {$path.absolute}";
	}

	template("module/test", $path, context => %(perl-version => %meta<perl>));

	# Inform the user of success
	say "Added test $test to {%meta<name>}";
}
