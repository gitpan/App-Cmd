package App::Cmd::Subdispatch::DashedStyle;
use base qw/App::Cmd::Subdispatch/;

=head1 NAME

App::Cmd::Subdispatch::DashedStyle - "app cmd --subcmd" style subdispatching

=head1 VERSION

  $Id: /my/cs/projects/app-cmd/trunk/lib/App/Cmd/Subdispatch/DashedStyle.pm 25152 2006-08-25T23:34:47.955138Z rjbs  $

=cut

use strict;
use warnings;

=head1 METHODS

=head2 get_command

  my ($subcommand, $opt, $args) = $subdispatch->get_command(@args)

A version of get_command that chooses commands as options in the following
style:

  mytool mycommand --mysubcommand

=cut

sub get_command {
	my ($self, @args) = @_;

	my (undef, $opt, @sub_args)
    = $self->App::Cmd::Command::prepare($self->app, @args);

	if (my $cmd = delete $opt->{subcommand}) {
		delete $opt->{$cmd}; # useless boolean
		return ($cmd, $opt, @sub_args);
	} else {
    return (undef, $opt, @sub_args);
  }
}

sub prepare_default_command {
  my ( $self, $opt, @args ) = @_;
  $self->_prepare_command( "help" );
}

=head2 opt_spec

A version of C<opt_spec> that calculates the getopt specification from the
subcommands.

=cut

sub opt_spec {
	my ($self, $app) = @_;

	my $subcommands = $self->_command;
	my %plugins = map {
		$_ => [ $_->command_names ],
	} values %$subcommands;

	foreach my $opt_spec (values %plugins) {
		$opt_spec = join("|", grep { /^\w/ } @$opt_spec);
	}

	my @subcommands = map { [ $plugins{$_} =>  $_->abstract ] } keys %plugins;

	return (
		[ subcommand => hidden => { one_of => \@subcommands } ],
		$self->global_opt_spec($app),
		{ getopt_conf => [ 'pass_through' ] },
	);
}

1;
