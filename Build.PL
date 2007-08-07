#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-Dynamic-0.04/Build.PL $
#     $Date: 2007-08-07 13:11:35 -0700 (Tue, 07 Aug 2007) $
#   $Author: thaljef $
# $Revision: 1821 $
########################################################################

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(

  module_name    => 'Perl::Critic::Dynamic',
  dist_author    => 'Jeffrey Thalhammer <thaljef@cpan.org>',
  dist_abstract  => 'Dynamic policies for Perl::Critic',
  license        => 'perl',

  requires       => {'Perl::Critic::Utils'   => 1.053,
                     'Perl::Critic::Policy'  => 1.053,
                     'Devel::Symdump'        => 2.07,
                     'Readonly'              => 0,,
                     'Storable'              => 2.16,
                    },
  build_requires => {'Test::More'            => 0,
                    },
);

$builder->create_build_script();

##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
