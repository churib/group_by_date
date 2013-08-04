#!/usr/bin/env perl

use warnings;
use strict;

package group_by_date;

use Data::Dumper;

run( @ARGV ) unless caller;

sub run {
    my ( $file_glob ) = @_;

    my $path = '.';

    chdir $path or die "Cannot chdir to '$path'\n";

    my @files = glob $file_glob;
    print Dumper \@files if $ENV{DEBUG};

    my %dates;
    for my $file ( @files ) {
        my $ctime = ( stat $file )[9];
        my ( $day, $month, $year ) = ( localtime( $ctime ) )[ 3, 4, 5 ];
        $dates{$file} //= sprintf "%4d-%02d-%02d", $year + 1900, $month, $day;
    }
    print Dumper \%dates if $ENV{DEBUG};

    for my $date ( values %dates ) {
        print "dir '$date' already exists\n" if -e $date and $ENV{DEBUG};
        mkdir $date if not -e $date;
    }

    rename $_, "$dates{$_}/$_" for @files;

    print "done\n" if $ENV{DEBUG};

}

__END__
