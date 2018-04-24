#! /usr/bin/env false

use v6.c;

use Dist::Helper::QA::Checks::Meta;

unit module Dist::Helper::QA;

multi sub dist-qa (
	IO::Path:D $path,
	*%checks,
	Bool:D :$skip-rest = False,
	--> Hash
) is export {
	sub include-check(
		Str:D $name
	) {
		if (%checks{$name}:!exists) {
			return !$skip-rest;
		}

		return ?%checks{$name};
	}

	my IO::Path $cwd = $*CWD;
	chdir $path;

	my %todo;

	if (include-check("meta")) { %todo<meta> = Dist::Helper::QA::Checks::Meta }

	my %results;

	for %todo.kv -> $scope, $check {
		%results{$scope} = %todo{$scope}.check;
	}

	chdir $cwd;

	%results;
}

multi sub dist-qa (
	Str:D $path = ".",
	*%checks,
	Bool:D :$skip-rest = False,
	--> Hash
) is export {
	dist-qa($path.IO, |%checks, :$skip-rest);
}

# vim: ft=perl6 noet
