package Pod::Asciidoc::Format;

use strict;
use warnings;

sub new {
    my ($class,%args) = @_;
    $args{'newline'} ||= "\n";
    $args{'headings'} ||= [qw(= - ~ ^ * +)];
    bless \%args,$class;
}

sub newline { $_[0]->{'newline'} }
sub headings { $_[0]->{'headings'} }

sub heading {
    my ($self,$num,$args) = @_;
    my ($parser,$text,$paragraph) = @$args;
    $text =~ s/^\s*|\s*$//g;
    return ($text,$self->newline,
            $self->headings->[$num] x length($text),$self->newline);
}

1;

