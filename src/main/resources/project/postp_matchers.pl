@::gMatchers = (
  {
        id =>           "EnvironmentError",
        pattern =>      q{'brakeman'\sis\snot\srecognized\sas.*},
        action =>       q{&addSimpleError("EnvironmentError", "'brakeman' is not in your PATH environment variable");setProperty("outcome", "error" );updateSummary();},
  },
  {
    id =>               "AppPathMissing",
    pattern =>          q{.*Please\ssupply\sthe\spath\sto\sa\sRails\sapplication.*},
    action =>           q{&addSimpleError("AppPathMissing", "Error: Invalid Application Path");setProperty("outcome", "error" );updateSummary();},
  },
  {
    id =>               "ReportCreated",
    pattern =>          q{.*Report\ssaved\sin.*},
    action =>           q{&addSimpleError("ReportCreated", "Report generated correctly");updateSummary();},
  },
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub updateSummary() {    
    my $summary = (defined $::gProperties{"EnvironmentError"}) ? $::gProperties{"EnvironmentError"} . "\n" : "";
    $summary .= (defined $::gProperties{"AppPathMissing"}) ? $::gProperties{"AppPathMissing"} . "\n" : "";
    $summary .= (defined $::gProperties{"ReportCreated"}) ? $::gProperties{"ReportCreated"} . "\n" : "";

    setProperty ("summary", $summary);
}
