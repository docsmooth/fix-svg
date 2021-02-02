#!/usr/bin/perl
use strict;
use warnings;

my $debug=1;
my $file=shift;
my $outdir="./resaved";
if (! -r $file ) {
    #we got a stream, do not handle!
    die "cannot handle a stream!\n";
}
if (! -d $outdir ) {
    die "no child $outdir directory to write into!\n";
}
open(my $fh, "<", $file) || die "Can't read $file!\n";
open(my $fo, ">", "$outdir/$file");
my %classes;
while(<$fh>) {
    %classes=$_=~/(cls-[0-9]+)\{([^\}]*)\}/g;
    foreach my $class (keys(%classes)) {
        $classes{$class}=~s/:([^;]*);/="$1" /g;
        if ($_=~s/class="?$class"?/$classes{$class}/g) {
            $debug && print "replaced $class with $classes{$class}\n";
        }
    }
    print $fo $_;
}
close $fo;
close $fh;
