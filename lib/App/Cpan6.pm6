#! /usr/bin/env false

use v6.c;

use JSON::Fast;

unit module App::Cpan6;

sub get-dist-fqdn(%meta --> Str) is export
{
	return "{get-dist-name(%meta)}-{get-dist-version(%meta)}";
}

sub get-dist-name(%meta --> Str) is export
{
	if (%meta<name>:!exists) {
		die "No name attribute in meta";
	}

	return %meta<name>.subst("::", "-", :g).trim;
}

sub get-dist-version(%meta --> Str) is export
{
	if (%meta<version>:!exists) {
		die "No version attribute in meta";
	}

	return %meta<version>.trim;
}
