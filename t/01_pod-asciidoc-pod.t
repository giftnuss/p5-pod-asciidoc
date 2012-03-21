
use strict;
use warnings;
use Test::More tests => 1;

use IO::String;
use Pod::Asciidoc;

my $source = './lib/Pod/Asciidoc.pm';
my $outfh = IO::String->new(my $result);

my $parser = Pod::Asciidoc->new;
$parser->parse_from_file($source,$outfh);

print $result;