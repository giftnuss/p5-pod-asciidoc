package Pod::Asciidoc;

use strict;
use warnings;
use vars qw(@ISA $VERSION %command);

use Pod::Parser;
use Pod::Asciidoc::Format;

@ISA = ( 'Pod::Parser' );

$VERSION = '0.01';

%command = (
    head1 => sub { $_[0]->asciidoc->heading(2,\@_) },
    head2 => sub { $_[0]->asciidoc->heading(3,\@_) },
    head3 => sub { $_[0]->asciidoc->heading(4,\@_) }
);

sub asciidoc {
    return $_[0]->{'asciidoc'}
}

sub initialize {
    my ($self) = @_;
    $self->SUPER::initialize();
    unless($self->asciidoc) {
        $self->{'asciidoc'} = Pod::Asciidoc::Format->new;
    }
}

sub command {
    my ($self,$command,$text,$linenum,$podpara) = @_;

    my @result;
    if(exists $command{$command}) {
        @result = $command{$command}->($self,$text,$podpara);
    }
    my $out = $self->output_handle();
    print $out @result;
}


1;
