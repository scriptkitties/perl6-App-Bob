#! /usr/bin/env false

use v6;

use App::Cpan6::Config;
use Config;

unit module App::Cpan6::Dist;

multi sub get-dist-path(Str $name, Str $version, Config:D :$config --> Str) is export
{
	$config.get("cpan6.distdir").IO.add("{$name}-{$version}.tar.gz").absolute;
}

multi sub get-dist-path() is export
{
	get-dist-path(config => get-config());
}
