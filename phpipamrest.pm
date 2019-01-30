#!/usr/bin/perl
package PhpIpam;
use Class::Tiny qw(url, app_id, token, client);

use strict;
use warnings;

use REST::Client;
use JSON;
use Data::Dumper;
use MIME::Base64;

sub BUILD {
    my ($self, $args) = @_;
    return unless $args->{url};
    return unless $args->{user};
    return unless $args->{pass};
    return unless $args->{app_id};
    $self->authenticate($args->{url}, $args->{user}, $args->{pass}, $args->{app_id});
}

sub authenticate {
    my $self   = shift;
    my $url    = shift;
    my $user   = shift;
    my $pass   = shift;
    my $app_id = shift;
    
    $self->url    = $url;
    $self->app_id = $app_id;

    my $headers = {
	Accept => 'application/json',  
	Authorization => 'Basic ' . encode_base64($user . ':' . $pass),
	#                      ^ note the space here                      
    };

    $self->client = REST::Client->new();
    $self->client->POST($url . '/api/' . $app_id . '/user','',$headers);
    die "Was NOT able to authenticate! $!\n" unless $client->responseCode() eq '200';
    my $content = decode_json($client->responseContent());
    $self->token = $content->{'data'}{'token'};
}

sub sections_get_all {
    my $self = shift;
    
    $headers = {
	Accept => 'application/json',  
	token  => $self->token,
    };

    $self->client->GET($self->url . '/api/' . $self->app_id . '/sections',$headers);
    die "Was NOT able to authenticate! $!\n" unless $client->responseCode() eq '200';
    print Dumper(decode_json($client->responseContent()));
}

