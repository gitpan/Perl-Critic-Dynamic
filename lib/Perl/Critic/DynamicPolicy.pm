##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/tags/Perl-Critic-Dynamic-0.04/lib/Perl/Critic/DynamicPolicy.pm $
#     $Date: 2007-08-07 13:11:35 -0700 (Tue, 07 Aug 2007) $
#   $Author: thaljef $
# $Revision: 1821 $
##############################################################################

package Perl::Critic::DynamicPolicy;

use strict;
use warnings;
use Storable qw();
use Carp qw(confess);
use English qw(-no_match_vars);

use base 'Perl::Critic::Policy';

#-----------------------------------------------------------------------------

our $VERSION = 0.03;

#-----------------------------------------------------------------------------
# This function creates a pipe and forks.  The child will compile the code and
# find violations.  The violations are then serlialized and then sent back to
# the parent across the pipe.  Meanwhile, the parent just waits for the child
# to report back.

sub violates {

    my ($self, $doc, $elem) = @_;

    # Open a pipe, and fork
    pipe my ($parent_reader, $child_writer);
    defined (my $pid = fork) or confess 'Fork error';


    if (!$pid) {

        # child process
        eval {

            close $parent_reader or
              confess "Failed to close unused pipe end: $OS_ERROR";

            binmode $child_writer;

            my @violations = $self->violates_dynamic($doc, $elem);
            my $serialized = Storable::freeze(\@violations);
            print {$child_writer} $serialized;

            close $child_writer
              or confess "Failed to close pipe writer: $OS_ERROR";
        };

        # All exceptions from the child process are caught.  We communicate
        # failure back to the parent via the exit $status of the child.
        # However, the parent doesn't really know why the child failed.  This
        # also has the unfortunate side-effect of hiding the text of
        # $EVAL_ERROR.  I'm not sure how to improve this.

        my $status = $EVAL_ERROR ? 1 : 0;
        exit $status;
    }


    # parent (i.e. original) process
    close $child_writer or confess "Failed to close unused pipe end: $OS_ERROR";
    binmode $parent_reader;

    my $serialized = do {local $INPUT_RECORD_SEPARATOR = undef; <$parent_reader>};
    close $parent_reader or confess "Failed to close pipe reader: $OS_ERROR";
    waitpid $pid, 0; # pause until child process exits

    # Here is where the parent detects failure from the child.  But at this
    # point, we don't know why the child failed.

    confess "Child process had errors.  Status: $CHILD_ERROR" if $CHILD_ERROR;
    my @violations = @{Storable::thaw($serialized)};
    return @violations;
}

#-----------------------------------------------------------------------------

sub violates_dynamic { confess q{Can't call abstract method}; }

#-----------------------------------------------------------------------------

1;

__END__

=pod

=head1 NAME

Perl::Critic::DynamicPolicy - Base class for dynamic Policies

=head1 DESCRIPTION

L<Perl::Critic::DynamicPolicy> is intended to be used as a base class for
L<Perl::Critic::Policy> modules that wish to compile and/or execute the code
that is being analyzed.

Policies derived from L<Perl::Critic::DynamicPolicy> will C<fork> the
process each time the C<violates> method is called.  The child process is then
free to compile the code and do other mischievous things without corrupting
the symbol table of the parent process.  When the analysis is complete, the
child serializes any L<Perl::Critic::Violation> objects that were created and
sends them back to the parent across a pipe.

In every other way, a L<Perl::Critic::DynamicPolicy> behaves just like an
ordinary L<Perl::Critic::Policy>.  For Policy authors, the main difference is
that you must override the C<violates_dynamic> method instead of the
C<violates> method.  See L<Perl::Critic::DEVELOPER> for a discussion of the
other aspects of creating new Policies.

=head1 METHODS

This list of methods is not exhaustive.  It only covers the methods that are
uniquely relevant to L<Perl::Critic::DynamicPolicy> subclasses.  See
L<Perl::Critic::Policy> and L<Perl::Critic::DEVELOPER> for documentation about
the other methods shared by all Policies.

=over 8

=item C< violates( $doc, $elem ) >

In a typical L<Perl::Critic::Policy> subclass, you would override the
C<violates> method to do whatever code analysis you want.  But with
L<Perl::Critic::DynamicPolicy>, this method has already been overridden to
perform the necessary pipe and fork operations that I described above.  So
instead, you need to override the C<violates_dyanmic> method.

=item C< violates_dynamic( $doc, $elem ) >

Given a PPI::Element and a PPI::Document, returns one or more
L<Perl::Critic::Violation> objects if the C<$elem> or <$doc> violates this
Policy.  If there are no violations, then it returns an empty list.  This
method will be called in a child process, so you can compile C<$doc> without
interfering with the parent process.

C<violates_dynamic> is an abstract method and it will abort if you attempt to
invoke it directly.  It is the heart of your L<Perl::Critic::DynamicPolicy>
modules, and your subclass must override this method.

=back

=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2007 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  The full text of this license can be found in
the LICENSE file included with this module.

=cut

##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
