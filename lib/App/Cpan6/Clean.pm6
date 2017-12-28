#! /usr/bin/env false

use v6.c;

use App::Cpan6::Meta;
use App::Cpan6::Input;

unit module App::Cpan6::Clean;

sub clean-files (
	Str:D :$path,
	Bool:D :$force = False,
	Bool:D :$verbose = False,
	--> Bool
) is export {
	my %meta = get-meta;

	# Clean up bin and lib directories
	for < bin lib > -> $directory {
		for find-files($directory) -> $file {
			next if %meta<provides> ∋ $file;

			say "Removing $file" if $verbose;
			unlink($file) if $force || confirm("Really delete $file?");
		}
	}

	# Clean up resources
	for find-files("resources") -> $file {
		next if %meta<resources> ∋ $file.subst("resources/", "");

		say "Removing $file" if $verbose;
		unlink($file) if $force || confirm("Really delete $file?");
	}
}

sub clean-meta (
	Str:D :$path = ".",
	Bool:D :$force = False,
	Bool:D :$verbose = False,
	--> Bool
) is export {
	my %meta = get-meta($path);
	my %provides;
	my @resources;

	# Clean up provides
	for %meta<provides>.kv -> $key, $value {
		if ($value.IO.e) {
			%provides{$key} = $value;

			next;
		}

		say "Removing provides.$key ($value)" if $verbose;
	}

	# Clean up resources
	for %meta<resources>.values -> $value {
		if ("resources/$value".IO.e) {
			@resources.push: $value;

			next
		}

		say "Removing resources.$value" if $verbose;
	}

	return False unless $force || confirm("Save cleaned META6.json?");

	%meta<provides> = %provides;
	%meta<resources> = @resources;

	put-meta(:%meta, :$path);
}

multi sub find-files (
	Str:D $path
	--> List
) is export {
	find-files($path.IO)
}

multi sub find-files (
	IO::Path:D $path
	--> List
) is export {
	my @files;

	for $path.dir -> $object {
		if ($object.IO.d) {
			@files.append: find-files($object);

			next;
		}

		@files.append: $object;
	}

	@files;
}

# vim: ft=perl6 noet
