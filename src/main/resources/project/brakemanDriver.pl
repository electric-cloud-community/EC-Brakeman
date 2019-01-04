###########################################################################
# Package
#    brakemanDriver.pl
#
# Dependencies
#    -none
#
# Purpose
#    Perl script to integrate Brakeman functionality into Electric Commander
#
# Date
#    17/08/2012
#
# Engineer
#    Bryan Barrantes
#
# Copyright (c) 2012 Electric Cloud, Inc.
# All rights reserved
###########################################################################
    
# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;    
use warnings;
use ElectricCommander;

local $| = 1;
#############################################################################
=head2 proc1
  Title    : main
  Usage    : main();
  Function : Creates a brakeman command line with the given parameters, and make the call to command
             line to analyze a Rails application code, in order to find security issues
  Returns  : none
  Args     : named arguments: Comming from Commander
           :
=cut
#############################################################################
sub main {
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);    
    
    # Constants    
    my $empty = q{};
    my $quotes = qq{"};    
    my $command = $empty;
    
    # Params
    my $appPath           = ($ec->getProperty( "appPath" ))->findvalue('//value')->string_value;
    my $reportFile        = ($ec->getProperty( "reportFile" ))->findvalue('//value')->string_value;
    my $verbosity         = ($ec->getProperty( "verbosity" ))->findvalue('//value')->string_value;    
    my $IgModelOutput     = ($ec->getProperty( "imo" ))->findvalue('//value')->string_value;    
    my $confidence        = ($ec->getProperty( "confidence" ))->findvalue('//value')->string_value;
    my $additionalOps     = ($ec->getProperty( "additionalOps" ))->findvalue('//value')->string_value;
    
    # Print plugin Info
    my $pluginKey = 'EC-Brakeman';
    my $xpath = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n\n";
        
    # Validate Parameters    
    if($appPath eq $empty or $verbosity eq $empty){
        $ec->setProperty("outcome","error");
        print "Error: Some of the parameters are invalid.\n";
		return;
    }
    
    # Build Command    
    $command = qq{brakeman }.$quotes.$appPath.$quotes;     
    # Check verbosity
    if($verbosity eq "quiet") {
        $command .= qq{ -q};
    } elsif ($verbosity eq "debug"){
        $command .= qq{ -d};
    } #else{}
    
    # Check Ignore Model Output
    if($IgModelOutput eq "1"){
        $command .= qq{ --ignore-model-output};
    }    
    # Check confidence level
    if($confidence ne $empty){
        $command .= qq{ -w}.$confidence;
    }    
    # Check additional options
    if($additionalOps ne $empty){
        $command .= qq{ }.$additionalOps;
    }    
    # Check output file
    if($reportFile ne $empty){
        my $filename = qq{report_}.time;
        if($reportFile eq "html"){
            $filename.=qq{.html};
        } elsif ($reportFile eq "text"){
            $filename.=qq{.txt};
        } elsif ($reportFile eq "csv"){
            $filename.=qq{.csv};
        } else{#tabs
            $filename.=qq{.tab};
        }
        $command .= qq{ -o }.$filename;
        
        # Create a link for the generated report in the job step detail
        $ec->setProperty("/myJob/artifactsDirectory", "");
        $ec->setProperty("/myJob/report-urls/Brakeman Report", 
				   "jobSteps/$[jobStepId]/" . $filename);
    }
    print $command;
    $ec->setProperty("/myCall/BrakemanCommandLine", $command);    
}

main();

1;
