
# Data that drives the create step picker registration for this plugin.
my %runBrakeman = (
    label       => "Brakeman - Run Brakeman",
    procedure   => "RunBrakeman",
    description => "Integrates Brakeman functions into Electric Commander",
    category    => "Utility"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Brakeman");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Brakeman - Run Brakeman");

@::createStepPickerSteps = (\%runBrakeman);
