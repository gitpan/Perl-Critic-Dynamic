#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-Dynamic-0.04/Makefile.PL $
#     $Date: 2007-08-07 13:11:35 -0700 (Tue, 07 Aug 2007) $
#   $Author: thaljef $
# $Revision: 1821 $
#        ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
########################################################################

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME           => 'Perl::Critic::Dynamic',
    AUTHOR         => 'Jeffrey Thalhammer <thaljef@cpan.org>',
    ABSTRACT_FROM  => 'lib/Perl/Critic/Dynamic.pm',
    VERSION_FROM   => 'lib/Perl/Critic/Dynamic.pm',
    PL_FILES       => {},
    PREREQ_PM      => {
        'Perl::Critic::Utils'   => 1.053,
        'Perl::Critic::Policy'  => 1.053,
        'Devel::Symdump'        => 2.07,
        'Storable'              => 2.16,
        'Test::More'            => 0,
    },
);

##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
