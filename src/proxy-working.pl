#!/usr/bin/perl -Tw
use strict;

## Copyright (c) 1996 by Randal L. Schwartz, Piotr F. Mitros
## This program is free software; you can redistribute it
## and/or modify it under the same terms as Perl itself.

## Anonymous HTTP proxy (handles http:, gopher:, ftp:)
## requires LWP 5.04 or later

my $HOST = "localhost";
my $PORT = "9000";

sub prefix {
  my $now = localtime;

  join "", map { "[$now] [${$}] $_\n" } split /\n/, join "", @_;
}

$SIG{__WARN__} = sub { warn prefix @_ };
$SIG{__DIE__} = sub { die prefix @_ };
$SIG{CLD} = $SIG{CHLD} = sub { wait; };

my $AGENT;                      # global user agent (for efficiency)
BEGIN {
  use LWP::UserAgent;

  @MyAgent::ISA = qw(LWP::UserAgent); # set inheritance

  $AGENT = MyAgent->new;
  $AGENT->agent("anon/0.07");
  $AGENT->env_proxy;
}

sub MyAgent::redirect_ok { 0 } # redirects should pass through

{                               ### MAIN ###
  use HTTP::Daemon;

  my $master = new HTTP::Daemon
    LocalAddr => $HOST, LocalPort => $PORT;
  warn "set your proxy to <URL:", $master->url, ">";
  my $slave;
  &handle_connection($slave) while $slave = $master->accept;
  exit 0;
}                               ### END MAIN ###

sub handle_connection {
  my $connection = shift;       # HTTP::Daemon::ClientConn

  my $pid = fork;
  if ($pid) {                   # spawn OK, and I'm the parent
    close $connection;
    return;
  }
  ## spawn failed, or I'm a good child
  my $request = $connection->get_request;
  if (defined($request)) {
    my $response = &fetch_request($request);
    $connection->send_response($response);
    close $connection;
  }
  exit 0 if defined $pid;       # exit if I'm a good child with a good parent
}

sub fetch_request {
  my $request = shift;          # HTTP::Request

  use HTTP::Response;

  my $url = $request->url;
  warn "fetching $url";
  if ($url->scheme !~ /^(http|gopher|ftp)$/) {
    my $res = HTTP::Response->new(403, "Forbidden");
    $res->content("bad scheme: @{[$url->scheme]}\n");
    $res;
  } elsif (not $url->rel->netloc) {
    my $res = HTTP::Response->new(403, "Forbidden");
    $res->content("relative URL not permitted\n");
    $res;
  } else {
    &fetch_validated_request($request);
  }
}

sub min {
    my $x=shift;
    my $y=shift;
    if ($y>$x) {
	$x;
    }
    else {
	$y;
    }
}

sub max {
    my $x=shift;
    my $y=shift;
    if ($y>$x) {
	$y;
    }
    else {
	$x;
    }
}

sub negg_parse_content {
    my $content = shift;
    my $line = "";
    my $x=0;
    my $y=0;
    my @lines;
    my @matrix;
    @lines = split("\n", $content);
    foreach $line (@lines) {
	if($line eq "<tr bgcolor='white'>") {
	    $y++; $x=0;
	}
	if($line =~ /td align=center width=30 height=30/) {
	    if($line =~ /nbsp/) {
		$matrix[$x++][$y]=" ";
	    }
	    elsif($line =~ /gn.gif/) {
		$matrix[$x++][$y]="Q";
	    }
	    elsif($line =~ /flagnegg/) {
		$matrix[$x++][$y]="X";
	    }
	    elsif($line =~ /badnegg/) {
		return 0;
	    }
	    else {
		$line =~ s/.*b.(.)..b.*/$1/;
		$matrix[$x++][$y]=$line;
	    }
	}
    }
    $x--;
    if($x != $y) {
	return 0;
    }
    else {
	my $x2;
	my $y2;
	for $y2 (0 .. $y) {
	    for $x2 (0 .. $x) {
		print $matrix[$x2][$y2];
	    }
	    print "\n";
	}

	for $y2 (0 .. $y) {
	    for $x2 (0 .. $x) {
		if($matrix[$x2][$y2] =~ /[123456789]/) {
		    my $xx=0;
		    my $qq=0;
		    my $x3=0;
		    my $y3=0;
		    for $y3 (max(0, $y2-1) .. min($y, $y2+1)) {
			for $x3 (max(0, $x2-1) .. min($x, $x2+1)) {
			    if($matrix[$x3][$y3] eq 'X') {
				$xx++;
			    }
			    elsif($matrix[$x3][$y3] eq 'Q') {
				$qq++;
			    }
			}
		    }
		    if(($qq > 0) && ($matrix[$x2][$y2]-$xx == 0)) {
			print "Clear around ". $x2.",".$y2."\n";
			for $y3 (max(0, $y2-1) .. min($y, $y2+1)) {
			    for $x3 (max(0, $x2-1) .. min($x, $x2+1)) {
				if($matrix[$x3][$y3] eq 'Q') {
				    return 'position='.$x3.'-'.$y3.'&flag_negg=';
				}
			    }
			}
		    }
		    if(($qq > 0) &&($matrix[$x2][$y2]-$xx == $qq)) {
			print "Bombs around ". $x2.",".$y2."\n";
			for $y3 (max(0, $y2-1) .. min($y, $y2+1)) {
			    for $x3 (max(0, $x2-1) .. min($x, $x2+1)) {
				if($matrix[$x3][$y3] eq 'Q') {
				    return 'position='.$x3.'-'.$y3.'&flag_negg=1';
				}
			    }
			}
		    }	
		}
	    }
	}
    }
    return 0;
}

sub slashdot_clear {
    my $content = shift;
    my $i;
    my @lines;
    @lines = split("\n", $content);

    for $i (4 .. 34) {
	$lines[$i]='';
    }

    $content=join "\n",@lines;

    print "Validating slashdot content\n";
    $content;
}

sub dilbert_clear {
    print "Validating unitedmedia content\n";
    my $content = shift;
    my $i;
    my @lines;
    my $j;
    @lines = split("\n", $content);

    for $i (0 .. $#lines) {
	if($lines[$i] =~ /<.-- Dilbert Ad Tag.*Begin -->/){
	    print "found ad\n";
	    for $j (-2..3) {
		$lines[$i+$j]='';
	    }
	}
    }

    $content=join "\n",@lines;

    $content;
}

sub doubleclick_clear {
    my $content = shift;
    $content =~ s/<[^<>]*doubleclick.net[^<>]*>//g;
    $content =~ s/<[^<>]*rmedia.boston.com\/RealMedia\/ads\/[^<>]*>//g;

    $content;
}

sub fetch_validated_request { # return HTTP::Response
  my $request = shift;  # HTTP::Request

  print $request->content();

  my $response = $AGENT->request($request);
  my $nrc;

  # Automate NeggSweeper
  if($request->url() eq 'http://www.neopets.com/games/neggsweeper/neggsweeper.phtml') {
      while(($nrc = negg_parse_content($response->content())) ) {
	  $request->content($nrc);
	  $response = $AGENT->request($request);
      }
  }

  if($request->url() =~ /^http:\/\/slashdot.org\//) {
      $response->content(slashdot_clear($response->content()));
  }

  if(($request->url() =~ /^http:\/\/www.unitedmedia.com\//)  ||
     ($request->url() =~ /^http:\/\/www.dilbert.com\//) ) {
      $response->content(dilbert_clear($response->content()));
  }

  $response->content(doubleclick_clear($response->content()));

  $response;
}
