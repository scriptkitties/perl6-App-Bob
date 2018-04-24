#! /usr/bin/env perl6

use v6.c;

use Dist::Helper::QA::Result;
use Dist::Helper::QA;
use File::Temp;
use Hash::Merge;
use JSON::Fast;
use Test;

plan 4;

subtest "Check empty directory" => {
	plan 5;

	my $tmp = tempdir;
	my %qa = dist-qa($tmp, :meta, :skip-rest);

	ok %qa<meta>:exists, "meta key exists";
	is %qa<meta>.elems, 1, "meta contains 1 element";
	nok %qa<meta>[0].passed, "meta[0] did not pass";
	is %qa<meta>[0].reasons.elems, 1, "meta[0] has 1 failure reason";

	subtest "Types" => {
		plan 3;

		isa-ok %qa<meta>[0], Dist::Helper::QA::Result, "meta[0] is a Dist::Helper::QA::Result";
		isa-ok %qa<meta>[0].description, Str, "meta[0].description is a Str";
		isa-ok %qa<meta>[0].reasons[0], Str, "meta[0].reasons[0] is a Str";
	}
}

subtest "Check empty META6.json" => {
	my $tmp = tempdir;
	$tmp.IO.add("META6.json").spurt("\{\n\}");
	my %qa = dist-qa($tmp, :meta, :skip-rest);

	plan 3;

	ok %qa<meta>:exists, "meta key exists";

	is %qa<meta>[0].reasons.elems, %qa<meta>[0].checks, "'{%qa<meta>[0].description}' failed completely";
	is %qa<meta>[1].reasons.elems, %qa<meta>[1].checks, "'{%qa<meta>[1].description}' failed completely";
}

subtest "Check META6.json with incorrect types" => {
	my $tmp = tempdir;
	my %meta =
		api => 0,
		auth => 12,
		authors => "Henk de Vries",
		build-depends => "Dist::Helper" ,
		depends => "App::Assixt",
		description => ["One", "two"],
		license => 8,
		name => ["Dist", "Helper", "QA"],
		perl => 6,
		provides => "Functionality",
		source-url => "some dist on my homepage",
		tags => {"foo" => "bar"},
		test-depends => "Hash::Merge",
		resources => [],
		version => [0, 1, 1],
	;

	$tmp.IO.add("META6.json").spurt(to-json(%meta));

	my %qa = dist-qa($tmp, :meta, :skip-rest);

	plan 4;

	ok %qa<meta>:exists, "meta key exists";

	ok %qa<meta>[0].passed, "'{%qa<meta>[0].description}' passed";
	ok %qa<meta>[1].passed, "'{%qa<meta>[1].description}' passed";
	is %qa<meta>[2].reasons.elems, %qa<meta>[2].checks, "'{%qa<meta>[2].description}' failed completely";
}

subtest "Check META6.json with correct types" => {
	my $tmp = tempdir;
	my %meta =
		api => '1',
		auth => 'github:scriptkitties',
		authors => ['Patrick Spek'],
		build-depends => ['Dist::Helper'] ,
		depends => ['App::Assixt'],
		description => "This is a test description. Don't read it!",
		license => 'GPL-3.0',
		name => "Dist::Helper::QA",
		perl => "6.c",
		provides => {"Dist::Helper::QA" => "lib/Dist/Helper/QA.pm6"},
		source-url => "https://github.com/scriptkitties/perl6-dist-helper",
		tags => ["foo", "bar"],
		test-depends => ["Hash::Merge"],
		resources => {},
		version => "0.1.1",
	;

	$tmp.IO.add("META6.json").spurt(to-json(%meta));

	my %qa = dist-qa($tmp, :meta, :skip-rest);

	plan 4;

	ok %qa<meta>:exists, "meta key exists";

	ok %qa<meta>[0].passed, "'{%qa<meta>[0].description}' passed";
	ok %qa<meta>[1].passed, "'{%qa<meta>[1].description}' passed";
	ok %qa<meta>[2].passed, "'{%qa<meta>[2].description}' passed";
}

# vim: ft=perl6 noet
