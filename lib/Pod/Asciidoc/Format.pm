package Pod::Asciidoc::Format;

use strict;
use warnings;
our $VERSION = '0.01';

sub new {
    my ($class,%args) = @_;
    $args{'newline'} ||= "\n";
    $args{'headings'} ||= [qw(= - ~ ^ * +)];
    $args{'code_block'} ||= ('-' x 60);
    $args{'list_char'} ||= '*';
    bless \%args,$class;
}

sub newline { $_[0]->{'newline'} }
sub headings { $_[0]->{'headings'} }
sub code_block { $_[0]->{'code_block'} }
sub list_char { $_[0]->{'list_char'} }

sub heading {
    my ($self,$num,$args) = @_;
    my ($parser,$text,$paragraph) = @$args;
    $text =~ s/^\s*|\s*$//g;
    return ($text,$self->newline,
            $self->headings->[$num] x length($text),$self->newline);
}

sub start_verbatim {
    my ($self,$args) = @_;
    return ($self->newline, $self->code_block,$self->newline)
}

sub verbatim {
    my ($self,$args) = @_;
    my ($parser,$block) = @$args;
    return ($block );
}

sub end_verbatim {
    my ($self,$args) = @_;
    return ($self->code_block, $self->newline, $self->newline)
}

sub item {
    my ($self,$level,$text) = @_;
    $text =~ s/\s*$//;
    return ($self->list_char x $level, " ", $text, $self->newline x 2);
}

sub bold {
    my ($self,$args) = @_;
    my ($parser,$text) = @$args;
    return "*$text*";
}

sub italic {

}

sub anchor {

}

sub code {
    my ($self,$args) = @_;
    my ($parser,$text) = @$args;
    return "+$text+";
}

1;

=encoding utf8


