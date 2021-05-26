package List::Util::Find;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw(
                       hasnum
                       hasstr
               );

sub hasnum {
    no warnings 'numeric';

    my $needle = shift;
    warn "hasnum(): needle is undefined" unless defined $needle;

    for (@_) {
        # TODO: handle Inf & -Inf (and NaN also?)
        next unless defined;
        next unless $needle == $_;
        if ($needle == 0) {
            # when needle == 0, we want to make sure that we don't match "foo"
            # as 0.
            return 1 if /\A\s*[+-]?(?:0|[1-9][0-9]*)\s*\z/s; # from isint()
            return 1 if /\A\s*[+-]?
                         (?: (?:0|[1-9][0-9]*)(\.[0-9]+)? | (\.[0-9]+) )
                         ([eE][+-]?[0-9]+)?\s*\z/sx && $1 || $2 || $3; # from isfloat()
            next;
        } else {
            return 1;
        }
    }
    0;
}

sub hasstr {
    my $needle = shift;
    for (@_) {
        return 1 if defined $_ && $needle eq $_;
    }
    0;
}

1;
# ABSTRACT: List utilities related to finding items

=head1 SYNOPSIS

 use List::Util::Find qw(hasnum hasstr);

 my @ary = (1,3,"foo",7,2,"bar",10,"baz");

 if (hasnum 3, @ary) {
     ...
 }

 if (hasstr "baz", @ary) {
     ...
 }


=head1 DESCRIPTION

Experimental.


=head1 FUNCTIONS

Not exported by default but exportable.

=head2 hasnum

Usage:

 hasnum $num, ...

Like C<< grep { $_ == $num } ... >> except: 1) it makes sure C<undef> does not
match; 2) it makes sure non-numeric scalars does not match when C<$num> is zero.

=head2 hasstr


=head1 SEE ALSO

L<List::Util>
