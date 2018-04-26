#! /usr/bin/env false

use v6.c;

use Dist::Helper::Meta;
use Dist::Helper::QA::Check;
use Dist::Helper::QA::Result;
use PostCocoon::Url;

class Dist::Helper::QA::Checks::Meta is Dist::Helper::QA::Check
{
	method check (
		--> Iterable
	) {
		try {
			CATCH {
				when X::AdHoc {
					return [
						Dist::Helper::QA::Result.new(
							description => "Distribution contains a valid META6.json"
						).failure: .payload;
					];
				}
			}

			my %meta = get-meta;

			[
				self!required-fields(%meta),
				self!recommended-fields(%meta),
				self!correct-value-types(%meta),
				self!semantic-version(%meta),
				self!unused-deps(%meta),
				self!dependency-version-adverbs(%meta),
			]
		}
	}

	method !correct-value-types (
		%meta,
		--> Dist::Helper::QA::Result
	) {
		my %types =
			api => Str,
			auth => Str,
			authors => Array,
			build-depends => Array,
			depends => Array,
			description => Str,
			license => Str, # TODO: Check for valid license
			name => Str,
			perl => Str,
			provides => Hash,
			resources => Hash,
			source-url => "Url",
			tags => Array,
			test-depends => Array,
			version => Str,
		;

		my Dist::Helper::QA::Result $result .= new(
			description => "META6.json uses the correct types for all used fields",
		);

		for %types.kv -> $field, $type {
			next unless %meta{$field}:exists;

			$result.inc-checks;

			given $type {
				when "Url" {
					if (!is-valid-url(%meta{$field})) {
						$result.failure: "$field is of the wrong type, should be $type";
					}
				}
				default {
					next if %meta{$field} ~~ $type;

					my $stringified = do given $type {
						when Array { "Array" }
						when Hash { "Hash" }
						when Str { "String" }
						default { "N/A" }
					}

					$result.failure: "$field is of the wrong type, should be $stringified";
				}
			}
		}

		$result;
	}

	method !dependency-version-adverbs (
		%meta,
		--> Dist::Helper::QA::Result
	) {
		Dist::Helper::QA::Result.new
	}

	method !recommended-fields (
		%meta,
		--> Dist::Helper::QA::Result
	) {
		my @fields = <
			api
			auth
			authors
			resources
			source-url
			tags
			test-depends
		>;

		my Dist::Helper::QA::Result $result .= new(
			description => "META6.json contains all recommended fields",
			checks => @fields.elems,
		);

		for @fields -> $field {
			if (%meta{$field}:!exists) {
				$result.failure: "Missing recommended field $field";
			}
		}

		$result;
	}

	method !required-fields (
		%meta,
		--> Dist::Helper::QA::Result
	) {
		my @fields = <
			depends
			description
			license
			name
			perl
			provides
			version
		>;

		my Dist::Helper::QA::Result $result .= new(
			description => "META6.json contains all required fields",
			checks => @fields.elems,
		);

		for @fields -> $field {
			next if %meta{$field}:exists;

			$result.failure: "Missing required field $field";
		}

		$result;
	}

	method !semantic-version (
		%meta,
		--> Dist::Helper::QA::Result
	) {
		Dist::Helper::QA::Result.new
	}

	method !unused-deps (
		%meta,
		--> Dist::Helper::QA::Result
	) {
		Dist::Helper::QA::Result.new
	}
}

# vim: ft=perl6 noet
