package Pod::Asciidoc;

use strict;
use warnings;
use vars qw(@ISA $VERSION %convert $end_block);

use Pod::Parser;
use Pod::Asciidoc::Format;

@ISA = ( 'Pod::Parser' );

$VERSION = '0.01';

%convert = (
    head1 => sub { $_[0]->asciidoc->heading(2,\@_) },
    head2 => sub { $_[0]->asciidoc->heading(3,\@_) },
    head3 => sub { $_[0]->asciidoc->heading(4,\@_) },
    head4 => sub { $_[0]->asciidoc->heading(5,\@_) },
    for => sub { },
    begin => sub { },
    back => sub { shift->end_list(@_) },
    item => sub { shift->list_item(@_) },
    over => sub { shift->start_list(@_) },
    B => sub { $_[0]->asciidoc->bold(\@_) },
    C => sub { $_[0]->asciidoc->code(\@_) },
    L => sub { $_[0]->asciidoc->anchor(\@_) },
    start_verbatim => sub { $_[0]->asciidoc->start_verbatim(\@_) },
    verbatim => sub { $_[0]->asciidoc->verbatim(\@_) },
    end_verbatim => sub { $_[0]->asciidoc->end_verbatim(\@_) }
);

$end_block = sub { '' };

sub asciidoc {
    return $_[0]->{'asciidoc'}
}

sub end_block {
    my ($self) = @_;
    my @result = $self->{'end_block'}->();
    my $outfh = $self->output_handle;
    print $outfh @result;
}

sub initialize {
    my ($self) = @_;
    $self->SUPER::initialize();
    $self->{'end_block'} = $end_block;
    unless($self->asciidoc) {
        $self->{'asciidoc'} = Pod::Asciidoc::Format->new;
    }
}

{

    sub command {
        my ($self,$command,$text,$linenum,$podpara) = @_;
        return if $command eq 'pod';

        $self->end_block;

        my @result;
        $text = $self->interpolate($text,$linenum);
        if(exists $convert{$command}) {
            @result = $convert{$command}->($self,$text,$podpara);
        }
        my $out = $self->output_handle();
        print $out @result;
}


    my $in_verbatim = 0;
    sub verbatim {
        my ($self,$block,$linenum) = @_;
        return if $block =~ /^\s*$/;
        my @result;

        unless($in_verbatim) {
            if(exists $convert{'start_verbatim'}) {
                push @result, $convert{'start_verbatim'}->($self,$block);
            }
            $self->{'end_block'} = sub {
                my @end_verbatim;
                if(exists $convert{'end_verbatim'}) {
                    @end_verbatim = $convert{'end_verbatim'}->($self);
                }
                $in_verbatim = 0;
                $self->{'end_block'} = $end_block;
                return @end_verbatim;
            };
            $in_verbatim = 1;
        }

        if(exists $convert{'verbatim'}) {
            push @result, $convert{'verbatim'}->($self,$block);
        }
        else {
            push @result, $block;
	}
        my $out = $self->output_handle();
        print $out @result;
    }

    sub textblock {
        my ($self,$text,$line_num,$pod_para) = @_;

        my @result;
        $self->interpolate($text,$line_num);
        if(exists $convert{'textblock'}) {
            push @result, $convert{'textblock'}->($self,$text,$pod_para);
        }
        else {
            push @result, $text;
	}

        my $out = $self->output_handle();
        print $out @result;
    }

    my $listlevel = 0;
    sub start_list {

        my ($self,@args) = @_;
        $listlevel++;

        #Dumper(\@args);

        ''
    }

    sub list_item {
        my ($self,$text,$paragraph) = @_;
        $text = $self->interpolate($text);
        return $self->asciidoc->item($listlevel,$text);
    }

    sub end_list {
        my ($self,@args) = @_;
        $listlevel--;

        #Dumper(\@args);
        ''
    }
};

sub interior_sequence {
    my ($self,$cmd,$text) = @_;
    if(exists $convert{$cmd}) {
        return $convert{$cmd}->($self,$text);
    }
    return $text;
}

use Data::Dumper;

1;

__END__

=encoding utf8

=head1 NAME

Pod::Asciidoc - preprocess POD for docbook and html conversion

=head1 SYNOPSIS

    use Pod::Asciidoc;

    my $parser = Pod::Asciidoc->new;
    $parser->parse_from_file($filename,$outfh);

=head1 DESCRIPTION

Using this module isn't different from other POD conversion modules.
Thatswhy this description documents the way how to customize the
asciidoc output.

This package stores the conversion functionality in a global hash,
with pod commands and formats as keys and code references as values.
Most of this code references are delegations to a L<Pod::Asciidoc::Format>
object. This object provides finer control over the formating. This way
it is  easy to override maybe local some parts of the general conversion
process.

=head2 Constructor

During construction you can set your own formatting object.

    my $format = Pod::Asciidoc::Format->new(headings => [qw/+ = - ~ ^ "/]);
    my $parser = Pod::Asciidoc->new(asciidoc => $format);

=head2 Defined Pod Formatting Keys

=over 4

=item C<head1>, C<head2>, C<head3> and C<head4>

=item C<start_verbatim>, C<verbatim> and C<end_verbatim>

=item C<B> and C<C>

=back


