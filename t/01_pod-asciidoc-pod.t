
use strict;
use warnings;
use Test::More tests => 1;

use Pod::Asciidoc;

my $source = './lib/Pod/Asciidoc.pm';
open(my $outfh, ">", \my $result) or die $!;

my $parser = Pod::Asciidoc->new;
$parser->parse_from_file($source,$outfh);

print $result;