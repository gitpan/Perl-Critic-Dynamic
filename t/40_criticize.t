#!perl

##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-Dynamic-0.04/t/40_criticize.t $
#     $Date: 2007-08-07 13:11:35 -0700 (Tue, 07 Aug 2007) $
#   $Author: thaljef $
# $Revision: 1821 $
##############################################################################

# Self-compliance tests

use strict;
use warnings;
use English qw( -no_match_vars );

use File::Spec qw();
use Test::More;

#-----------------------------------------------------------------------------

if ( !-d '.svn' && !$ENV{TEST_AUTHOR}) {
    ## no critic (RequireInterpolation)
    my $reason = 'Author test.  Set $ENV{TEST_AUTHOR} to a true value to run.';
    plan skip_all => $reason;
}

#-----------------------------------------------------------------------------

eval { require Test::Perl::Critic; };
plan skip_all => 'Test::Perl::Critic required to criticise code' if $EVAL_ERROR;

#-----------------------------------------------------------------------------
# Run critic against all of our own files

my $rcfile = File::Spec->catfile( 't', '40_perlcriticrc' );
Test::Perl::Critic->import( -profile => $rcfile );

all_critic_ok();

#-----------------------------------------------------------------------------

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
