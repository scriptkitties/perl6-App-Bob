#! /usr/bin/env false

use v6.c;

class Dist::Helper::QA::Result
{
	has Str  $.description;
	has Str  @.reasons     = [];
	has Int  $.checks      = 0;

	method failure (
		Str:D $reason,
		--> Dist::Helper::QA::Result
	) {
		@!reasons.push: $reason;

		self;
	}

	method inc-checks()
	{
		$!checks++;
	}

	method passed (
		--> Bool
	) {
		@!reasons.elems < 1;
	}

	method Str
	{
		my Str $check-box = $.passed
			?? "[x]"
			!! "[ ]"
			;

		"$check-box $.message";
	}
}

# vim: ft=perl6 noet
