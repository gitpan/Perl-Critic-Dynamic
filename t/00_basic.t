#!perl


use strict;
use warnings;
use Test::More (tests => 6);

#-----------------------------------------------------------------------------

my $package = 'Perl::Critic::Policy::Dynamic::ValidateAgainstSymbolTable';

#-----------------------------------------------------------------------------

use_ok( $package );
can_ok($package, 'new');
can_ok($package, 'violates');

my $policy = $package->new();
isa_ok($policy, 'Perl::Critic::Policy');
isa_ok($policy, 'Perl::Critic::DynamicPolicy');
isa_ok($policy, $package);


