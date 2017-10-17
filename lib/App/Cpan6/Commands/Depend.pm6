#! /usr/bin/env false

use v6;

use App::Cpan6::Meta;

unit module App::Cpan6::Commands::Depend;

multi sub MAIN("depend", Str @modules, Bool :$skip-install = False) is export
{
	for @modules -> $module {
		MAIN("depend", $module, :$skip-install);
	}
}

multi sub MAIN("depend", Str $module, Bool :$skip-install = False) is export
{
	# Get the meta info
	my %meta = get-meta;

	# Install the new dependency with zef
	if (!$skip-install) {
		my $zef = run « zef --cpan install $module »;

		die "Zef failed, bailing" if 0 < $zef.exitcode;
	}

	# Add the new dependency if its not listed yet
	if (%meta<depends><runtime><requires> ∌ $module) {
		%meta<depends><runtime><requires>.push: $module;
	}

	# Write the new META6.json
	put-meta(:%meta);

	# And finish off with some user friendly feedback
	say "$module has been added as a dependency to {%meta<name>}";
}
