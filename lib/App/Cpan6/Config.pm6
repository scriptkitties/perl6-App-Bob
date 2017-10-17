#! /usr/bin/env false

use v6;

use Config;

unit module App::Cpan6::Config;

sub get-config(--> Config) is export
{
	my Config $config .= new;
	my Str @paths =
		"{$*HOME}/.config/cpan6.toml"
	;

	for @paths -> $path {
		if (!$path.IO.e) {
			next;
		}

		$config.read: $path;
	}

	$config;
}
