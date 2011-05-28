

#    Nagios Business Process View and Nagios Business Process Analysis
#    Copyright (C) 2003-2010 Sparda-Datenverarbeitung eG, Nuernberg, Germany
#    Bernd Stroessreuther <berny1@users.sourceforge.net>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; version 2 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


package bsutils;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(printArray printHash fixedLen cutOffSpaces getHostnameFromUrl getProtocolFromUrl);


=head1 NAME

 bsutils - Some functions quite often used (I do not want to rewrite every time)

=head1 SYNOPSIS

	use bsutils;

	printArray(\@a);
	printArray(\@a, "DEBUG: ");

	printHash(\%h);
	printHash(\%h, "    ");  # e. g. if you want to print intended
	
	print fixedLen("aVeryLongStringWithoutAnySpace", 20, "right") . "\n";
	# prints out: aVeryLongStringWitho
	
	$c = "short";
	$c = fixedLen($c, 20, undef, ".");
	# $c is now: short...............

	$string = cutOffSpaces("foo   ");
	# $string = "foo"

	$hostname = getHostnameFromUrl("http://www.example.com:80/foo/");
	# $hostname = "www.example.com";
	$hostname = getHostnameFromUrl("http://myworkstation.example.com", "s");
	# $hostname = "myworkstation";

	print getProtocolFromUrl("https://www.example.com/test/") ."\n";
	# https
	$p = getProtocolFromUrl("www.example.com");
	# $p = "http";

=head1 DESCRIPTION

=head2 bsutils::printArray 

	bsutils::printArray(\@array [, $prefix])
	
	prints out the content of an array in a structured way
	
	parameter 1: reference to an array
	parameter 2: prefix for every line of output
	returns:     nothing of value

=cut

sub printArray
{
	my $array = shift;
	my $prefix = shift;
	my ($i, $len);
	
	$len=length(@$array - 1);
	#print "len: $len\n";
	for ($i=0; $i<@$array; $i++)
	{
		$i = sprintf("%0${len}d", $i);
		print "${prefix}[$i]: $array->[$i]\n";
	}
}

=head2 bsutils::printHash

	bsutils::printHash(\%hash [, $prefix])
	
	prints out the content of a hash in a structured way
	
	parameter 1: reference to a hash
	parameter 2: prefix for every line of output
	returns:     nothing of value

=cut

sub printHash
{
	my $hash = shift;
	my $prefix = shift || "";
	my ($key);
	my $maxlen = 0;

	foreach $key (keys %$hash)
	{
		if (length($key) > $maxlen)
		{
			$maxlen = length($key);
		}
	}
	#print "max: $maxlen\n";

	foreach $key (keys %$hash)
	{
		print "${prefix}" . fixedLen("[$key]", $maxlen+2, "left") . " => $hash->{$key}\n";
		# print "${prefix}[$key] => $hash->{$key}\n";
	}
}

=head2 bsutils::fixedLen

	bsutils::fixedLen($string [, $len [, "left"|"right" [, $fillchar]]])
	
	brings a given string to a fixed length and returns the string afterwards
	no matter if it is shorter or longer before
	
	parameter 1: the string
	parameter 2: the desired length (integer), defaults to 10 if omitted
	parameter 3: "left" or "right": tells on which side blanks are appended or characters are cut off
	parameter 4: fillcharacter: 1 character, which should be used to fill up short strings
	             defaults to blank " "
	returns:     the resulting string

=cut

sub fixedLen
{
	my $string = shift;
	my $len = shift || 10;
	my $side = shift || "right";
	my $fillchar = shift || " ";
	my $fillstring;
	
	if (length($string) > $len)
	{
		if ($side eq "left")
		{
			$string = substr($string, $len*(-1));
		}
		else
		{
			$string = substr($string, 0, $len);
		}
	}
	if (length($string) < $len)
	{
		$fillchar = substr($fillchar, 0, 1);
		$fillstring = $fillchar x ($len-length($string));
		if ($side eq "left")
		{
			$string = $fillstring . $string;
		}
		else
		{
			$string .= $fillstring;
		}
	}
	
	return $string;
}

=head2 bsutils::cutOffSpaces

	bsutils::cutOffSpaces($string)
	
	cuts of leading and trailing whitespace characters of a given string

	parameter 1: the string
	returns:     the resulting string

=cut

sub cutOffSpaces
{
        my $string = shift;
	$string =~ s/^\s*//;
	$string =~ s/\s*$//;
	# does the same as the two lines above, but takes twice as long
	#$string =~ s/^\s*(.*?)\s*$/$1/;
        return ($string);
}

=head2 bsutils::getHostnameFromUrl

	bsutils::getHostnameFromUrl($URL [, "s"|"l"])
	
	from a given URL, we extract the hostname
	give "s" as second parameter to get the short hostname (everything before the first dot)
	give "l" or leave empty, to get the full qualified hostname, if it is in the URL as full qualified name

	parameter 1: the URL
	parameter 2: the return modifier
	returns:     the hostname as string

=cut

sub getHostnameFromUrl
{
	my $url = shift;
	my $switch = shift;

	if ($switch eq "s")
	{
		# if an IP is used instead a hostname there is no sense in cutting after the first dot
		if ($url =~ m/^(.+:\/\/)?(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/)
		{
			if (defined($2))
			{
				return($2);
			}
			else
			{
				return($1);
			}
		}

		$url =~ m/^(.+:\/\/)?([^.:\/]+)/;
		if (defined($2))
		{
			return($2);
		}
		else
		{
			return($1);
		}
	}
	else
	{
		$url =~ m/^(.+:\/\/)?([^:\/]+)/;
		if (defined($2))
		{
			return($2);
		}
		else
		{
			return($1);
		}
	}
	return(undef);
}

=head2 bsutils::getProtocolFromUrl

	bsutils::getProtocolFromUrl($URL)
	
	from a given URL, we extract the protocol

	parameter 1: the URL
	returns:     the protocol as string

=cut

sub getProtocolFromUrl
{
	my $url = shift;
	$url =~ m/^(.+):\/\//;
	if (defined($1))
	{
		return($1);
	}
	else
	{
		return("http");
	}
}

=head1 AUTHOR

Bernd Stroessreuther <berny1@users.sourceforge.net>

=cut


return (1);
